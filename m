Return-Path: <linux-kernel-owner+w=401wt.eu-S934949AbZKYVjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934949AbZKYVjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932227AbZKYVjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:39:11 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58049 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759152AbZKYVjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:39:09 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org, Jie Zhang <jie.zhang@analog.com>
Subject: [PATCH 6/8] Blackfin: fix typo in ptrace poking
Date: Wed, 25 Nov 2009 16:39:05 -0500
Message-Id: <1259185147-31999-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
References: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Zhang <jie.zhang@analog.com>

Commit c014e15a2f667f9 (Blackfin: convert ptrace to new memory functions)
introduced a copy & paste typo in the ptrace poke data/text handling.  The
access_process_vm() function call was telling it to read instead of write.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index 0982b5d..56b0ba1 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -315,7 +315,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			case BFIN_MEM_ACCESS_CORE:
 			case BFIN_MEM_ACCESS_CORE_ONLY:
 				copied = access_process_vm(child, addr, &data,
-				                           to_copy, 0);
+				                           to_copy, 1);
 				if (copied)
 					break;
 
-- 
1.6.5.3

