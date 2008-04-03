Return-Path: <linux-kernel-owner+w=401wt.eu-S1763347AbYDCTjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763347AbYDCTjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761126AbYDCTdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:17 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53029
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759666AbYDCTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 27/35] KVM: kvm.h: __user requires compiler.h
Date: Thu,  3 Apr 2008 22:32:42 +0300
Message-Id: <1207251170-5013-28-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

include/linux/kvm.h defines struct kvm_dirty_log to
	[...]
	union {
		void __user *dirty_bitmap; /* one bit per page */
		__u64 padding;
	};

__user requires compiler.h to compile. Currently, this works on x86
only coincidentally due to other include files. This patch makes
kvm.h compile in all cases.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index c1b502a..3bd3828 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -8,6 +8,7 @@
  */
 
 #include <asm/types.h>
+#include <linux/compiler.h>
 #include <linux/ioctl.h>
 #include <asm/kvm.h>
 
-- 
1.5.4.5

