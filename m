Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbZD3Xvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbZD3Xvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760394AbZD3Xsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:48:41 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59557 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761636AbZD3Xsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:48:37 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Hirokazu Takata <takata@linux-m32r.org>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/3] m32r: use NOSAVE_DATA macro for .data.nosave section.
Date: Thu, 30 Apr 2009 19:47:58 -0400
Message-Id: <1241135280-8333-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135280-8333-1-git-send-email-tabbott@mit.edu>
References: <1241135280-8333-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the nice consequence of replacing the alignment of 4096 with
an alignment of PAGE_SIZE (=4096).

.data.nosave should not need a separate output section; this change
moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/kernel/vmlinux.lds.S |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/m32r/kernel/vmlinux.lds.S b/arch/m32r/kernel/vmlinux.lds.S
index 4179adf..1cfaff3 100644
--- a/arch/m32r/kernel/vmlinux.lds.S
+++ b/arch/m32r/kernel/vmlinux.lds.S
@@ -51,16 +51,11 @@ SECTIONS
   .data : {			/* Data */
 	*(.spu)
 	*(.spi)
+	NOSAVE_DATA
 	DATA_DATA
 	CONSTRUCTORS
 	}
 
-  . = ALIGN(4096);
-  __nosave_begin = .;
-  .data_nosave : { *(.data.nosave) }
-  . = ALIGN(4096);
-  __nosave_end = .;
-
   . = ALIGN(32);
   .data.cacheline_aligned : { *(.data.cacheline_aligned) }
 
-- 
1.6.2.1

