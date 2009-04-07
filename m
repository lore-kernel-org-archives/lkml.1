Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbZDGPLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbZDGPLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758204AbZDGPHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:07:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48840 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758598AbZDGPHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:07:50 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Subject: [PATCH] [7/28] x86: MCE: Log corrected errors when panicing
Message-Id: <20090407150748.401C71D046D@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:07:48 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: bugfix

Normally the machine check handler ignores corrected errors and leaves
them to machine_check_poll(). But when panicing mcp won't run, so
log all errors.

Note: this can still miss some cases until the "early no way out" 
patch later is applied too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:09:59.000000000 +0200
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-04-07 16:43:14.000000000 +0200
@@ -317,9 +317,9 @@
 
 		/*
 		 * Non uncorrected errors are handled by machine_check_poll
-		 * Leave them alone.
+		 * Leave them alone, unless this panics.
 		 */
-		if ((m.status & MCI_STATUS_UC) == 0)
+		if ((m.status & MCI_STATUS_UC) == 0 && !no_way_out)
 			continue;
 
 		/*
