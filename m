Return-Path: <linux-kernel-owner+w=401wt.eu-S1764380AbZD3XDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764380AbZD3XDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756885AbZD3XDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:03:38 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52392 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbZD3XDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:03:37 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Richard Henderson <rth@twiddle.net>,
       linux-alpha@vger.kernel.org, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 2/4] alpha: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 19:00:14 -0400
Message-Id: <1241132416-7055-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241132416-7055-2-git-send-email-tabbott@mit.edu>
References: <1241132416-7055-1-git-send-email-tabbott@mit.edu>
 <1241132416-7055-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.cacheline_aligned should not need a separate output section;
this change moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Richard Henderson <rth@twiddle.net>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/kernel/vmlinux.lds.S |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/alpha/kernel/vmlinux.lds.S b/arch/alpha/kernel/vmlinux.lds.S
index 2f33cf9..7acd1eb 100644
--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -97,15 +97,11 @@ SECTIONS
 		*(.data.init_thread)
 	}
 
-	. = ALIGN(64);
-	.data.cacheline_aligned : {
-		*(.data.cacheline_aligned)
-	}
-
 	_data = .;
 	/* Data */
 	.data : {
 		PAGE_ALIGNED_DATA
+		CACHELINE_ALIGNED_DATA(64)
 		DATA_DATA
 		CONSTRUCTORS
 	}
-- 
1.6.2.1

