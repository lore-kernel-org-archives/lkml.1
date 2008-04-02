Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbYDBSks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbYDBSks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbYDBSfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:35:48 -0400
Received: from 21.sub-75-208-3.myvzw.com ([75.208.3.21]:38413 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757239AbYDBSfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:35:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 04 of 24] xen: add missing definitions in
	include/xen/interface/vcpu.h which ia64/xen needs
X-Mercurial-Node: 8023c18664d77145f6641b2d7fad6fe58c91aa1d
Message-Id: <8023c18664d77145f664.1207158833@localhost>
In-Reply-To: <patchbomb.1207158829@localhost>
Date: Wed, 02 Apr 2008 10:53:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Isaku Yamahata <yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Isaku Yamahata <yamahata@valinux.co.jp>

Add xen handles realted definitions for xen vcpu which ia64/xen needs.
Pointer argumsnts for ia64/xen hypercall are passed in pseudo physical
address (guest physical address) so that it is required to convert
guest kernel virtual address into pseudo physical address.
The xen guest handle represents such arguments.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/xen/interface/vcpu.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/xen/interface/vcpu.h b/include/xen/interface/vcpu.h
--- a/include/xen/interface/vcpu.h
+++ b/include/xen/interface/vcpu.h
@@ -85,6 +85,7 @@
 		 */
 		uint64_t time[4];
 };
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_runstate_info);
 
 /* VCPU is currently running on a physical CPU. */
 #define RUNSTATE_running  0
@@ -119,6 +120,7 @@
 #define VCPUOP_register_runstate_memory_area 5
 struct vcpu_register_runstate_memory_area {
 		union {
+				GUEST_HANDLE(vcpu_runstate_info) h;
 				struct vcpu_runstate_info *v;
 				uint64_t p;
 		} addr;
@@ -134,6 +136,7 @@
 struct vcpu_set_periodic_timer {
 		uint64_t period_ns;
 };
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_set_periodic_timer);
 
 /*
  * Set or stop a VCPU's single-shot timer. Every VCPU has one single-shot
@@ -145,6 +148,7 @@
 		uint64_t timeout_abs_ns;
 		uint32_t flags;			   /* VCPU_SSHOTTMR_??? */
 };
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_set_singleshot_timer);
 
 /* Flags to VCPUOP_set_singleshot_timer. */
  /* Require the timeout to be in the future (return -ETIME if it's passed). */
@@ -164,5 +168,6 @@
     uint32_t offset; /* offset within page */
     uint32_t rsvd;   /* unused */
 };
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_register_vcpu_info);
 
 #endif /* __XEN_PUBLIC_VCPU_H__ */


