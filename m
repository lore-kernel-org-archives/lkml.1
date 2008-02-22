Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbYBVFJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbYBVFJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 00:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYBVFH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 00:07:56 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:35778 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750892AbYBVFHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 00:07:50 -0500
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, yamahata@valinux.co.jp
Subject: [PATCH 04/11] xen: add missing definitions in include/xen/interface/vcpu.h which ia64/xen needs
Date: Fri, 22 Feb 2008 14:07:41 +0900
Message-Id: <12036568692040-git-send-email-yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <12036568683779-git-send-email-yamahata@valinux.co.jp>
References: <12036568683779-git-send-email-yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 include/xen/interface/vcpu.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/xen/interface/vcpu.h b/include/xen/interface/vcpu.h
index b05d8a6..87e6f8a 100644
--- a/include/xen/interface/vcpu.h
+++ b/include/xen/interface/vcpu.h
@@ -85,6 +85,7 @@ struct vcpu_runstate_info {
 		 */
 		uint64_t time[4];
 };
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_runstate_info);
 
 /* VCPU is currently running on a physical CPU. */
 #define RUNSTATE_running  0
@@ -119,6 +120,7 @@ struct vcpu_runstate_info {
 #define VCPUOP_register_runstate_memory_area 5
 struct vcpu_register_runstate_memory_area {
 		union {
+				GUEST_HANDLE(vcpu_runstate_info) h;
 				struct vcpu_runstate_info *v;
 				uint64_t p;
 		} addr;
@@ -134,6 +136,7 @@ struct vcpu_register_runstate_memory_area {
 struct vcpu_set_periodic_timer {
 		uint64_t period_ns;
 };
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_set_periodic_timer);
 
 /*
  * Set or stop a VCPU's single-shot timer. Every VCPU has one single-shot
@@ -145,6 +148,7 @@ struct vcpu_set_singleshot_timer {
 		uint64_t timeout_abs_ns;
 		uint32_t flags;			   /* VCPU_SSHOTTMR_??? */
 };
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_set_singleshot_timer);
 
 /* Flags to VCPUOP_set_singleshot_timer. */
  /* Require the timeout to be in the future (return -ETIME if it's passed). */
@@ -164,5 +168,6 @@ struct vcpu_register_vcpu_info {
     uint32_t offset; /* offset within page */
     uint32_t rsvd;   /* unused */
 };
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_register_vcpu_info);
 
 #endif /* __XEN_PUBLIC_VCPU_H__ */
-- 
1.5.3

