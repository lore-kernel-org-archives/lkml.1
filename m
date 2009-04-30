Return-Path: <linux-kernel-owner+w=401wt.eu-S932902AbZEAAS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbZEAAS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765262AbZEAADZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:03:25 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61952 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764660AbZEAADX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:03:23 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, "David S. Miller" <davem@davemloft.net>,
       sparclinux@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/4] sparc: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 19:58:50 -0400
Message-Id: <1241135933-9913-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135933-9913-1-git-send-email-tabbott@mit.edu>
References: <1241135933-9913-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.cacheline_aligned should not need a separate output section;
this change moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/kernel/vmlinux.lds.S |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/vmlinux.lds.S b/arch/sparc/kernel/vmlinux.lds.S
index fcbbd00..6587e03 100644
--- a/arch/sparc/kernel/vmlinux.lds.S
+++ b/arch/sparc/kernel/vmlinux.lds.S
@@ -52,6 +52,7 @@ SECTIONS
 
 	RO_DATA(PAGE_SIZE)
 	.data :	{
+		CACHELINE_ALIGNED_DATA(SMP_CACHE_BYTES)
 		DATA_DATA
 		CONSTRUCTORS
 	}
@@ -59,10 +60,6 @@ SECTIONS
 		*(.data1)
 	}
 	. = ALIGN(SMP_CACHE_BYTES);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
-	}
-	. = ALIGN(SMP_CACHE_BYTES);
 	.data.read_mostly : {
 		*(.data.read_mostly)
 	}
-- 
1.6.2.1

