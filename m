Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbYIYMBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbYIYMBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYIYLzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48567 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbYIYLzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:50 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 18/39] KVM: VMX: Change segment dpl at reset to 3
Date: Thu, 25 Sep 2008 14:54:50 +0300
Message-Id: <1222343711-12508-19-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

This is more emulation friendly, if not 100% correct.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6aa305a..71e57ae 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1991,7 +1991,7 @@ static void seg_setup(int seg)
 	vmcs_write16(sf->selector, 0);
 	vmcs_writel(sf->base, 0);
 	vmcs_write32(sf->limit, 0xffff);
-	vmcs_write32(sf->ar_bytes, 0x93);
+	vmcs_write32(sf->ar_bytes, 0xf3);
 }
 
 static int alloc_apic_access_page(struct kvm *kvm)
-- 
1.6.0.1

