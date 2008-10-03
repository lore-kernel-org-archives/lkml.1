Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYJCIUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYJCIUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYJCIUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:20:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34382 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYJCIUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:20:13 -0400
Date: Fri, 3 Oct 2008 10:19:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: Trivial printk fix in efi.c
Message-ID: <20081003081958.GE32195@elte.hu>
References: <20081002223206.GA122667@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002223206.GA122667@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Russ Anderson <rja@sgi.com> wrote:

> [patch] x86: Trivial printk fix in efi.c
> 
> The following line is lacking a space between "memdesc" and "doesn't".
> 
>   "Kernel-defined memdescdoesn't match the one from EFI!"
> 
> Fixed the printk by adding a space.

> -		printk(KERN_WARNING "Kernel-defined memdesc"
> +		printk(KERN_WARNING "Kernel-defined memdesc "
>  		       "doesn't match the one from EFI!\n");

the dangers of breaking a string in the middle.

applied your fix in the form below to tip/x86/cleanups - thanks Russ!

	Ingo

------------------->
>From 175e438f7a2de9d94110046be48697969569736a Mon Sep 17 00:00:00 2001
From: Russ Anderson <rja@sgi.com>
Date: Thu, 2 Oct 2008 17:32:06 -0500
Subject: [PATCH] x86: trivial printk fix in efi.c

[patch] x86: Trivial printk fix in efi.c

The following line is lacking a space between "memdesc" and "doesn't".

  "Kernel-defined memdescdoesn't match the one from EFI!"

Fixed the printk by adding a space.

Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/efi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 06cc8d4..945a31c 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -414,9 +414,11 @@ void __init efi_init(void)
 	if (memmap.map == NULL)
 		printk(KERN_ERR "Could not map the EFI memory map!\n");
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
+
 	if (memmap.desc_size != sizeof(efi_memory_desc_t))
-		printk(KERN_WARNING "Kernel-defined memdesc"
-		       "doesn't match the one from EFI!\n");
+		printk(KERN_WARNING
+		  "Kernel-defined memdesc doesn't match the one from EFI!\n");
+
 	if (add_efi_memmap)
 		do_add_efi_memmap();
 
