Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYIBNtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYIBNtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYIBNt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:49:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56425 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYIBNt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:49:26 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080902349.573187695@firstfloor.org>
In-Reply-To: <20080902349.573187695@firstfloor.org>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/2] Add a SYSTEM_PANIC state
Message-Id: <20080902134922.9401F3E6A00@basil.firstfloor.org>
Date: Tue,  2 Sep 2008 15:49:22 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Natural extension of the other system states.

This is useful to do some special case code on system panic.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/linux/kernel.h |    1 +
 kernel/panic.c         |    2 ++
 2 files changed, 3 insertions(+)

Index: linux/include/linux/kernel.h
===================================================================
--- linux.orig/include/linux/kernel.h
+++ linux/include/linux/kernel.h
@@ -248,6 +248,7 @@ extern enum system_states {
 	SYSTEM_POWER_OFF,
 	SYSTEM_RESTART,
 	SYSTEM_SUSPEND_DISK,
+	SYSTEM_PANIC,
 } system_state;
 
 #define TAINT_PROPRIETARY_MODULE	(1<<0)
Index: linux/kernel/panic.c
===================================================================
--- linux.orig/kernel/panic.c
+++ linux/kernel/panic.c
@@ -68,6 +68,8 @@ NORET_TYPE void panic(const char * fmt, 
 	unsigned long caller = (unsigned long) __builtin_return_address(0);
 #endif
 
+	system_state = SYSTEM_PANIC;
+
 	/*
 	 * It's possible to come here directly from a panic-assertion and not
 	 * have preempt disabled. Some functions called from here want
