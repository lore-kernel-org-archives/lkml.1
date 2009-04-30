Return-Path: <linux-kernel-owner+w=401wt.eu-S1765027AbZEAABE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765027AbZEAABE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764768AbZD3Xzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:55:55 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60855 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764793AbZD3Xzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:55:53 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 4/5] parisc: use new macro for .data.read_mostly section.
Date: Thu, 30 Apr 2009 19:55:18 -0400
Message-Id: <1241135719-9286-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135719-9286-4-git-send-email-tabbott@mit.edu>
References: <1241135719-9286-1-git-send-email-tabbott@mit.edu>
 <1241135719-9286-2-git-send-email-tabbott@mit.edu>
 <1241135719-9286-3-git-send-email-tabbott@mit.edu>
 <1241135719-9286-4-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.read_mostly should not need a separate output section; this
change moves it into the .data section.

I used alignment L1_CACHE_BYTES instead of 16 since the whole point is
for read-mostly data to have different cache lines than other stuff.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
---
 arch/parisc/kernel/vmlinux.lds.S |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index c8a528d..3176407 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -94,19 +94,13 @@ SECTIONS
 		__stop___unwind = .;
 	}
 
-	/* rarely changed data like cpu maps */
-	. = ALIGN(16);
-	.data.read_mostly : {
-		*(.data.read_mostly)
-	}
-
-	. = ALIGN(L1_CACHE_BYTES);
 	/* Data */
 	.data : {
 		/* assembler code expects init_task to be 16k aligned */
 		INIT_TASK_DATA(16384)
 		NOSAVE_DATA
 		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
+		READ_MOSTLY_DATA(L1_CACHE_BYTES)
 		DATA_DATA
 		CONSTRUCTORS
 	}
-- 
1.6.2.1

