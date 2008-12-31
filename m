Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYLaWSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYLaWSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 17:18:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYLaWSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 17:18:21 -0500
Received: from relay1.sgi.com ([192.48.179.29]:34117 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752756AbYLaWSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 17:18:21 -0500
Message-ID: <495BEFA9.80804@sgi.com>
Date: Wed, 31 Dec 2008 14:18:17 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: Fix incorrect __read_mostly on _boot_cpu_pda
References: <20081231214446.GA6856@localdomain>
In-Reply-To: <20081231214446.GA6856@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai wrote:
> The pda rework (commit 3461b0af025251bbc6b3d56c821c6ac2de6f7209)
> to remove static boot cpu pdas introduced a bug.  _boot_cpu_pda is the
> actual pda used by the boot cpu and is definitely not "__read_mostly" and
> ended up polluting the read mostly section with writes.  This bug caused
> regression of about 8-10% on certain syscall intensive workloads.
> 
> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> 
> Index: linux-2.6/arch/x86/kernel/head64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/head64.c	2008-12-30 15:28:08.000000000 -0800
> +++ linux-2.6/arch/x86/kernel/head64.c	2008-12-31 10:36:21.000000000 -0800
> @@ -27,7 +27,7 @@
>  #include <asm/trampoline.h>
>  
>  /* boot cpu pda */
> -static struct x8664_pda _boot_cpu_pda __read_mostly;
> +static struct x8664_pda _boot_cpu_pda;
>  
>  #ifdef CONFIG_SMP
>  /*

Thanks for catching that!

Mike
