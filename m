Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbXEIVa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbXEIVa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbXEIVaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:30:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48004 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbXEIVaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:30:21 -0400
Message-ID: <46423D62.2070200@garzik.org>
Date: Wed, 09 May 2007 17:30:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chuck Lever <chuck.lever@oracle.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NeilBrown <neilb@suse.de>, Adrian Bunk <bunk@stusta.de>
Subject: [bisect] NFS regression breaks X
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Original bug report, with hardware and software info:
http://lkml.org/lkml/2007/5/8/667

I love bisect :)  bisect has identified the following commit as the one 
that causes my GNOME login to die, within 10 seconds of logging in:

	commit 2bea90d43a050bbc4021d44e59beb34f384438db
	Author: Chuck Lever <chuck.lever@oracle.com>
	Date:   Thu Mar 29 16:47:53 2007 -0400

	SUNRPC: RPC buffer size estimates are too large

100% reproducible, verified regression.  My home directory is an NFSv4 
mount, and the problem appears on my client workstation, so this makes 
some sense:
> sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
> pretzel:/ on /g type nfs4 (rw,noatime,proto=tcp,addr=10.10.10.1)



As an aside, let me express the hope that the NFS developers develop 
better patch creation methods.  My bisect compile repeatedly died at

>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CHK     include/linux/compile.h
> fs/nfs/pagelist.c:239: error: conflicting types for ‘nfs_pageio_init’
> include/linux/nfs_page.h:80: error: previous declaration of ‘nfs_pageio_init’ was here
> make[2]: *** [fs/nfs/pagelist.o] Error 1
> make[1]: *** [fs/nfs] Error 2
> make: *** [fs] Error 2

which indicates that someone on the NFS team did not create 
wholly-contained patches when submitted to the kernel.  Build breakage 
should not be fixed in a later commit (unless the breakage already went 
upstream), because -- as we see here -- it breaks bisection.

	Jeff, occasionally guilty of same, and trying to reform


