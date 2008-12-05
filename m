Return-Path: <linux-kernel-owner+w=401wt.eu-S1757121AbYLEMLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbYLEMLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbYLEMLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:11:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48155 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYLEMLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:11:07 -0500
Date: Fri, 5 Dec 2008 13:10:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [trivial] fix missing space in printk
Message-ID: <20081205121046.GA28662@elte.hu>
References: <4939139C.8090806@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4939139C.8090806@msgid.tls.msk.ru>
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


* Michael Tokarev <mjt@tls.msk.ru> wrote:

> Just come across this when booting on an old hw.. Looks somewhat ugly, 
> that single missing space ;)
> 
> And oh,
> 
> Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>
> 
> ;)

applied to tip/x86/cleanups.

> --- a/arch/x86/kernel/smpboot.c	2008-10-10 02:13:53.000000000 +0400
> +++ b/arch/x86/kernel/smpboot.c	2008-12-05 14:39:29.608353301 +0300
> @@ -1084,7 +1084,7 @@ static int __init smp_sanity_check(unsig
>  #endif
>  
>  	if (!physid_isset(hard_smp_processor_id(), phys_cpu_present_map)) {
> -		printk(KERN_WARNING "weird, boot CPU (#%d) not listed"
> +		printk(KERN_WARNING "weird, boot CPU (#%d) not listed "
>  				    "by the BIOS.\n", hard_smp_processor_id());

btw., the reason for that bug was the incorrect line break in the middle 
of a string - we humans just dont notice a missing space in that context. 

So in the final commit i've moved the string to a single line, see it 
attached below.

	Ingo

--------------->
>From 55c395b47042e12d5c25aa07f271f56ffe44f793 Mon Sep 17 00:00:00 2001
From: Michael Tokarev <mjt@tls.msk.ru>
Date: Fri, 5 Dec 2008 14:42:20 +0300
Subject: [PATCH] x86: fix missing space in printk

Just come across this when booting on an old hw..
Looks somewhat ugly, that single missing space ;)

Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7b10933..1a3c325 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1086,8 +1086,10 @@ static int __init smp_sanity_check(unsigned max_cpus)
 #endif
 
 	if (!physid_isset(hard_smp_processor_id(), phys_cpu_present_map)) {
-		printk(KERN_WARNING "weird, boot CPU (#%d) not listed"
-				    "by the BIOS.\n", hard_smp_processor_id());
+		printk(KERN_WARNING
+			"weird, boot CPU (#%d) not listed by the BIOS.\n",
+			hard_smp_processor_id());
+
 		physid_set(hard_smp_processor_id(), phys_cpu_present_map);
 	}
 
