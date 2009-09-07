Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbZIGDMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbZIGDMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 23:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbZIGDMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 23:12:23 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61109 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758731AbZIGDMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 23:12:23 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       linux-parisc@vger.kernel.org
Subject: [PATCH 2/2] parisc: Remove useless altinstructions code copied from x86.
Date: Sun,  6 Sep 2009 23:09:42 -0400
Message-Id: <1252292982-12969-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252292982-12969-1-git-send-email-tabbott@ksplice.com>
References: <1252292982-12969-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/parisc/kernel/vmlinux.lds.S |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/arch/parisc/kernel/vmlinux.lds.S b/arch/parisc/kernel/vmlinux.lds.S
index b2916d8..6ff3f00 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -135,31 +135,6 @@ SECTIONS
 	INIT_TEXT_SECTION(16384)
 	INIT_DATA_SECTION(16)
 
-	/* alternate instruction replacement.  This is a mechanism x86 uses
-	 * to detect the CPU type and replace generic instruction sequences
-	 * with CPU specific ones.  We don't currently do this in PA, but
-	 * it seems like a good idea...
-	 */
-	. = ALIGN(4);
-	.altinstructions : {
-		__alt_instructions = .;
-		*(.altinstructions)
-		__alt_instructions_end = .; 
-	} 
-	.altinstr_replacement : {
-		*(.altinstr_replacement)
-	} 
-
-	/* .exit.text is discard at runtime, not link time, to deal with references
-	 *  from .altinstructions and .eh_frame
-	 */
-	.exit.text : {
-		EXIT_TEXT
-	}
-	.exit.data : {
-		EXIT_DATA
-	}
-
 	PERCPU(PAGE_SIZE)
 	. = ALIGN(PAGE_SIZE);
 	__init_end = .;
-- 
1.6.3.3

