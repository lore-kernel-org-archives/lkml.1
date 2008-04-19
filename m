Return-Path: <linux-kernel-owner+w=401wt.eu-S1761992AbYDSPIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761992AbYDSPIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762170AbYDSPGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:06:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:11069 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762443AbYDSPGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:06:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=XSJ1YE7/bdVRe2OVxZG1mkBMG+kDSnNib7dNawolnISImlCL3vYPnn4t7dZMIkxr97beqrFoWyVQFyPbWZGY3gfCq08NuIFQAjTWPD74l0pm8WY0WHnfsTL1374vOGelzG8kyQD8YxzB2w+bbfW0fl4QxHTIju1ChtTu/CK+VVs=
References: <20080419145510.150338641@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 19 Apr 2008 23:55:15 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 05/10] x86: cleanup clocksource_hz2mult usage
Content-Disposition: inline; filename=x86-clocksource-hz2multi-cleanup.patch
Message-ID: <480a0a8b.1def600a.6f39.0538@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the magic number in the second argument of clocksource_hz2mult() 

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/i8253.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: 2.6-git/arch/x86/kernel/i8253.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/i8253.c
+++ 2.6-git/arch/x86/kernel/i8253.c
@@ -224,7 +224,8 @@ static int __init init_pit_clocksource(v
 	    pit_clockevent.mode != CLOCK_EVT_MODE_PERIODIC)
 		return 0;
 
-	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE, 20);
+	clocksource_pit.mult = clocksource_hz2mult(CLOCK_TICK_RATE,
+						   clocksource_pit.shift);
 	return clocksource_register(&clocksource_pit);
 }
 arch_initcall(init_pit_clocksource);

-- 
