Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbZEAA1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbZEAA1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764339AbZEAAFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:05:38 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62259 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763275AbZEAAFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:05:33 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 4/8] powerpc: use NOSAVE_DATA macro for .data.nosave section.
Date: Thu, 30 Apr 2009 19:56:13 -0400
Message-Id: <1241135777-9462-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135777-9462-4-git-send-email-tabbott@mit.edu>
References: <1241135777-9462-1-git-send-email-tabbott@mit.edu>
 <1241135777-9462-2-git-send-email-tabbott@mit.edu>
 <1241135777-9462-3-git-send-email-tabbott@mit.edu>
 <1241135777-9462-4-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.nosave should not need a separate output section; this change
moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/kernel/vmlinux.lds.S |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index d3dcea0..4223892 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -222,6 +222,7 @@ SECTIONS
 
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
 		PAGE_ALIGNED_DATA
+		NOSAVE_DATA
 		DATA_DATA
 #ifdef CONFIG_PPC32
 		*(.sdata)
@@ -268,14 +269,6 @@ SECTIONS
 		*(.data.read_mostly)
 	}
 
-	. = ALIGN(PAGE_SIZE);
-	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-	}
-
 /*
  * And finally the bss
  */
-- 
1.6.2.1

