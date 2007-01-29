Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbXA2N7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbXA2N7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 08:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXA2N7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 08:59:15 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:24822 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbXA2N7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 08:59:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:x-accept-language:mime-version:to:cc:subject:content-type;
        b=Esp4aono4M/EmElzbRz9L7WIUpoWS8z3RfOLdtUcnmnkLepmHge9njLrgHtlmSzRylmfG+G88hJePQTtkiig+GM+/j8aFsj6bXMRZ3EZABtssQBK5knukMv4mZn5E39pyiU8CwqBS4U6NIvnYJLoIlk8tQxxGK5Jdqn4PTKNQZw=
Message-ID: <45BDFDAE.70604@googlemail.com>
Date: Mon, 29 Jan 2007 14:59:10 +0100
From: Dirk Behme <dirk.behme@googlemail.com>
User-Agent: Mozilla Thunderbird 1.0.7 (X11/20050923)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -rt] Make patch-2.6.20-rc6-rt4 compile & link for ARM
Content-Type: multipart/mixed;
 boundary="------------080907010803060309030507"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080907010803060309030507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

at least for me it looks like I need something like in
attachment to get patch-2.6.20-rc6-rt4 compile and link for ARM.

Please correct if anything is wrong.

Regards

Dirk


--------------080907010803060309030507
Content-Type: text/x-patch;
 name="arm-2.6.20-rc6-rt4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="arm-2.6.20-rc6-rt4.patch"


Fix compile and link of patch-2.6.20-rc6-rt4 for ARM.

Signed-off-by: Dirk Behme <dirk.behme@gmail.com>

Index: linux-osk/arch/arm/kernel/process.c
===================================================================
--- linux-osk.orig/arch/arm/kernel/process.c
+++ linux-osk/arch/arm/kernel/process.c
@@ -28,6 +28,7 @@
 #include <linux/cpu.h>
 #include <linux/elfcore.h>
 #include <linux/pm.h>
+#include <linux/tick.h>
 
 #include <asm/leds.h>
 #include <asm/processor.h>
@@ -154,11 +155,11 @@ void cpu_idle(void)
 		if (!idle)
 			idle = default_idle;
 		leds_event(led_idle_start);
-		hrtimer_stop_sched_tick();
+		tick_nohz_stop_sched_tick();
 		while (!need_resched() && !need_resched_delayed())
 			idle();
 		leds_event(led_idle_end);
-		hrtimer_restart_sched_tick();
+		tick_nohz_restart_sched_tick();
 		local_irq_disable();
 		__preempt_enable_no_resched();
 		__schedule();
Index: linux-osk/kernel/time/tick-sched.c
===================================================================
--- linux-osk.orig/kernel/time/tick-sched.c
+++ linux-osk/kernel/time/tick-sched.c
@@ -20,6 +20,7 @@
 #include <linux/profile.h>
 #include <linux/sched.h>
 #include <linux/tick.h>
+#include <asm/irq_regs.h>
 
 #include "tick-internal.h"
 


--------------080907010803060309030507--
