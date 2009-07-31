Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZGaVDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZGaVDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 17:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZGaVDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 17:03:09 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54671 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbZGaVDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 17:03:08 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 1/2] s390: Use macros for .data.page_aligned.
Date: Fri, 31 Jul 2009 16:58:30 -0400
Message-Id: <1249073911-30208-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.page_aligned should not need a separate output section, so as
part of this cleanup I moved into the .data output section in the
linker scripts in order to eliminate unnecessary references to the
section name.

Remove the reference to .data.idt, since nothing is put into the
.data.idt section on the s390 architecture.  It looks like Cyrill
Gorcunov posted a patch to remove the .data.idt code on s390
previously:

<http://lkml.indiana.edu/hypermail/linux/kernel/0802.2/2536.html>

CCing him and the people who acked that patch in case there's a reason
it wasn't applied.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/s390/kernel/vmlinux.lds.S |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index a53db23..8e023c8 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -60,6 +60,7 @@ SECTIONS
 	} :data
 
 	.data : {		/* Data */
+		PAGE_ALIGNED_DATA(PAGE_SIZE)
 		DATA_DATA
 		CONSTRUCTORS
 	}
@@ -72,11 +73,6 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	__nosave_end = .;
 
-	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : {
-		*(.data.idt)
-	}
-
 	. = ALIGN(0x100);
 	.data.cacheline_aligned : {
 		*(.data.cacheline_aligned)
-- 
1.6.3.3

