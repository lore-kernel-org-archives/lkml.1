Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbZJRPaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbZJRPaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 11:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbZJRPaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 11:30:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbZJRPaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 11:30:16 -0400
Date: Sun, 18 Oct 2009 17:29:01 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] MIPS: VPE: Remove leftover unlock_kernel()
In-Reply-To: <alpine.LFD.2.00.0910181512200.3462@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0910181728040.3462@localhost.localdomain>
References: <alpine.LFD.2.00.0910181512200.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 18 Oct 2009, John Kacur wrote:

> Please push the following patch to Linus for 2.6.32-rc6.
> (or else drop 1bbfc20d0161cd94b1b8111566be2fa41b41b608)
> 
> From aaf663d27d2ce9641df5833163f47fdb9ba9c833 Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Sun, 18 Oct 2009 15:00:35 +0200
> Subject: [PATCH] MIPS: VPE: Remove leftover unlock_kernel()
> 
> commit 1bbfc20d0161cd94b1b8111566be2fa41b41b608
> was supposed to have removed the BKL, but there is a leftover and unpaired
> unlock_kernel call in the function vpe_open. Remove it.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  arch/mips/kernel/vpe.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
> index 03092ab..6047752 100644
> --- a/arch/mips/kernel/vpe.c
> +++ b/arch/mips/kernel/vpe.c
> @@ -1116,8 +1116,6 @@ static int vpe_open(struct inode *inode, struct file *filp)
>  	v->shared_ptr = NULL;
>  	v->__start = 0;
>  
> -	unlock_kernel();
> -
>  	return 0;
>  }
>  
> -- 
> 1.6.0.6
> 

Arghhh - my apologies, we really should remove the smp_lock.h include too.
Respun patch below.

>From c492799a4f89d1869dcf40d8c12d7a9ac530916f Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Sun, 18 Oct 2009 15:00:35 +0200
Subject: [PATCH] MIPS: VPE: Remove leftover unlock_kernel()

commit 1bbfc20d0161cd94b1b8111566be2fa41b41b608
was supposed to have removed the BKL, but there is a leftover and unpaired
unlock_kernel call in the function vpe_open. Remove it.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 arch/mips/kernel/vpe.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index 03092ab..2bd2151 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -38,7 +38,6 @@
 #include <linux/vmalloc.h>
 #include <linux/elf.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/syscalls.h>
 #include <linux/moduleloader.h>
 #include <linux/interrupt.h>
@@ -1116,8 +1115,6 @@ static int vpe_open(struct inode *inode, struct file *filp)
 	v->shared_ptr = NULL;
 	v->__start = 0;
 
-	unlock_kernel();
-
 	return 0;
 }
 
-- 
1.6.0.6

