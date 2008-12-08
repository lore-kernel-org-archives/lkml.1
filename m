Return-Path: <linux-kernel-owner+w=401wt.eu-S1751974AbYLHLug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbYLHLug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYLHLin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48228 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYLHLhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 29/45] KVM: x86: Fix typo in function name
Date: Mon,  8 Dec 2008 13:36:40 +0200
Message-Id: <1228736216-15787-30-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@redhat.com>

get_segment_descritptor_dtable() contains an obvious type.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f175b79..ceeac88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3373,9 +3373,9 @@ static void seg_desct_to_kvm_desct(struct desc_struct *seg_desc, u16 selector,
 	kvm_desct->padding = 0;
 }
 
-static void get_segment_descritptor_dtable(struct kvm_vcpu *vcpu,
-					   u16 selector,
-					   struct descriptor_table *dtable)
+static void get_segment_descriptor_dtable(struct kvm_vcpu *vcpu,
+					  u16 selector,
+					  struct descriptor_table *dtable)
 {
 	if (selector & 1 << 2) {
 		struct kvm_segment kvm_seg;
@@ -3400,7 +3400,7 @@ static int load_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 	struct descriptor_table dtable;
 	u16 index = selector >> 3;
 
-	get_segment_descritptor_dtable(vcpu, selector, &dtable);
+	get_segment_descriptor_dtable(vcpu, selector, &dtable);
 
 	if (dtable.limit < index * 8 + 7) {
 		kvm_queue_exception_e(vcpu, GP_VECTOR, selector & 0xfffc);
@@ -3419,7 +3419,7 @@ static int save_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 	struct descriptor_table dtable;
 	u16 index = selector >> 3;
 
-	get_segment_descritptor_dtable(vcpu, selector, &dtable);
+	get_segment_descriptor_dtable(vcpu, selector, &dtable);
 
 	if (dtable.limit < index * 8 + 7)
 		return 1;
-- 
1.6.0.3

