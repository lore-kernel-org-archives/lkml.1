Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0BRB6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 20:58:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:37316 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426Ab0BRB6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 20:58:37 -0500
Date: Thu, 18 Feb 2010 01:57:54 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de
In-Reply-To: <1265793639-15071-30-git-send-email-yinghai@kernel.org>
References: <1265793639-15071-30-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] init: Move radix_tree_init() early
Message-ID: <tip-773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9@git.kernel.org>
Git-Commit-ID: 773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Feb 2010 01:57:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9
Gitweb:     http://git.kernel.org/tip/773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Wed, 10 Feb 2010 01:20:33 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 17 Feb 2010 17:26:33 -0800

init: Move radix_tree_init() early

Prepare for using radix trees in early_irq_init().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <1265793639-15071-30-git-send-email-yinghai@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 4cb47a1..8451878 100644
--- a/init/main.c
+++ b/init/main.c
@@ -584,6 +584,7 @@ asmlinkage void __init start_kernel(void)
 		local_irq_disable();
 	}
 	rcu_init();
+	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
 	early_irq_init();
 	init_IRQ();
@@ -657,7 +658,6 @@ asmlinkage void __init start_kernel(void)
 	proc_caches_init();
 	buffer_init();
 	key_init();
-	radix_tree_init();
 	security_init();
 	vfs_caches_init(totalram_pages);
 	signals_init();
