Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbYIZSGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbYIZSGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYIZSF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:05:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:37148 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbYIZSF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:05:58 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 3/5] kgdb, x86_64: gdb serial has BX and DX reversed
Date: Fri, 26 Sep 2008 13:05:18 -0500
Message-Id: <1222452320-16281-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.90.g436ed.dirty
In-Reply-To: <1222452320-16281-3-git-send-email-jason.wessel@windriver.com>
References: <1222452320-16281-1-git-send-email-jason.wessel@windriver.com>
 <1222452320-16281-2-git-send-email-jason.wessel@windriver.com>
 <1222452320-16281-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 26 Sep 2008 18:05:37.0737 (UTC) FILETIME=[7AB36390:01C92002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BX and DX registers in the gdb serial register packet need to be
flipped for gdb to receive the correct data.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/asm-x86/kgdb.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/kgdb.h b/include/asm-x86/kgdb.h
index 484c475..e86b306 100644
--- a/include/asm-x86/kgdb.h
+++ b/include/asm-x86/kgdb.h
@@ -42,9 +42,9 @@ enum regnames {
 #else /* ! CONFIG_X86_32 */
 enum regnames {
 	GDB_AX,			/* 0 */
-	GDB_DX,			/* 1 */
+	GDB_BX,			/* 1 */
 	GDB_CX,			/* 2 */
-	GDB_BX,			/* 3 */
+	GDB_DX,			/* 3 */
 	GDB_SI,			/* 4 */
 	GDB_DI,			/* 5 */
 	GDB_BP,			/* 6 */
-- 
1.6.0.90.g436ed.dirty

