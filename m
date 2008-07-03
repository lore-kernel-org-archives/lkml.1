Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbYGCIZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbYGCIZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 04:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYGCIQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 04:16:43 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:59480 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933964AbYGCHJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 03:09:53 -0400
Date: Thu, 3 Jul 2008 16:09:52 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, xen-ia64-devel@lists.xensource.com,
       linux-ia64@vger.kernel.org
Subject: [PATCH] xen: compilation fix for ia64 support.
Message-ID: <20080703070952.GB15683%yamahata@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

don't include asm/pvclock-abi.h directly, but asm/xen/pvclock-abi.h
At this moment linux ia64 won't accept asm/pvclock-abi.h because
there's no user of it. Instead make it include asm/xen/pvclock-abi.h
and create asm-x86/xen/pvclock-abi.h which includes asm-x86/pvclock-abi.h.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 include/asm-x86/xen/pvclock-abi.h |    6 ++++++
 include/xen/interface/xen.h       |    2 +-
 2 files changed, 7 insertions(+), 1 deletions(-)
 create mode 100644 include/asm-x86/xen/pvclock-abi.h

diff --git a/include/asm-x86/xen/pvclock-abi.h b/include/asm-x86/xen/pvclock-abi.h
new file mode 100644
index 0000000..a4476db
--- /dev/null
+++ b/include/asm-x86/xen/pvclock-abi.h
@@ -0,0 +1,6 @@
+#ifndef __XEN_PVCLOCK_ABI_H
+#define __XEN_PVCLOCK_ABI_H
+
+#include <asm-x86/pvclock-abi.h>
+
+#endif /* __XEN_PVCLOCK_ABI_H */
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 2befa3e..c36888b 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -10,7 +10,7 @@
 #define __XEN_PUBLIC_XEN_H__
 
 #include <asm/xen/interface.h>
-#include <asm/pvclock-abi.h>
+#include <asm/xen/pvclock-abi.h>
 
 /*
  * XEN "SYSTEM CALLS" (a.k.a. HYPERCALLS).
-- 
1.5.3

