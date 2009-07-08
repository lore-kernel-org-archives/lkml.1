Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZGHMXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZGHMXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 08:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbZGHMWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 08:22:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbZGHMWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 08:22:52 -0400
Date: Wed, 8 Jul 2009 14:22:50 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [rfc][patch 4/4] fs: tmpfs, ext2 use new truncate
Message-ID: <20090708122250.GP2714@wotan.suse.de>
References: <20090707144423.GC2714@wotan.suse.de> <20090707144918.GF2714@wotan.suse.de> <20090707163829.GB14947@infradead.org> <20090708065327.GM2714@wotan.suse.de> <20090708111420.GB20924@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708111420.GB20924@duck.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 01:14:20PM +0200, Jan Kara wrote:
> On Wed 08-07-09 08:53:27, Nick Piggin wrote:
> > On Tue, Jul 07, 2009 at 12:38:29PM -0400, Christoph Hellwig wrote:
> > > We can't move this to the caller easily.  ext2_delete_inode gets
> > > called for all inodes, but we only want to go on truncating for the
> > > limited set that passes this check.
> > 
> > Hmm, shouldn't they have no ->i_blocks in that case?
>   Not necessarily. Inode can have extended attributes set and those can
> be stored in a special block which is accounted in i_blocks.

OK fair enough. But I don't know if all those checks are
realy appropriate. For example an IS_APPEND inode should
be able to have its blocks trimmed off if a write fails.

