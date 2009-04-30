Return-Path: <linux-kernel-owner+w=401wt.eu-S1763713AbZD3XxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763713AbZD3XxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763069AbZD3Xur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:50:47 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59880 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763088AbZD3Xuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:50:46 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Hirokazu Takata <takata@linux-m32r.org>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 2/3] m32r: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 19:47:59 -0400
Message-Id: <1241135280-8333-3-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135280-8333-2-git-send-email-tabbott@mit.edu>
References: <1241135280-8333-1-git-send-email-tabbott@mit.edu>
 <1241135280-8333-2-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.cacheline_aligned should not need a separate output section;
this change moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/kernel/vmlinux.lds.S |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index 1cfaff3..3e2de1f 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -52,13 +52,10 @@ SECTIONS
 	*(.spu)
 	*(.spi)
 	NOSAVE_DATA
+	CACHELINE_ALIGNED_DATA(32)
 	DATA_DATA
 	CONSTRUCTORS
 	}
-
-  . = ALIGN(32);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
-
   _edata = .;			/* End of data section */
 
   . = ALIGN(8192);		/* init_task */
-- 
1.6.2.1

