Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbZEAFzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbZEAFzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 01:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbZEAFzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 01:55:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:54776 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZEAFzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 01:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=HVw4mHvyng75sGmI29UQFFIZT7QZz2bd0UddAWhTOqXvPKDZqVs3hxSm1+w/dhlphB
         BLvAKU0Paop3PK4Ql+Qrugi234BGLvEPiiiJOCNT0zZ6dSymETwIFCpew/7YaHF0/qs+
         lIk2t7yY3AG4pNSIoP6mcwGzHUw3wYQK/Kaew=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, lethal@linux-sh.org,
       tglx@linutronix.de, Magnus Damm <magnus.damm@gmail.com>, mingo@elte.hu
Date: Fri, 01 May 2009 14:52:47 +0900
Message-Id: <20090501055247.8286.64067.sendpatchset@rx1.opensource.se>
Subject: [PATCH] clockevent: export register_device and delta2ns
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

Export the following symbols using EXPORT_SYMBOL_GPL:
 - clockevent_delta2ns
 - clockevents_register_device

This allows us to build SuperH clockevent and clocksource
drivers as modules, see drivers/clocksource/sh_*.c

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 kernel/time/clockevents.c |    2 ++
 1 file changed, 2 insertions(+)

--- 0001/kernel/time/clockevents.c
+++ work/kernel/time/clockevents.c	2009-05-01 13:11:51.000000000 +0900
@@ -54,6 +54,7 @@ unsigned long clockevent_delta2ns(unsign
 
 	return (unsigned long) clc;
 }
+EXPORT_SYMBOL_GPL(clockevent_delta2ns);
 
 /**
  * clockevents_set_mode - set the operating mode of a clock event device
@@ -187,6 +188,7 @@ void clockevents_register_device(struct 
 
 	spin_unlock(&clockevents_lock);
 }
+EXPORT_SYMBOL_GPL(clockevents_register_device);
 
 /*
  * Noop handler when we shut down an event device
