Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbZG2M5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbZG2M5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZG2M5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:57:14 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:23084
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754778AbZG2M47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:56:59 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KNJNYD-04-3ZX-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/12] kvm/svm: make nested svm debugging runtime configurable
Date: Wed, 29 Jul 2009 14:56:21 +0200
Message-ID: <1248872192-30881-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
References: <1248872192-30881-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Jul 2009 12:56:36.0639 (UTC) FILETIME=[01BFDAF0:01CA104C]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b720b02..27d26c3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -49,11 +49,17 @@ MODULE_LICENSE("GPL");
 
 #define DEBUGCTL_RESERVED_BITS (~(0x3fULL))
 
-/* Turn on to get debugging output*/
-/* #define NESTED_DEBUG */
+/* Turn on to get debugging output for nested svm */
+#undef NESTED_DEBUG
 
 #ifdef NESTED_DEBUG
-#define nsvm_printk(fmt, args...) printk(KERN_INFO fmt, ## args)
+
+static int nested_dbg;
+module_param(nested_dbg, bool, 0644);
+
+#define nsvm_printk(fmt, args...)	\
+	if (nested_dbg)			\
+		printk(KERN_INFO fmt, ## args)
 #else
 #define nsvm_printk(fmt, args...) do {} while(0)
 #endif
-- 
1.6.3.3


