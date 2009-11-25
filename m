Return-Path: <linux-kernel-owner+w=401wt.eu-S935078AbZKYVkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935078AbZKYVkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932227AbZKYVkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:40:43 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58053 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177AbZKYVjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:39:11 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 8/8] Blackfin: fix SMP build error in start_thread()
Date: Wed, 25 Nov 2009 16:39:07 -0500
Message-Id: <1259185147-31999-9-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
References: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Commit d5ce528c8e46fa5afb9 (Blackfin: convert irq/process to asm-generic)
incorrectly merged the smp and non-smp cases of start_thread() causing the
L1 stack to be setup on the SMP port instead of the UP port.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 430ae39..5cc7e2e 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -151,7 +151,7 @@ void start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_
 	regs->pc = new_ip;
 	if (current->mm)
 		regs->p5 = current->mm->start_data;
-#ifdef CONFIG_SMP
+#ifndef CONFIG_SMP
 	task_thread_info(current)->l1_task_info.stack_start =
 		(void *)current->mm->context.stack_start;
 	task_thread_info(current)->l1_task_info.lowest_sp = (void *)new_sp;
-- 
1.6.5.3

