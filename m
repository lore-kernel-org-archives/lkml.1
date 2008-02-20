Return-Path: <linux-kernel-owner+w=401wt.eu-S1757716AbYBTKPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbYBTKPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 05:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYBTKPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 05:15:08 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:33219 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYBTKPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 05:15:06 -0500
From: Srinivasa Ds <srinivasa@in.ibm.com>
Organization: IBM
To: Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>, linux-kernel@vger.kernel.org,
       srikar@linux.vnet.ibm.com
Subject: [RFC] [PATCH] Refuse kprobe insertion on add/sub_preempt_counter()
Date: Wed, 20 Feb 2008 15:45:17 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802201545.17986.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kprobes makes use of preempt_disable(),preempt_enable_noresched() and these
functions inturn call add/sub_preempt_count(). So we need to refuse user from 
inserting probe in to these functions. 

This patch disallows user from probing add/sub_preempt_count(). 

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>


---
 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.25-rc2/kernel/sched.c
===================================================================
--- linux-2.6.25-rc2.orig/kernel/sched.c
+++ linux-2.6.25-rc2/kernel/sched.c
@@ -3766,7 +3766,7 @@ void scheduler_tick(void)
 
 #if defined(CONFIG_PREEMPT) && defined(CONFIG_DEBUG_PREEMPT)
 
-void add_preempt_count(int val)
+void __kprobes add_preempt_count(int val)
 {
 	/*
 	 * Underflow?
@@ -3782,7 +3782,7 @@ void add_preempt_count(int val)
 }
 EXPORT_SYMBOL(add_preempt_count);
 
-void sub_preempt_count(int val)
+void __kprobes sub_preempt_count(int val)
 {
 	/*
 	 * Underflow?


