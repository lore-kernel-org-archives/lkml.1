Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbXAWFzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbXAWFzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933019AbXAWFxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:53:54 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2713 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933017AbXAWFxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:53:47 -0500
Message-Id: <20070123055346.375449283@mvista.com>
References: <20070123055255.338254780@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Mon, 22 Jan 2007 21:53:01 -0800
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] clocksource: i386 initialize list value
Content-Disposition: inline; filename=clocksource_i386_list_init.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update arch/i386/ with list initialization.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/i386/kernel/hpet.c  |    1 +
 arch/i386/kernel/i8253.c |    1 +
 arch/i386/kernel/tsc.c   |    1 +
 3 files changed, 3 insertions(+)

Index: linux-2.6.19/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/hpet.c
+++ linux-2.6.19/arch/i386/kernel/hpet.c
@@ -282,6 +282,7 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.is_continuous	= 1,
+	.list		= LIST_HEAD_INIT(clocksource_hpet.list),
 };
 
 static int __init init_hpet_clocksource(void)
Index: linux-2.6.19/arch/i386/kernel/i8253.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/i8253.c
+++ linux-2.6.19/arch/i386/kernel/i8253.c
@@ -177,6 +177,7 @@ static struct clocksource clocksource_pi
 	.mask	= CLOCKSOURCE_MASK(32),
 	.mult	= 0,
 	.shift	= 20,
+	.list	= LIST_HEAD_INIT(clocksource_pit.list),
 };
 
 static int __init init_pit_clocksource(void)
Index: linux-2.6.19/arch/i386/kernel/tsc.c
===================================================================
--- linux-2.6.19.orig/arch/i386/kernel/tsc.c
+++ linux-2.6.19/arch/i386/kernel/tsc.c
@@ -352,6 +352,7 @@ static struct clocksource clocksource_ts
 	.shift			= 22,
 	.update_callback	= tsc_update_callback,
 	.is_continuous		= 1,
+	.list			= LIST_HEAD_INIT(clocksource_tsc.list),
 };
 
 static int tsc_update_callback(void)

-- 
