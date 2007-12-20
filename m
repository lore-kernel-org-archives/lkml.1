Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbXLTNed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbXLTNed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbXLTNeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:34:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbXLTNeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:34:07 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 01/16] introduce vcpu struct
Date: Thu, 20 Dec 2007 11:33:41 -0200
Message-Id: <11981576442148-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981576363806-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch introduces a vcpu struct for lguest. In upcoming patches,
more and more fields will be moved from the lguest struct to the vcpu

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/lg.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index 8692489..9723732 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -38,6 +38,13 @@ struct lguest_pages
 #define CHANGED_GDT_TLS		4 /* Actually a subset of CHANGED_GDT */
 #define CHANGED_ALL	        3
 
+struct lguest;
+
+struct lguest_vcpu {
+	int vcpu_id;
+	struct lguest *lg;
+};
+
 /* The private info the thread maintains about the guest. */
 struct lguest
 {
@@ -47,6 +54,9 @@ struct lguest
 	struct lguest_data __user *lguest_data;
 	struct task_struct *tsk;
 	struct mm_struct *mm; 	/* == tsk->mm, but that becomes NULL on exit */
+	struct lguest_vcpu vcpus[NR_CPUS];
+	unsigned int nr_vcpus;
+
 	u32 pfn_limit;
 	/* This provides the offset to the base of guest-physical
 	 * memory in the Launcher. */
@@ -92,6 +102,11 @@ struct lguest
 	DECLARE_BITMAP(irqs_pending, LGUEST_IRQS);
 };
 
+static inline struct lguest *lg_of_vcpu(struct lguest_vcpu *vcpu)
+{
+	return container_of((vcpu - vcpu->vcpu_id), struct lguest, vcpus[0]);
+}
+
 extern struct mutex lguest_lock;
 
 /* core.c: */
-- 
1.5.0.6

