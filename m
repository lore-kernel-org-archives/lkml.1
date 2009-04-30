Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbZEAAV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbZEAAV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765439AbZEAADi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:03:38 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61966 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765406AbZEAADd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:03:33 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>,
       Tim Abbott <tabbott@MIT.EDU>, linux-sh@vger.kernel.org
Subject: [PATCH 4/7] sh: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 19:58:00 -0400
Message-Id: <1241135883-9766-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135883-9766-4-git-send-email-tabbott@mit.edu>
References: <1241135883-9766-1-git-send-email-tabbott@mit.edu>
 <1241135883-9766-2-git-send-email-tabbott@mit.edu>
 <1241135883-9766-3-git-send-email-tabbott@mit.edu>
 <1241135883-9766-4-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I moved the section after NOSAVE_DATA with the intention of having the
alignment levels of the sections placed in the .data output section
being strictly decreasing.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/kernel/vmlinux_32.lds.S |    4 +---
 arch/sh/kernel/vmlinux_64.lds.S |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/sh/kernel/vmlinux_32.lds.S b/arch/sh/kernel/vmlinux_32.lds.S
index 5f5e190..eabb0bb 100644
--- a/arch/sh/kernel/vmlinux_32.lds.S
+++ b/arch/sh/kernel/vmlinux_32.lds.S
@@ -64,13 +64,11 @@ SECTIONS
 		*(.data.init_task)
 
 		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
-
-		. = ALIGN(L1_CACHE_BYTES);
 		*(.data.read_mostly)
 
 		PAGE_ALIGNED_DATA
 		NOSAVE_DATA
+		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 		DATA_DATA
 		CONSTRUCTORS
 	}
diff --git a/arch/sh/kernel/vmlinux_64.lds.S b/arch/sh/kernel/vmlinux_64.lds.S
index 9cccb3d..e0e2e1b 100644
--- a/arch/sh/kernel/vmlinux_64.lds.S
+++ b/arch/sh/kernel/vmlinux_64.lds.S
@@ -73,13 +73,11 @@ SECTIONS
 		*(.data.init_task)
 
 		. = ALIGN(L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
-
-		. = ALIGN(L1_CACHE_BYTES);
 		*(.data.read_mostly)
 
 		PAGE_ALIGNED_DATA
 		NOSAVE_DATA
+		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 		DATA_DATA
 		CONSTRUCTORS
 	}
-- 
1.6.2.1

