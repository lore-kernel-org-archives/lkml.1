Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbZCIBmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbZCIBmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 21:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZCIBmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 21:42:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:51610 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079AbZCIBmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 21:42:03 -0400
From: Xiaotian Feng <Xiaotian.Feng@windriver.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V1] mips: fix mips syscall wrapper sys_32_ipc bug
Date: Mon,  9 Mar 2009 09:45:12 +0800
Message-Id: <1236563112-24287-1-git-send-email-Xiaotian.Feng@windriver.com>
X-Mailer: git-send-email 1.5.5.1
X-OriginalArrivalTime: 09 Mar 2009 01:41:51.0997 (UTC) FILETIME=[385D3AD0:01C9A058]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a typo in mips syscall wrapper sys_32_ipc. If CONFIG_SYSVIPC
is not set, it will cause mips linux compile error.

Signed-off-by: Xiaotian Feng <xiaotian.feng@windriver.com>
---
 arch/mips/kernel/linux32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index 2f8452b..1a86f84 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -235,7 +235,7 @@ SYSCALL_DEFINE6(32_ipc, u32, call, long, first, long, second, long, third,
 #else
 
 SYSCALL_DEFINE6(32_ipc, u32, call, int, first, int, second, int, third,
-	u32, ptr, u32 fifth)
+	u32, ptr, u32, fifth)
 {
 	return -ENOSYS;
 }
-- 
1.5.5.1

