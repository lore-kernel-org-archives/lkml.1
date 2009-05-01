Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbZEAA3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbZEAA3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765689AbZEAAHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:07:10 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62553 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765668AbZEAAHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:07:07 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/5] ia64: Use .ref.text, not .text.init for start_ap.
Date: Thu, 30 Apr 2009 20:04:03 -0400
Message-Id: <1241136247-10623-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136247-10623-1-git-send-email-tabbott@mit.edu>
References: <1241136247-10623-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that start_ap doesn't need to be in a special location in the
kernel, but it references some init code so it should be in .ref.text.

Since this is the only thing in the .text.head section, eliminate
.text.head from the linker script.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/kernel/head.S        |    2 +-
 arch/ia64/kernel/vmlinux.lds.S |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/head.S b/arch/ia64/kernel/head.S
index 23f846d..8239ff6 100644
--- a/arch/ia64/kernel/head.S
+++ b/arch/ia64/kernel/head.S
@@ -181,7 +181,7 @@ swapper_pg_dir:
 halt_msg:
 	stringz "Halting kernel\n"
 
-	.section .text.head,"ax"
+	__REF
 
 	.global start_ap
 
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 4a95e86..fa3a558 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -51,8 +51,6 @@ SECTIONS
 	KPROBES_TEXT
 	*(.gnu.linkonce.t*)
     }
-  .text.head : AT(ADDR(.text.head) - LOAD_OFFSET)
-	{ *(.text.head) }
   .text2 : AT(ADDR(.text2) - LOAD_OFFSET)
 	{ *(.text2) }
 #ifdef CONFIG_SMP
-- 
1.6.2.1

