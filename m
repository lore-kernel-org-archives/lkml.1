Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZIEKdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZIEKdE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 06:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757160AbZIEKdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 06:33:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:38319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757116AbZIEKdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 06:33:02 -0400
Subject: [PATCH] x86: fix section mismatch kernel/time.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 05 Sep 2009 15:59:15 +0530
Message-Id: <1252146555.4969.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit dd0a70c8 move tsc_init to late_time_init which leads to :

WARNING: arch/x86/built-in.o(.text+0x397f): Section mismatch in reference from the function x86_late_time_init() to the function .init.text:tsc_init()
The function x86_late_time_init() references
the function __init tsc_init().
This is often because x86_late_time_init lacks a __init

So adding __init to x86_late_time_init() fixes this mismatch.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index fcece00..8c6d692 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -105,7 +105,7 @@ void __init hpet_time_init(void)
 	setup_default_timer_irq();
 }
 
-static void x86_late_time_init(void)
+static void __init x86_late_time_init(void)
 {
 	x86_init.timers.timer_init();
 	tsc_init();
-- 
1.6.0.6



