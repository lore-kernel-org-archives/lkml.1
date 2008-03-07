Return-Path: <linux-kernel-owner+w=401wt.eu-S1763535AbYCGJJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763535AbYCGJJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761567AbYCGJH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:07:26 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:48209 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759175AbYCGJHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:07:16 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <200803071007.493903088@firstfloor.org>
In-Reply-To: <200803071007.493903088@firstfloor.org>
To: avi@qumranet.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] [3/13] Make kvm bad_page symbol static
Message-Id: <20080307090713.90A1C1B419C@basil.firstfloor.org>
Date: Fri,  7 Mar 2008 10:07:13 +0100 (CET)
X-OriginalArrivalTime: 07 Mar 2008 09:00:43.0322 (UTC) FILETIME=[B97451A0:01C88031]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Avoids global namespace clash with later patch that exports page_alloc's 
bad_page. bad_page is not used outside kvm_main.c, so making it static is fine.

Cc: avi@qumranet.com

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/linux/kvm_host.h |    2 --
 virt/kvm/kvm_main.c      |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: linux/include/linux/kvm_host.h
===================================================================
--- linux.orig/include/linux/kvm_host.h
+++ linux/include/linux/kvm_host.h
@@ -150,8 +150,6 @@ void kvm_exit(void);
 static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
 struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva);
 
-extern struct page *bad_page;
-
 int is_error_page(struct page *page);
 int kvm_is_error_hva(unsigned long addr);
 int kvm_set_memory_region(struct kvm *kvm,
Index: linux/virt/kvm/kvm_main.c
===================================================================
--- linux.orig/virt/kvm/kvm_main.c
+++ linux/virt/kvm/kvm_main.c
@@ -52,6 +52,8 @@ MODULE_LICENSE("GPL");
 DEFINE_SPINLOCK(kvm_lock);
 LIST_HEAD(vm_list);
 
+static struct page *bad_page;
+
 static cpumask_t cpus_hardware_enabled;
 
 struct kmem_cache *kvm_vcpu_cache;
@@ -1271,8 +1273,6 @@ static struct sys_device kvm_sysdev = {
 	.cls = &kvm_sysdev_class,
 };
 
-struct page *bad_page;
-
 static inline
 struct kvm_vcpu *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
 {
