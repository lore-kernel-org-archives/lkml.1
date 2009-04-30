Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbZD3X5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbZD3X5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759634AbZD3XyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:54:17 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60506 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764350AbZD3XyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:54:15 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/2] m68k: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 19:49:22 -0400
Message-Id: <1241135363-8506-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135363-8506-1-git-send-email-tabbott@mit.edu>
References: <1241135363-8506-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.cacheline_aligned should not need a separate output section;
this change moves it into the .data section.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 arch/m68k/kernel/vmlinux-std.lds |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/kernel/vmlinux-std.lds b/arch/m68k/kernel/vmlinux-std.lds
index 01d212b..ac800bc 100644
--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -30,13 +30,11 @@ SECTIONS
   RODATA
 
   .data : {			/* Data */
+	CACHELINE_ALIGNED_DATA(16)
 	DATA_DATA
 	CONSTRUCTORS
 	}
 
-  . = ALIGN(16);
-  .data.cacheline_aligned : { *(.data.cacheline_aligned) }
-
   .bss : { *(.bss) }		/* BSS */
 
   _edata = .;			/* End of data section */
-- 
1.6.2.1

