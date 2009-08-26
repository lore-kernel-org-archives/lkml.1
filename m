Return-Path: <linux-kernel-owner+w=401wt.eu-S932835AbZHZKmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbZHZKmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbZHZKl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:41:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773AbZHZKaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/47] KVM: fix EFER read buffer overflow
Date: Wed, 26 Aug 2009 13:29:29 +0300
Message-Id: <1251282609-12835-8-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

Check whether index is within bounds before grabbing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 0ba706e..31c3a87 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -571,12 +571,15 @@ static void reload_tss(void)
 static void load_transition_efer(struct vcpu_vmx *vmx)
 {
 	int efer_offset = vmx->msr_offset_efer;
-	u64 host_efer = vmx->host_msrs[efer_offset].data;
-	u64 guest_efer = vmx->guest_msrs[efer_offset].data;
+	u64 host_efer;
+	u64 guest_efer;
 	u64 ignore_bits;
 
 	if (efer_offset < 0)
 		return;
+	host_efer = vmx->host_msrs[efer_offset].data;
+	guest_efer = vmx->guest_msrs[efer_offset].data;
+
 	/*
 	 * NX is emulated; LMA and LME handled by hardware; SCE meaninless
 	 * outside long mode
-- 
1.6.4.1

