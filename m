Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbYCaOlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbYCaOlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYCaOhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:39 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51319
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbYCaOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 14/40] KVM: Use CONFIG_PREEMPT_NOTIFIERS around struct preempt_notifier
Date: Mon, 31 Mar 2008 17:36:58 +0300
Message-Id: <1206974244-9716-15-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

This allows kvm_host.h to be #included even when struct preempt_notifier is
undefined. This is needed to build ppc asm-offsets.h.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm_host.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 928b0d5..b90ca36 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -67,7 +67,9 @@ void kvm_io_bus_register_dev(struct kvm_io_bus *bus,
 
 struct kvm_vcpu {
 	struct kvm *kvm;
+#ifdef CONFIG_PREEMPT_NOTIFIERS
 	struct preempt_notifier preempt_notifier;
+#endif
 	int vcpu_id;
 	struct mutex mutex;
 	int   cpu;
-- 
1.5.4.5

