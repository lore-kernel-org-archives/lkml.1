Return-Path: <linux-kernel-owner+w=401wt.eu-S1764135AbZD3X4C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764135AbZD3X4C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:56:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764367AbZD3XyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:54:04 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60490 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764405AbZD3XyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:54:01 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/4] mips: use NOSAVE_DATA macro for .data.nosave section.
Date: Thu, 30 Apr 2009 19:53:27 -0400
Message-Id: <1241135610-9012-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135610-9012-1-git-send-email-tabbott@mit.edu>
References: <1241135610-9012-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the consequence of replacing the alignment of _PAGE_SIZE with
an alignment of PAGE_SIZE.  I believe these have the same value.

.data.nosave should not need a separate output section; this change
moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/kernel/vmlinux.lds.S |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 58738c8..2a6a995 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -78,7 +78,7 @@ SECTIONS
 		 */
 		. = ALIGN(_PAGE_SIZE);
 		*(.data.init_task)
-
+		NOSAVE_DATA
 		DATA_DATA
 		CONSTRUCTORS
 	}
@@ -96,14 +96,6 @@ SECTIONS
 		*(.sdata)
 	}
 
-	. = ALIGN(_PAGE_SIZE);
-	.data_nosave : {
-		__nosave_begin = .;
-		*(.data.nosave)
-	}
-	. = ALIGN(_PAGE_SIZE);
-	__nosave_end = .;
-
 	. = ALIGN(1 << CONFIG_MIPS_L1_CACHE_SHIFT);
 	.data.cacheline_aligned : {
 		*(.data.cacheline_aligned)
-- 
1.6.2.1

