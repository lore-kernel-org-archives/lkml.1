Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbZKCKZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbZKCKZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 05:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZKCKZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 05:25:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZKCKZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 05:25:07 -0500
Date: Tue, 3 Nov 2009 11:25:09 +0100
From: Jan Blunck <jblunck@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH 01/27] BKL: Push down BKL from do_new_mount() to the filesystems get_sb/fill_super operation
Message-ID: <20091103102509.GL21750@bolzano.suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-2-git-send-email-jblunck@suse.de> <20091102171147.GG21750@bolzano.suse.de> <20091103101212.GA20314@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103101212.GA20314@infradead.org>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, Christoph Hellwig wrote:

> On Mon, Nov 02, 2009 at 06:11:47PM +0100, Jan Blunck wrote:
> > Attached is a new version of the patch that includes the changes for
> > filesystems outside of fs/ directory as well. Besides that I trimmed the CC
> > list this time.
> 
> For the next spin please don't push it down to filesystems that
> obviously don't need it at all and just mention them in the patch
> description.  For filesystems like xfs and btrfs that never used the BKL
> at all that should make life a bit simpler.

My plan was to remove the BKL in the obvious cases in the followup patches
that are also included in the series. So should I just merge the obvious stuff
into one patch? Christian Borntraeger was actually requesting the opposite. He
wants to be able to bisect it to the patch that is removing the BKL. That
would be much simple with many small patches I think.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
