Return-Path: <linux-kernel-owner+w=401wt.eu-S1760646AbZD3Xq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbZD3Xq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759512AbZD3Xp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:45:56 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59159 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759786AbZD3Xpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:45:55 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, David Howells <dhowells@redhat.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/3] frv: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 19:45:33 -0400
Message-Id: <1241135135-8084-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135135-8084-1-git-send-email-tabbott@mit.edu>
References: <1241135135-8084-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.cacheline_aligned should not need a separate output section;
this change moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/kernel/vmlinux.lds.S |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/frv/kernel/vmlinux.lds.S b/arch/frv/kernel/vmlinux.lds.S
index 22d9787..dc61f3e 100644
--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -76,9 +76,6 @@ SECTIONS
 	  *(.data.init_task)
   }
 
-  . = ALIGN(L1_CACHE_BYTES);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
-
   .trap : {
 	/* trap table management - read entry-table.S before modifying */
 	. = ALIGN(8192);
@@ -131,6 +128,7 @@ SECTIONS
 
   _sdata = .;
   .data : {			/* Data */
+	CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 	DATA_DATA
 	*(.data.*)
 	EXIT_DATA
-- 
1.6.2.1

