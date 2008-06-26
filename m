Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYFZMbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYFZMbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYFZM2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:28:44 -0400
Received: from il.qumranet.com ([212.179.150.194]:32362 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbYFZM2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:36 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/50] KVM: VMX: Trivial vmcs_write64() code simplification
Date: Thu, 26 Jun 2008 15:27:54 +0300
Message-Id: <1214483312-9265-13-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 158a7d8..1b286fa 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -431,10 +431,8 @@ static void vmcs_write32(unsigned long field, u32 value)
 
 static void vmcs_write64(unsigned long field, u64 value)
 {
-#ifdef CONFIG_X86_64
-	vmcs_writel(field, value);
-#else
 	vmcs_writel(field, value);
+#ifndef CONFIG_X86_64
 	asm volatile ("");
 	vmcs_writel(field+1, value >> 32);
 #endif
-- 
1.5.6

