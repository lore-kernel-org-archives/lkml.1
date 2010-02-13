Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0BMICl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:02:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab0BMICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/39] KVM: PPC: Fix HID5 setting code
Date: Sat, 13 Feb 2010 10:01:33 +0200
Message-Id: <1266048119-14325-14-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

The code to unset HID5.dcbz32 is broken.
This patch makes it do the right rotate magic.

Signed-off-by: Alexander Graf <agraf@suse.de>
Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/book3s_64_interrupts.S |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_interrupts.S b/arch/powerpc/kvm/book3s_64_interrupts.S
index 33aef53..2ff0b21 100644
--- a/arch/powerpc/kvm/book3s_64_interrupts.S
+++ b/arch/powerpc/kvm/book3s_64_interrupts.S
@@ -177,8 +177,9 @@ kvmppc_handler_highmem:
 	rldicl.	r5, r5, 0, 63		/* CR = ((r5 & 1) == 0) */
 	beq	no_dcbz32_off
 
+	li	r4, 0
 	mfspr   r5,SPRN_HID5
-	rldimi  r5,r5,6,56
+	rldimi  r5,r4,6,56
 	mtspr   SPRN_HID5,r5
 
 no_dcbz32_off:
-- 
1.6.5.3

