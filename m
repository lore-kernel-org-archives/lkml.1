Return-Path: <linux-kernel-owner+w=401wt.eu-S1760382AbXFQJsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760382AbXFQJsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759513AbXFQJou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:50 -0400
Received: from il.qumranet.com ([82.166.9.18]:55152 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758221AbXFQJon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Matthew Gregan <kinetik@flim.org>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 17/58] KVM: Implement IA32_EBL_CR_POWERON msr
Date: Sun, 17 Jun 2007 12:43:58 +0300
Message-Id: <11820734803107-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Gregan <kinetik@flim.org>

Attempting to boot the default 'bsd' kernel of OpenBSD 4.1 i386 in a guest
fails early in the kernel init inside p3_get_bus_clock while trying to read
the IA32_EBL_CR_POWERON MSR.  KVM logs an 'unhandled MSR' message and the
guest kernel faults.

This patch is sufficient to allow OpenBSD to boot, after which it seems to
run fine.  I'm not sure if this is the correct solution for dealing with
this particular MSR, but it works for me.

Signed-off-by: Matthew Gregan <kinetik@flim.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index b6ad9c6..095d673 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1470,6 +1470,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_IA32_MC0_MISC+16:
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_PERF_STATUS:
+	case MSR_IA32_EBL_CR_POWERON:
 		/* MTRR registers */
 	case 0xfe:
 	case 0x200 ... 0x2ff:
-- 
1.5.0.6

