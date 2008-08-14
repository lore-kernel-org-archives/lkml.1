Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbYHNGom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbYHNGom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 02:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbYHNGie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 02:38:34 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:38138 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbYHNGiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 02:38:03 -0400
Date: Thu, 14 Aug 2008 00:14:38 -0600
From: jmerkey@wolfmountaingroup.com
Message-Id: <200808140614.m7E6EcDS006264@wolfmountaingroup.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.27-rc3 26/29] mdb: export task_curr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

export the task_curr function to the module based kernel debugger to enable
process back tracing and state display.


Signed-off-by: Jeffrey Vernon Merkey (jmerkey@wolfmountaingroup.com)

--- a/kernel/sched.c	2008-08-13 14:22:32.000000000 -0600
+++ b/kernel/sched.c	2008-08-13 11:56:03.000000000 -0600
@@ -1736,6 +1736,9 @@
 {
 	return cpu_curr(task_cpu(p)) == p;
 }
+#if defined(CONFIG_MDB_MODULE)
+EXPORT_SYMBOL_GPL(task_curr);
+#endif
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
