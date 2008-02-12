Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYBLVrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYBLVrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYBLVrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:47:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32791 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYBLVrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:47:00 -0500
Message-ID: <47B213AA.2090109@zytor.com>
Date: Tue, 12 Feb 2008 13:46:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: maximilian attems <max@stro.at>
CC: 464962@bugs.debian.org, Joey Hess <joeyh@debian.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Bug#464962: immediate crash on boot on TM5800
References: <20080210031849.GA3370@dragon.kitenet.net> <20080210110659.GB8574@stro.at> <20080210192139.GA17647@kodama.kitenet.net> <20080212160522.GB5221@stro.at> <20080212195254.GA6252@kodama.kitenet.net> <20080212201048.GD22054@baikonur.stro.at> <47B2025B.1030103@zytor.com> <20080212210244.GF22054@baikonur.stro.at> <47B20C1C.5020208@zytor.com> <20080212212416.GH22054@baikonur.stro.at>
In-Reply-To: <20080212212416.GH22054@baikonur.stro.at>
Content-Type: multipart/mixed;
 boundary="------------050603050103040108070403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050603050103040108070403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Thought some more about this, and since this probably means gcc will 
generate this for userspace code as well nowadays, tm5800 should 
probably be downgraded to a 586-class machine.  Hence the Linux policy 
of promoting it to a 686-class machine for having CMOV is actually 
incorrect, it doesn't have all the userspace-visible features of a 
686-class machine, lacking long NOP.

	-hpa


--------------050603050103040108070403
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index 200fb3f..e8b422c 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -76,13 +76,6 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 	/* All Transmeta CPUs have a constant TSC */
 	set_bit(X86_FEATURE_CONSTANT_TSC, c->x86_capability);
 	
-	/* If we can run i686 user-space code, call us an i686 */
-#define USER686 ((1 << X86_FEATURE_TSC)|\
-		 (1 << X86_FEATURE_CX8)|\
-		 (1 << X86_FEATURE_CMOV))
-        if (c->x86 == 5 && (c->x86_capability[0] & USER686) == USER686)
-		c->x86 = 6;
-
 #ifdef CONFIG_SYSCTL
 	/* randomize_va_space slows us down enormously;
 	   it probably triggers retranslation of x86->native bytecode */

--------------050603050103040108070403--
