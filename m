Return-Path: <linux-kernel-owner+w=401wt.eu-S1765264AbYEATXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765264AbYEATXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759667AbYEATXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:23:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756119AbYEATW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:22:59 -0400
Date: Thu, 1 May 2008 12:21:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: ezk@cs.sunysb.edu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org, mhalcrow@us.ibm.com, hugh@veritas.com
Subject: Re: [2.6.26 PATCH, RESEND]: fs_stack/eCryptfs: fsstack_copy_*
 updates
Message-Id: <20080501122136.bc2215c9.akpm@linux-foundation.org>
In-Reply-To: <200805011718.m41HI9Ex027053@agora.fsl.cs.sunysb.edu>
References: <20080430101704.9cbd6384.akpm@linux-foundation.org>
	<200805011718.m41HI9Ex027053@agora.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 13:18:09 -0400
Erez Zadok <ezk@cs.sunysb.edu> wrote:

> In message <20080430101704.9cbd6384.akpm@linux-foundation.org>, Andrew Morton writes:
> [...[
> > Can we avoid having to think?
> > 
> > void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
> > {
> > 	blkcnt_t i_blocks;
> > 	loff_t i_size;
> > 
> > 	i_size = i_size_read(src);
> > 	spin_lock_32bit(&src->i_lock);
> > 	i_blocks = src->i_blocks;
> > 	spin_unlock_32bit(&src->i_lock);
> > 
> > 	i_size_write(dst, i_size);
> > 	spin_lock_32bit(&dst->i_lock)
> > 	dst->i_blocks = i_blocks;
> > 	spin_unlock_32bit(&dst->i_lock)
> > }
> 
> I can't find spin_[um]lock_32bit anywhere (checkd latest mmotm and linus's
> tree).  I therefore assume this was just your way of saying I should:
> 
> #if BITS_PER_LONG == 32
> 	spin_unlock(&dst->i_lock);
> #endif

Nope, it was my way of suggesting that you implement it ;)
include/linux/spinlock.h would be a good place.

