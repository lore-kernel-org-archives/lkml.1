Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYKCXey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYKCXey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 18:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYKCXep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 18:34:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbYKCXep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 18:34:45 -0500
Date: Mon, 3 Nov 2008 15:34:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, linux-arch@vger.kernel.org
Subject: Re: [PATCH] kernel/cpu.c: Section mismatch warning fix.
Message-Id: <20081103153425.7282ab84.akpm@linux-foundation.org>
In-Reply-To: <b9df5fa10810292104h38fcee68kae42cf5ab6275fbb@mail.gmail.com>
References: <b9df5fa10810292104h38fcee68kae42cf5ab6275fbb@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 10:04:54 +0600
"Rakib Mullick" <rakib.mullick@gmail.com> wrote:

>  LD      kernel/built-in.o
> WARNING: kernel/built-in.o(.text+0xb7c8): Section mismatch in
> reference from the function notify_cpu_starting() to the variable
> .cpuinit.data:cpu_chain
> The function notify_cpu_starting() references
> the variable __cpuinitdata cpu_chain.
> This is often because notify_cpu_starting lacks a __cpuinitdata
> annotation or the annotation of cpu_chain is wrong.
> 
> This patch fixes the above section mismatch warning. If anything else
> please notice.
> Thanks.
> 
> Signed-off-by: Md.Rakib H. Mullick <rakib.mullick@gmail.com>
> 
> --- linux-2.6-orig/kernel/cpu.c	2008-10-28 20:52:38.000000000 +0600
> +++ linux-2.6/kernel/cpu.c	2008-10-28 22:46:22.000000000 +0600
> @@ -462,7 +462,7 @@ out:
>   * It must be called by the arch code on the new cpu, before the new cpu
>   * enables interrupts and before the "boot" cpu returns from __cpu_up().
>   */
> -void notify_cpu_starting(unsigned int cpu)
> +void __cpuinit notify_cpu_starting(unsigned int cpu)
>  {
>  	unsigned long val = CPU_STARTING;

arch/alpha/kernel/smp.c calls notify_cpu_starting() from __init code.

arch/cris/arch-v32/kernel/smp.c calls notify_cpu_starting() from __init code.

arch/x86/mach-voyager/voyager_smp.c calls notify_cpu_starting() from
__init code.

arch/m32r/kernel/smpboot.c calls notify_cpu_starting() from __init code.

arch/sparc/kernel/sun4d_smp.c calls notify_cpu_starting() from __init code.

arch/powerpc/kernel/smp.c calls notify_cpu_starting() from __devinit
code.

arch/um/kernel/smp.c calls notify_cpu_starting() from .text code.


The other nine callers call notify_cpu_starting() from __cpuinit code.


What a mess.
