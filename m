Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZITSaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZITSaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZITSaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:30:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:52160 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442AbZITS37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:29:59 -0400
Date: Sun, 20 Sep 2009 18:29:38 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yhlu.kernel@gmail.com, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yhlu.kernel@gmail.com, jbeulich@novell.com, JBeulich@novell.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4AA0E85D02000078000136F9@vpn.id2.novell.com>
References: <4AA0E85D02000078000136F9@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Increase timeout for EHCI debug port reset completion in early printk
Message-ID: <tip-414128bd33fef3242747154dfa444970bc5caf4c@git.kernel.org>
Git-Commit-ID: 414128bd33fef3242747154dfa444970bc5caf4c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 20 Sep 2009 18:29:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  414128bd33fef3242747154dfa444970bc5caf4c
Gitweb:     http://git.kernel.org/tip/414128bd33fef3242747154dfa444970bc5caf4c
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 4 Sep 2009 09:13:49 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 20 Sep 2009 20:23:37 +0200

x86: Increase timeout for EHCI debug port reset completion in early printk

On one of my systems, several thousand iterations are needed before
CMD_RESET can be observed clear after setting it. Using a much
higher value here obviously cannot hurt.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
LKML-Reference: <4AA0E85D02000078000136F9@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/early_printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 335f049..b11cab3 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -624,7 +624,7 @@ try_next_port:
 		return -1;
 	}
 
-	loop = 10;
+	loop = 100000;
 	/* Reset the EHCI controller */
 	cmd = readl(&ehci_regs->command);
 	cmd |= CMD_RESET;
