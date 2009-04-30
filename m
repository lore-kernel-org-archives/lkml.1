Return-Path: <linux-kernel-owner+w=401wt.eu-S1760007AbZEAAKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007AbZEAAKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765073AbZEAABZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:01:25 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61414 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765062AbZEAABW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:01:22 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 7/8] powerpc: use new macro for .data.read_mostly section.
Date: Thu, 30 Apr 2009 19:56:16 -0400
Message-Id: <1241135777-9462-8-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135777-9462-7-git-send-email-tabbott@mit.edu>
References: <1241135777-9462-1-git-send-email-tabbott@mit.edu>
 <1241135777-9462-2-git-send-email-tabbott@mit.edu>
 <1241135777-9462-3-git-send-email-tabbott@mit.edu>
 <1241135777-9462-4-git-send-email-tabbott@mit.edu>
 <1241135777-9462-5-git-send-email-tabbott@mit.edu>
 <1241135777-9462-6-git-send-email-tabbott@mit.edu>
 <1241135777-9462-7-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.read_mostly should not need a separate output section; this
change moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/kernel/vmlinux.lds.S |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index f91d7c1..c982827 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -1,3 +1,4 @@
+
 #ifdef CONFIG_PPC64
 #define PROVIDE32(x)	PROVIDE(__unused__##x)
 #else
@@ -227,6 +228,7 @@ SECTIONS
 		PAGE_ALIGNED_DATA
 		NOSAVE_DATA
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
+		READ_MOSTLY_DATA(L1_CACHE_BYTES)
 		DATA_DATA
 #ifdef CONFIG_PPC32
 		*(.sdata)
@@ -254,11 +256,6 @@ SECTIONS
 	_edata  =  .;
 	PROVIDE32 (edata = .);
 
-	. = ALIGN(L1_CACHE_BYTES);
-	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-		*(.data.read_mostly)
-	}
-
 /*
  * And finally the bss
  */
-- 
1.6.2.1

