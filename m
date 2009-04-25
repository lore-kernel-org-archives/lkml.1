Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbZDYSyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbZDYSyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 14:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZDYSym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 14:54:42 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:27543 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZDYSyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 14:54:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject
         :content-disposition:mime-version:x-mailer:content-transfer-encoding;
        b=NyJuvijc9E8WZxEBl/4vPBKIBiPfQ9ADb1EhV9QdA/Wvo3p8hW7VORfaTYphb7GuSA
         YPZAp/rr4kvXJEGles/xVEn3YnhMkNoUTPkTAeBxzwhHI5WdN7yAkelbO7waYoWc/d41
         eBwMoRJ3DZHsr4Xc1T9xSHk7/4uDA+VnEv0AI=
Message-Id: <49f35c6f.1818d00a.3b20.ffff95d3@mx.google.com>
User-Agent: quilt/0.46-1
Date: Sat, 25 Apr 2009 20:47:45 +0200
From: Remy Bohmer <linux@bohmer.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Remy Bohmer <linux@bohmer.net>
Subject: [patch 1/1] PREEMPT_RT: Fix compile error in case high-res-timers
 are not configured.
Content-Disposition: inline; filename=repair-build-failure-in-case-hrtimers-are-disabled.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29.1-rt does not compile if high-res-timers are not configured
It can, for example, be reproduced by using at91sam9261ek_defconfig (ARM)

Signed-off-by: Remy Bohmer <linux@bohmer.net>
---
 kernel/hrtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.29/kernel/hrtimer.c
===================================================================
--- linux-2.6.29.orig/kernel/hrtimer.c	2009-04-25 18:32:54.000000000 +0200
+++ linux-2.6.29/kernel/hrtimer.c	2009-04-25 18:36:27.000000000 +0200
@@ -1230,7 +1230,7 @@ static void __run_hrtimer(struct hrtimer
 	timer->state &= ~HRTIMER_STATE_CALLBACK;
 }
 
-#ifdef CONFIG_PREEMPT_RT
+#if defined(CONFIG_PREEMPT_RT) && defined(CONFIG_HIGH_RES_TIMERS)
 
 
 static void hrtimer_rt_reprogram(int restart, struct hrtimer *timer,

-- 

