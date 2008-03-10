Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYCJTp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYCJTp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYCJTpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:45:21 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:58212 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbYCJTpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:45:20 -0400
Date: Mon, 10 Mar 2008 19:14:14 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: P6 NOPs again: MPSC?
In-Reply-To: <47CDBE09.3060000@zytor.com>
Message-ID: <Pine.LNX.4.64.0803101853090.15511@blonde.site>
References: <Pine.LNX.4.64.0803041929230.14934@blonde.site>
 <20080304210111.GB31546@elte.hu> <47CDBE09.3060000@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've now noticed that the machine I call MPENTIUM4 for 32-bit kernels
is called MPSC for 64-bit kernels, and in that case it still doesn't
get the P6 NOPs which I'm guessing it ought to (yeah, I'm so excited
about the speedup I can expect from P6 NOPs, can we perhaps have a
little silvery "Using Genuine P6 NOPs" sticker to put on the box? ;)

I'm suspecting that the patch below is actually wrong, and that it's
really the "(X86_64 || !X86_GENERIC) &&" which should be changed;
but very unsure of my ground and what's right for CPU_GENERIC -
the 32/64 heritage of x86/Kconfig.cpu rather confuses me.

Over to you to do the right thing, I'm hoping, please, Peter!

Thanks,
Hugh

--- 2.6.25-rc5/arch/x86/Kconfig.cpu	2008-03-05 11:27:23.000000000 +0000
+++ linux/arch/x86/Kconfig.cpu	2008-03-10 18:48:10.000000000 +0000
@@ -388,7 +388,7 @@ config X86_OOSTORE
 #
 config X86_P6_NOP
 	def_bool y
-	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4)
+	depends on (X86_64 || !X86_GENERIC) && (M686 || MPENTIUMII || MPENTIUMIII || MPENTIUMM || MCORE2 || MPENTIUM4 || MPSC)
 
 config X86_TSC
 	def_bool y

