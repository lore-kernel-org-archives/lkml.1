Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbYHUUSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbYHUUSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbYHUUR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:17:59 -0400
Received: from gw.goop.org ([64.81.55.164]:58470 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbYHUUR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:17:58 -0400
Message-ID: <48ADCD74.60304@goop.org>
Date: Thu, 21 Aug 2008 13:17:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0 of 4] Xen spinlock updates and performance	measurements
References: <patchbomb.1219276937@localhost> <20080821115304.GF30667@elte.hu> <20080821121300.GA26397@elte.hu>
In-Reply-To: <20080821121300.GA26397@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> -tip testing found this build failure:
>
>  arch/x86/xen/spinlock.c: In function ‘spin_time_start’:
>  arch/x86/xen/spinlock.c:60: error: implicit declaration of function ‘xen_clocksource_read’
>
> i've excluded these new commits for now from tip/master - could you 
> please send a delta fix against tip/x86/xen?
>   
Make xen_clocksource_read non-static.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/time.c    |    4 +---
 arch/x86/xen/xen-ops.h |    2 ++
 2 files changed, 3 insertions(+), 3 deletions(-)

===================================================================
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -29,8 +29,6 @@
 /* Xen may fire a timer up to this many ns early */
 #define TIMER_SLOP	100000
 #define NS_PER_TICK	(1000000000LL / HZ)
-
-static cycle_t xen_clocksource_read(void);
 
 /* runstate info updated by Xen */
 static DEFINE_PER_CPU(struct vcpu_runstate_info, runstate);
@@ -213,7 +211,7 @@
 	return xen_khz;
 }
 
-static cycle_t xen_clocksource_read(void)
+cycle_t xen_clocksource_read(void)
 {
         struct pvclock_vcpu_time_info *src;
 	cycle_t ret;
===================================================================
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -2,6 +2,7 @@
 #define XEN_OPS_H
 
 #include <linux/init.h>
+#include <linux/clocksource.h>
 #include <linux/irqreturn.h>
 #include <xen/xen-ops.h>
 
@@ -33,6 +34,7 @@
 
 void xen_init_irq_ops(void);
 void xen_setup_timer(int cpu);
+cycle_t xen_clocksource_read(void);
 void xen_setup_cpu_clockevents(void);
 unsigned long xen_tsc_khz(void);
 void __init xen_time_init(void);



