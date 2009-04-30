Return-Path: <linux-kernel-owner+w=401wt.eu-S1765023AbZEAATe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765023AbZEAATe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763259AbZEAAD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:03:28 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61966 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765393AbZEAAD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:03:27 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, "David S. Miller" <davem@davemloft.net>,
       sparclinux@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 3/4] sparc: use new macro for .data.read_mostly section.
Date: Thu, 30 Apr 2009 19:58:52 -0400
Message-Id: <1241135933-9913-4-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135933-9913-3-git-send-email-tabbott@mit.edu>
References: <1241135933-9913-1-git-send-email-tabbott@mit.edu>
 <1241135933-9913-2-git-send-email-tabbott@mit.edu>
 <1241135933-9913-3-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.read_mostly should not need a separate output section; this
change moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/kernel/vmlinux.lds.S |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index 3fbf650..4760796 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -54,16 +54,13 @@ SECTIONS
 	.data :	{
 		INIT_TASK_DATA(THREAD_SIZE)
 		CACHELINE_ALIGNED_DATA(SMP_CACHE_BYTES)
+		READ_MOSTLY_DATA(SMP_CACHE_BYTES)
 		DATA_DATA
 		CONSTRUCTORS
 	}
 	.data1 : {
 		*(.data1)
 	}
-	. = ALIGN(SMP_CACHE_BYTES);
-	.data.read_mostly : {
-		*(.data.read_mostly)
-	}
 	/* End of data section */
 	_edata = .;
 
-- 
1.6.2.1

