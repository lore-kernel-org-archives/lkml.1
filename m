Return-Path: <linux-kernel-owner+w=401wt.eu-S1767821AbXECTdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767821AbXECTdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767824AbXECTdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:33:01 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:21112 "EHLO
	outbound3-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767819AbXECTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:32:58 -0400
X-BigFish: VP
Message-ID: <463A3990.9010006@am.sony.com>
Date: Thu, 03 May 2007 12:35:44 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: v2.6.21-rt1 - mips compile bugs
References: <20070205065636.GA1652@elte.hu> <20070426135730.GA2116@elte.hu> <463A3512.4020508@am.sony.com>
In-Reply-To: <463A3512.4020508@am.sony.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 May 2007 19:32:52.0419 (UTC) FILETIME=[D7507930:01C78DB9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i have released the v2.6.20-rt1 kernel...

There was also a problem with the patch for arch/mips/kernel/entry.S
Some kind of cruft was in the patch.

Below is a patch which fixes both issues.  It at least allows compilation.
I haven't turned anything on, or looked at runtime yet.

Index: alp-linux/arch/mips/kernel/entry.S
===================================================================
--- alp-linux.orig/arch/mips/kernel/entry.S	2007-05-03 12:28:38.000000000 -0700
+++ alp-linux/arch/mips/kernel/entry.S	2007-05-03 12:21:47.000000000 -0700
@@ -21,8 +21,6 @@
 #endif

 #ifndef CONFIG_PREEMPT
-<<<<<<< delete 	local_irq_disable
-	raw_local_irq_disable
 #define resume_kernel	restore_all
 #else
 #define __ret_from_irq	ret_from_exception
@@ -32,7 +30,7 @@
 	.align	5
 #ifndef CONFIG_PREEMPT
 FEXPORT(ret_from_exception)
-	local_irq_disable			# preempt stop
+	raw_local_irq_disable			# preempt stop
 	b	__ret_from_irq
 #endif
 FEXPORT(ret_from_irq)
Index: alp-linux/include/asm-mips/atomic.h
===================================================================
--- alp-linux.orig/include/asm-mips/atomic.h	2007-05-03 12:28:38.000000000 -0700
+++ alp-linux/include/asm-mips/atomic.h	2007-05-03 11:56:58.000000000 -0700
@@ -566,7 +566,6 @@
 		raw_local_irq_restore(flags);
 	}
 #endif
-#endif

 	smp_mb();


=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Electronics
=============================

