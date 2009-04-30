Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbZEAAFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbZEAAFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762279AbZD3X7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:59:35 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61117 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764918AbZD3X7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:59:34 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 2/4] mips: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 19:53:28 -0400
Message-Id: <1241135610-9012-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135610-9012-2-git-send-email-tabbott@mit.edu>
References: <1241135610-9012-1-git-send-email-tabbott@mit.edu>
 <1241135610-9012-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.cacheline_aligned should not need a separate output section;
this change moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/kernel/vmlinux.lds.S |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kernel/vmlinux.lds.S b/arch/mips/kernel/vmlinux.lds.S
index 2a6a995..ba459cb 100644
--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -79,6 +79,7 @@ SECTIONS
 		. = ALIGN(_PAGE_SIZE);
 		*(.data.init_task)
 		NOSAVE_DATA
+		CACHELINE_ALIGNED_DATA(1 << CONFIG_MIPS_L1_CACHE_SHIFT)
 		DATA_DATA
 		CONSTRUCTORS
 	}
@@ -95,11 +96,6 @@ SECTIONS
 	.sdata : {
 		*(.sdata)
 	}
-
-	. = ALIGN(1 << CONFIG_MIPS_L1_CACHE_SHIFT);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
-	}
 	_edata =  .;			/* End of data section */
 
 	/* will be freed after init */
-- 
1.6.2.1

