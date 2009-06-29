Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbZF2MJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbZF2MJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755397AbZF2MJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:09:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58024 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbZF2MJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:09:27 -0400
Date: Mon, 29 Jun 2009 15:08:56 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: [PATCHv3 1/4] kvm: document locking for kvm_io_device_ops
Message-ID: <20090629120856.GB21273@redhat.com>
References: <cover.1246276816.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1246276816.git.mst@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

slots_lock is taken everywhere when device ops are called.
Document this as we will use this to rework locking for io.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
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
1.6.2.2

