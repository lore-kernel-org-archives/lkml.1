Return-Path: <linux-kernel-owner+w=401wt.eu-S1763341AbYEARTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763341AbYEARTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbYEARTC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:19:02 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39397 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYEARTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:19:00 -0400
Date: Thu, 1 May 2008 13:18:09 -0400
Message-Id: <200805011718.m41HI9Ex027053@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org, mhalcrow@us.ibm.com, hugh@veritas.com
Subject: Re: [2.6.26 PATCH, RESEND]: fs_stack/eCryptfs: fsstack_copy_* updates 
In-reply-to: Your message of "Wed, 30 Apr 2008 10:17:04 PDT."
             <20080430101704.9cbd6384.akpm@linux-foundation.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080430101704.9cbd6384.akpm@linux-foundation.org>, Andrew Morton writes:
[...[
> Can we avoid having to think?
> 
> void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
> {
> 	blkcnt_t i_blocks;
> 	loff_t i_size;
> 
> 	i_size = i_size_read(src);
> 	spin_lock_32bit(&src->i_lock);
> 	i_blocks = src->i_blocks;
> 	spin_unlock_32bit(&src->i_lock);
> 
> 	i_size_write(dst, i_size);
> 	spin_lock_32bit(&dst->i_lock)
> 	dst->i_blocks = i_blocks;
> 	spin_unlock_32bit(&dst->i_lock)
> }

I can't find spin_[um]lock_32bit anywhere (checkd latest mmotm and linus's
tree).  I therefore assume this was just your way of saying I should:

#if BITS_PER_LONG == 32
	spin_unlock(&dst->i_lock);
#endif

Erez.
