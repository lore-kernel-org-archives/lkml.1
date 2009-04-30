Return-Path: <linux-kernel-owner+w=401wt.eu-S1763766AbZEAAAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763766AbZEAAAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764791AbZD3Xzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:55:46 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60832 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764784AbZD3Xzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:55:45 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 2/5] parisc: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 19:55:16 -0400
Message-Id: <1241135719-9286-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135719-9286-2-git-send-email-tabbott@mit.edu>
References: <1241135719-9286-1-git-send-email-tabbott@mit.edu>
 <1241135719-9286-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.cacheline_aligned should not need a separate output section;
this change moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
---
 arch/parisc/kernel/vmlinux.lds.S |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index 0cc9658..b5936c9 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -104,15 +104,11 @@ SECTIONS
 	/* Data */
 	.data : {
 		NOSAVE_DATA
+		CACHELINE_ALIGNED_DATA(L1_CACHE_BYTES)
 		DATA_DATA
 		CONSTRUCTORS
 	}
 
-	. = ALIGN(L1_CACHE_BYTES);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
-	}
-
 	/* PA-RISC locks requires 16-byte alignment */
 	. = ALIGN(16);
 	.data.lock_aligned : {
-- 
1.6.2.1

