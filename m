Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbZHSNGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbZHSNGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbZHSNEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50581 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752010AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 41/47] KVM: document locking for kvm_io_device_ops
Date: Wed, 19 Aug 2009 16:02:37 +0300
Message-Id: <1250686963-8357-42-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

slots_lock is taken everywhere when device ops are called.
Document this as we will use this to rework locking for io.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/iodev.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/iodev.h b/virt/kvm/iodev.h
index 2c67f5a..06e38b2 100644
--- a/virt/kvm/iodev.h
+++ b/virt/kvm/iodev.h
@@ -20,6 +20,9 @@
 
 struct kvm_io_device;
 
+/**
+ * kvm_io_device_ops are called under kvm slots_lock.
+ **/
 struct kvm_io_device_ops {
 	void (*read)(struct kvm_io_device *this,
 		     gpa_t addr,
-- 
1.6.3.3

