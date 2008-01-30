Return-Path: <linux-kernel-owner+w=401wt.eu-S1762668AbYA3OOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762668AbYA3OOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbYA3OOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:14:16 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:34715 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762282AbYA3OOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:14:14 -0500
Date: Wed, 30 Jan 2008 14:14:08 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH] Remove __INIT_REFOK and __INITDATA_REFOK
Message-ID: <20080130141408.GA6116@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 312b1485fb509c9bc32eda28ad29537896658cb8 made __INIT_REFOK expand
into .section .section ".ref.text", "ax".  Since the assembler doesn't
tolerate stuttering in the source that broke all MIPS builds.

Since with this change Sam downgraded __INIT_REFOK to just a backward
compat thing and there being only a single use in the MIPS arch code the
best solution is to delete both of __INIT_REFOK and __INITDATA_REFOK (which
was equally broken) being unused anyway these can be deleted.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---

I'll send out the MIPS bits as part of my next pull request to Linus.

diff --git a/include/linux/init.h b/include/linux/init.h
index 2efbda0..90cdbbb 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -124,9 +124,6 @@
 #define __REF            .section       ".ref.text", "ax"
 #define __REFDATA        .section       ".ref.data", "aw"
 #define __REFCONST       .section       ".ref.rodata", "aw"
-/* backward compatibility */
-#define __INIT_REFOK     .section	__REF
-#define __INITDATA_REFOK .section	__REFDATA
 
 #ifndef __ASSEMBLY__
 /*
