Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbXEQSpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbXEQSpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbXEQSpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:45:04 -0400
Received: from verein.lst.de ([213.95.11.210]:34277 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbXEQSpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:45:01 -0400
Date: Thu, 17 May 2007 20:44:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uselib: add missing MNT_NOEXEC check
Message-ID: <20070517184414.GA19690@lst.de>
References: <20070517135526.GA28213@lst.de> <a36005b50705170914i17bd853bj638f5098c4e7d788@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50705170914i17bd853bj638f5098c4e7d788@mail.gmail.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 09:14:06AM -0700, Ulrich Drepper wrote:
> >        error = -EINVAL;
> >+       if (nd.mnt->mnt_flags & MNT_NOEXEC)
> >+               goto exit;
> 
> ... the error here should be EACCES.  Aside from that you get an ACK from 
> me.

updated patch below:

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2007-05-17 14:43:25.000000000 +0200
+++ linux-2.6/fs/exec.c	2007-05-17 19:42:49.000000000 +0200
@@ -134,6 +134,9 @@ asmlinkage long sys_uselib(const char __
 	if (error)
 		goto out;
 
+	error = -EACCES;
+	if (nd.mnt->mnt_flags & MNT_NOEXEC)
+		goto exit;
 	error = -EINVAL;
 	if (!S_ISREG(nd.dentry->d_inode->i_mode))
 		goto exit;
