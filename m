Return-Path: <linux-kernel-owner+w=401wt.eu-S936463AbXJTCd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936463AbXJTCd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 22:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbXJTCdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 22:33:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50001 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756978AbXJTCdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 22:33:35 -0400
Date: Fri, 19 Oct 2007 19:32:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT] NFS client fixes for 2.6.23++ 
In-Reply-To: <200710200219.l9K2JMI8015439@agora.fsl.cs.sunysb.edu>
Message-ID: <alpine.LFD.0.999.0710191929340.3794@woody.linux-foundation.org>
References: <200710200219.l9K2JMI8015439@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 19 Oct 2007, Erez Zadok wrote:
> 
> Trond, with Linus's latest tree, you need to #include <linux/sched.h> in
> fs/nfs/unlink.c, else I get:
> 
>   CC [M]  fs/nfs/unlink.o
> fs/nfs/unlink.c: In function 'nfs_dec_sillycount':
> fs/nfs/unlink.c:67: error: 'TASK_UNINTERRUPTIBLE' undeclared (first use in this function)
...

Hmm? Which architecture?

That said, I do think that there is a distinct lack of proper includes in 
that file. It seems to depend on getting much of the includes indirectly 
from <linux/nfs_fs.h> and friends. And with different architectures having 
different header files..

		Linus
