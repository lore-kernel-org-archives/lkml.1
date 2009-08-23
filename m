Return-Path: <linux-kernel-owner+w=401wt.eu-S933774AbZHWMDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774AbZHWMDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 08:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933755AbZHWMCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 08:02:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933538AbZHWL4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/46] KVM: silence lapic kernel messages that can be triggered by a guest
Date: Sun, 23 Aug 2009 14:56:26 +0300
Message-Id: <1251028605-31977-28-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Some Linux versions (f8) try to read EOI register that is write only.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/lapic.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3b03ebd..fdddf48 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -591,14 +591,14 @@ static int apic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 	static const u64 rmask = 0x43ff01ffffffe70cULL;
 
 	if ((alignment + len) > 4) {
-		printk(KERN_ERR "KVM_APIC_READ: alignment error %x %d\n",
-				offset, len);
+		apic_debug("KVM_APIC_READ: alignment error %x %d\n",
+			   offset, len);
 		return 1;
 	}
 
 	if (offset > 0x3f0 || !(rmask & (1ULL << (offset >> 4)))) {
-		printk(KERN_ERR "KVM_APIC_READ: read reserved register %x\n",
-				offset);
+		apic_debug("KVM_APIC_READ: read reserved register %x\n",
+			   offset);
 		return 1;
 	}
 
-- 
1.6.4.1

