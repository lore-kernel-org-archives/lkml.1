Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbYFXQUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbYFXQUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 12:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYFXQUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 12:20:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:36153 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYFXQUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:20:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=GnabucB7qNPGruRTaAswCw1KHktU/zqqDw7FogekgKFhyY0gbSOwR9VBHbAhYq5fD5
         lTtOc045AwTjZtj13XznSFuBNUc+PUKWP78kCW70Sv1VeXaxQlgL/bfxVyGONsswXx93
         HwX7k2NPxMbplrEMl0dWzCH0GbOaAyAy8PFmE=
References: <20080624161624.124913675@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, macro@linux-mips.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/5] x86: nmi_watchdog - use nmi_watchdog variable for printing
Content-Disposition: inline; filename=nmi-apic-use-nmi_watchdog
Message-ID: <48611ec2.1636440a.75ee.2503@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it is possible NMI_ definitions could be changed
one day we better print out real nmi_watchdog value instead
of constant string

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-06-22 23:02:50.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-06-23 18:38:49.000000000 +0400
@@ -550,7 +550,7 @@ void __init setup_boot_APIC_clock(void)
 			lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
 		else
 			printk(KERN_WARNING "APIC timer registered as dummy,"
-			       " due to nmi_watchdog=1!\n");
+				" due to nmi_watchdog=%d!\n", nmi_watchdog);
 	}
 
 	/* Setup the lapic or request the broadcast */
Index: linux-2.6.git/arch/x86/kernel/apic_64.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-06-22 23:02:50.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-06-23 18:44:41.000000000 +0400
@@ -417,7 +417,7 @@ void __init setup_boot_APIC_clock(void)
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
 	else
 		printk(KERN_WARNING "APIC timer registered as dummy,"
-		       " due to nmi_watchdog=1!\n");
+			" due to nmi_watchdog=%d!\n", nmi_watchdog);
 
 	setup_APIC_timer();
 }

-- 
