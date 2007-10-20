Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbXJTCZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbXJTCZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 22:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbXJTCZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 22:25:19 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53652 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbXJTCZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 22:25:18 -0400
Date: Fri, 19 Oct 2007 22:19:22 -0400
Message-Id: <200710200219.l9K2JMI8015439@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linus Torvalds <torvalds@osdl.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] NFS client fixes for 2.6.23++ 
In-reply-to: Your message of "Fri, 19 Oct 2007 17:23:13 EDT."
             <1192828993.7466.18.camel@heimdal.trondhjem.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1192828993.7466.18.camel@heimdal.trondhjem.org>, Trond Myklebust writes:
> Hi Linus,
> 
> Please pull from the repository at
> 
>    git pull git://git.linux-nfs.org/pub/linux/nfs-2.6.git
> 
> This will update the following files through the appended changesets.
> 
>   Cheers,
>     Trond

Trond, with Linus's latest tree, you need to #include <linux/sched.h> in
fs/nfs/unlink.c, else I get:

  CC [M]  fs/nfs/unlink.o
fs/nfs/unlink.c: In function 'nfs_dec_sillycount':
fs/nfs/unlink.c:67: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in
this function)
fs/nfs/unlink.c:67: error: (Each undeclared identifier is reported only once
fs/nfs/unlink.c:67: error: for each function it appears in.)
fs/nfs/unlink.c:67: error: 'TASK_INTERRUPTIBLE' undeclared (first use in
this function)
fs/nfs/unlink.c: In function 'nfs_block_sillyrename':
fs/nfs/unlink.c:196: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in
this function)
fs/nfs/unlink.c:196: error: implicit declaration of function 'schedule'
make[2]: *** [fs/nfs/unlink.o] Error 1
make[1]: *** [fs/nfs] Error 2
make: *** [fs] Error 2

Cheers,
Erez.
