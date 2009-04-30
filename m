Return-Path: <linux-kernel-owner+w=401wt.eu-S1765155AbZEAABz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765155AbZEAABz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764081AbZD3X6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:58:31 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61068 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764135AbZD3X6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:58:30 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/5] parisc: use NOSAVE_DATA macro for .data.nosave section.
Date: Thu, 30 Apr 2009 19:55:15 -0400
Message-Id: <1241135719-9286-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135719-9286-1-git-send-email-tabbott@mit.edu>
References: <1241135719-9286-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.nosave should not need a separate output section; this change
moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
---
 arch/parisc/kernel/vmlinux.lds.S |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index fd2cc4f..0cc9658 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -103,6 +103,7 @@ SECTIONS
 	. = ALIGN(L1_CACHE_BYTES);
 	/* Data */
 	.data : {
+		NOSAVE_DATA
 		DATA_DATA
 		CONSTRUCTORS
 	}
@@ -118,17 +119,6 @@ SECTIONS
 		*(.data.lock_aligned)
 	}
 
-	/* nosave data is really only used for software suspend...it's here
-	 * just in case we ever implement it
-	 */
-	. = ALIGN(PAGE_SIZE);
-	__nosave_begin = .;
-	.data_nosave : {
-		*(.data.nosave)
-	}
-	. = ALIGN(PAGE_SIZE);
-	__nosave_end = .;
-
 	/* End of data section */
 	_edata = .;
 
-- 
1.6.2.1

