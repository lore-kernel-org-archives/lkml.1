Return-Path: <linux-kernel-owner+w=401wt.eu-S1764598AbZD3XzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764598AbZD3XzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763628AbZD3XwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:52:00 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60157 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763590AbZD3Xv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:51:58 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Michal Simek <monstr@monstr.eu>,
       microblaze-uclinux@itee.uq.edu.au, Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 1/2] microblaze: use new macro for .data.cacheline_aligned section.
Date: Thu, 30 Apr 2009 19:51:03 -0400
Message-Id: <1241135464-8778-2-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241135464-8778-1-git-send-email-tabbott@mit.edu>
References: <1241135464-8778-1-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au
---
 arch/microblaze/kernel/vmlinux.lds.S |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/microblaze/kernel/vmlinux.lds.S b/arch/microblaze/kernel/vmlinux.lds.S
index 840385e..de25a68 100644
--- a/arch/microblaze/kernel/vmlinux.lds.S
+++ b/arch/microblaze/kernel/vmlinux.lds.S
@@ -64,9 +64,8 @@ SECTIONS {
 	_sdata = . ;
 	.data ALIGN (4096) : { /* page aligned when MMU used - origin 0x4 */
 		*(.data)
+		CACHELINE_ALIGNED_DATA(32)
 	}
-	. = ALIGN(32);
-	.data.cacheline_aligned : { *(.data.cacheline_aligned) }
 	_edata = . ;
 
 	/* Reserve some low RAM for r0 based memory references */
-- 
1.6.2.1

