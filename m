Return-Path: <linux-kernel-owner+w=401wt.eu-S1751537AbZHKL4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbZHKL4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZHKL4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:56:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbZHKLye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:54:34 -0400
Date: Tue, 11 Aug 2009 11:33:16 +0200
From: Jan Kara <jack@suse.cz>
To: Al Boldi <a1426z@gawab.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH, RFC] ext3: Update Kconfig description of
	EXT3_DEFAULTS_TO_ORDERED
Message-ID: <20090811093316.GA23898@duck.suse.cz>
References: <1249934623-15939-1-git-send-email-tytso@mit.edu> <200908110649.20277.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908110649.20277.a1426z@gawab.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 11-08-09 06:49:20, Al Boldi wrote:
> Theodore Ts'o wrote:
> > +	  "data=ordered" mode can also result in major performance
> > +	  problems, including seconds-long delays before an fsync()
> > +	  call returns.	 For details, see:
> > +
> > +	  http://ext4.wiki.kernel.org/index.php/Ext3_data_mode_tradeoffs
> 
> Why isn't the fsync problem fixable?
  Because it's quite deep in the design of JBD: All the modifications done
to a filesystem go to one transactions. When the transaction grows big
enough or old enough, we commit the transaction, which means we write all
the metadata to the journal and all the ordered data to their final
location on disk. If you do fsync(), you have to wait for a transaction
commit with your data to finish, so that you are guaranteed a consistent
state of metadata is on disk. But when there is heavy background writing,
it means there's a lot of data you have to write out and wait for... It's
not easy to work around this - naively, you might want to separate out just
the writes you care about for fsync() but that's not easily possible
because bitmaps and group descriptors are modified by other writes as well.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
