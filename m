Return-Path: <linux-kernel-owner+w=401wt.eu-S1765539AbYD3VK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765539AbYD3VK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759779AbYD3VKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:10:32 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34083 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764949AbYD3VK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:10:29 -0400
Date: Wed, 30 Apr 2008 17:09:15 -0400
Message-Id: <200804302109.m3UL9FBj031457@agora.fsl.cs.sunysb.edu>
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
> On Mon, 21 Apr 2008 02:50:42 -0400
> Erez Zadok <ezk@cs.sunysb.edu> wrote:
[...]
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

Thanks.  I can't say that I'm an expert in these SMP issues.  But I'll run
your rewritten function through my 32 and 64-bit SMP and non-SMP systems,
and see how it behaves.

Erez.
