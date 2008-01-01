Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbYAAPrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbYAAPrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755483AbYAAPgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:52 -0500
Received: from il.qumranet.com ([82.166.9.18]:33800 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbYAAPg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:29 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Joerg Roedel <jroedel@lemmy.amd.com>
Subject: [PATCH 38/54] KVM: SVM: Emulate read/write access to cr8
Date: Tue,  1 Jan 2008 17:36:04 +0200
Message-Id: <1199201780-14001-39-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@lemmy.amd.com>

This patch adds code to emulate the access to the cr8 register to the x86
instruction emulator in kvm.  This is needed on svm, where there is no
hardware decode for control register access.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 6deb052..9db4e32 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -2236,6 +2236,8 @@ unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr)
 		return vcpu->cr3;
 	case 4:
 		return vcpu->cr4;
+	case 8:
+		return get_cr8(vcpu);
 	default:
 		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
 		return 0;
@@ -2259,6 +2261,9 @@ void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long val,
 	case 4:
 		set_cr4(vcpu, mk_cr_64(vcpu->cr4, val));
 		break;
+	case 8:
+		set_cr8(vcpu, val & 0xfUL);
+		break;
 	default:
 		vcpu_printf(vcpu, "%s: unexpected cr %u\n", __FUNCTION__, cr);
 	}
-- 
1.5.3.7

