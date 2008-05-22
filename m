Return-Path: <linux-kernel-owner+w=401wt.eu-S933496AbYEVMCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbYEVMCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756998AbYEVMCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:02:40 -0400
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2337 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672AbYEVMCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:02:39 -0400
Date: Thu, 22 May 2008 14:02:31 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/14] hfsplus: remove hfsplus_permission()
In-Reply-To: <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0805221358080.18302@localhost.localdomain>
References: <20080521171458.077908538@szeredi.hu> <20080521171549.964767446@szeredi.hu>
 <Pine.LNX.4.64.0805212232500.18302@localhost.localdomain>
 <E1Jz5gq-0007F4-AQ@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 22 May 2008, Miklos Szeredi wrote:

> > No, it's not, it allows for HFS+ specific special case to allow the lookup 
> > of the resource fork.
> 
> Sorry I just don't see how that code would allow anything.  The only
> place hfsplus_permission() is called is from permission() in namei.c,
> and in that case it _is_ equivalent.  Look:
> 
> hfsplus_permission():
> 
> 	if (S_ISREG(inode->i_mode) && mask & MAY_EXEC && !(inode->i_mode & 0111))
> 		return 0;
> 
> permission():
> 
> 		retval = inode->i_op->permission(inode, submask, nd);
> 		if (!retval) {
> 			/*
> 			 * Exec permission on a regular file is denied if none
> 			 * of the execute bits are set.
> 			 *
> 			 * This check should be done by the ->permission()
> 			 * method.
> 			 */
> 			if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode) &&
> 			    !(inode->i_mode & S_IXUGO))
> 				return -EACCES;

That check didn't used to be there and that the HFS+ check is older than 
that might have given you the idea that it at least used to work.
So now the only way for a fs to differentiate between lookup and exec is 
gone... :-(

bye, Roman
