Return-Path: <linux-kernel-owner+w=401wt.eu-S1757045AbYAAPml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045AbYAAPml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755361AbYAAPgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:38 -0500
Received: from il.qumranet.com ([82.166.9.18]:33793 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341AbYAAPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:27 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 25/54] KVM: Extend ioapic code to support iosapic
Date: Tue,  1 Jan 2008 17:35:51 +0200
Message-Id: <1199201780-14001-26-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

iosapic supports an additional mmio EOI register compared to ioapic.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/ioapic.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/ioapic.c b/drivers/kvm/ioapic.c
index 0feae6f..e7debfa 100644
--- a/drivers/kvm/ioapic.c
+++ b/drivers/kvm/ioapic.c
@@ -360,6 +360,11 @@ static void ioapic_mmio_write(struct kvm_io_device *this, gpa_t addr, int len,
 	case IOAPIC_REG_WINDOW:
 		ioapic_write_indirect(ioapic, data);
 		break;
+#ifdef	CONFIG_IA64
+	case IOAPIC_REG_EOI:
+		kvm_ioapic_update_eoi(ioapic, data);
+		break;
+#endif
 
 	default:
 		break;
-- 
1.5.3.7

