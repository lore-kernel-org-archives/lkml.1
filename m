Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbXI0V1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbXI0V1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbXI0V1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:27:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40077 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbXI0V1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:27:20 -0400
Subject: Re: [RFC][PATCH] make reiserfs stop using 'struct file' for
	internal xattr operations
From: Dave Hansen <haveblue@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
In-Reply-To: <20070927210423.GA6117@infradead.org>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	 <46FC021F.8060109@free.fr>
	 <20070927124833.d2691813.akpm@linux-foundation.org>
	 <20070927202607.GA3812@infradead.org> <1190926419.7344.27.camel@localhost>
	 <20070927210423.GA6117@infradead.org>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 14:27:14 -0700
Message-Id: <1190928434.7344.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-27 at 22:04 +0100, Christoph Hellwig wrote:
> On Thu, Sep 27, 2007 at 01:53:39PM -0700, Dave Hansen wrote:
> > -int reiserfs_commit_write(struct file *f, struct page *page,
> > -			  unsigned from, unsigned to);
> > -int reiserfs_prepare_write(struct file *f, struct page *page,
> > -			   unsigned from, unsigned to);
> > +int reiserfs_commit_write(struct page *page, unsigned from, unsigned to);
> > +int reiserfs_prepare_write(struct page *page, unsigned from, unsigned to);
> 
> I doubt this will work.  These are also used for the ->prepare_write
> and ->commit_write aops, and the method signature definitively wants
> a file there, even if it's zero..

Oddly enough, I don't see those functions being used in aops:

const struct address_space_operations reiserfs_address_space_operations = {
        .writepage = reiserfs_writepage,
        .readpage = reiserfs_readpage,
        .readpages = reiserfs_readpages,
        .releasepage = reiserfs_releasepage,
        .invalidatepage = reiserfs_invalidatepage,
        .sync_page = block_sync_page,
        .write_begin = reiserfs_write_begin,
        .write_end = reiserfs_write_end,
        .bmap = reiserfs_aop_bmap,
        .direct_IO = reiserfs_direct_IO,
        .set_page_dirty = reiserfs_set_page_dirty,
};

Plus, reiserfs seems to compile with that patch I just sent.  Sure as
heck surprised me.

-- Dave

