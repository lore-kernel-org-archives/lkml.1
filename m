Return-Path: <linux-kernel-owner+w=401wt.eu-S1761753AbYJJPDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761753AbYJJPDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761356AbYJJPAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:00:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:22391 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514AbYJJPAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:00:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=C8fWyNoQjkeDPjXUuXCU8sf2VTSjIQBZVW6c5yeCuX4paTQ+USxS6L8hQsSXMjwSxw
         e9f50SFPqOmOYHCsX2w8glpGRkqc1gj003IszSjyXm4r4o/AUnFJL9pcKhXup0W/QcE7
         4OspoZtyB61ciWhlnFAWzox5OHM+7aXVAfRQk=
Date: Fri, 10 Oct 2008 19:00:17 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipad <venkatesh.pallipadi@intel.com>
Subject: [PATCH] x86: apic - unify APIC_DIVISOR
Message-ID: <20081010150017.GD7328@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use APIC_DIVISOR being set to 16 for both 32/64bit
mode. To escape APIC timer underflow during calibration
set it to the maximum possible value.

Also typo error (CONFG instead of proper CONFIG) fixed.
The error was catched by Venkatesh Pallipadi, thanks a lot Venkatesh!
See details on http://lkml.org/lkml/2008/10/9/425

Reported-by: Venkatesh Pallipad <venkatesh.pallipadi@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic.c	2008-09-26 20:43:47.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic.c	2008-10-10 16:37:26.000000000 +0400
@@ -332,11 +332,7 @@ int lapic_get_maxlvt(void)
  */
 
 /* Clock divisor */
-#ifdef CONFG_X86_64
-#define APIC_DIVISOR 1
-#else
 #define APIC_DIVISOR 16
-#endif
 
 /*
  * This function sets up the local APIC timer, with a timeout of
@@ -592,10 +588,10 @@ static int __init calibrate_APIC_clock(v
 	global_clock_event->event_handler = lapic_cal_handler;
 
 	/*
-	 * Setup the APIC counter to 1e9. There is no way the lapic
+	 * Setup the APIC counter to maximum. There is no way the lapic
 	 * can underflow in the 100ms detection time frame
 	 */
-	__setup_APIC_LVTT(1000000000, 0, 0);
+	__setup_APIC_LVTT(0xffffffff, 0, 0);
 
 	/* Let the interrupts run */
 	local_irq_enable();
