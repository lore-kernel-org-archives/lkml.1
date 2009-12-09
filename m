Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbZLIJ6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbZLIJ6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbZLIJ62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:58:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:45802 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408AbZLIJ6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:58:25 -0500
Date: Wed, 9 Dec 2009 09:56:59 GMT
From: tip-bot for Andy Isaacson <adi@hexapodia.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       hancockrwd@gmail.com, arjan@linux.intel.com, rz@linux-m68k.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       adi@hexapodia.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, hancockrwd@gmail.com, rz@linux-m68k.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       adi@hexapodia.org
In-Reply-To: <20091208083021.GB27174@hexapodia.org>
References: <20091208083021.GB27174@hexapodia.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Print DMI_BOARD_NAME as well as DMI_PRODUCT_NAME from __show_regs()
Message-ID: <tip-a1884b8e558ef6395f6033f9e1b69b332dd040e0@git.kernel.org>
Git-Commit-ID: a1884b8e558ef6395f6033f9e1b69b332dd040e0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1884b8e558ef6395f6033f9e1b69b332dd040e0
Gitweb:     http://git.kernel.org/tip/a1884b8e558ef6395f6033f9e1b69b332dd040e0
Author:     Andy Isaacson <adi@hexapodia.org>
AuthorDate: Tue, 8 Dec 2009 00:30:21 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Dec 2009 10:17:59 +0100

x86: Print DMI_BOARD_NAME as well as DMI_PRODUCT_NAME from __show_regs()

Robert Hancock observes that DMI_BOARD_NAME is often more useful
than DMI_PRODUCT_NAME, especially on standalone motherboards.
So, print both.

Signed-off-by: Andy Isaacson <adi@hexapodia.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Robert Hancock <hancockrwd@gmail.com>
Cc: Richard Zidlicky <rz@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <20091208083021.GB27174@hexapodia.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 90cf125..7a7bd4e 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -94,18 +94,21 @@ void exit_thread(void)
 
 void show_regs_common(void)
 {
-	const char *board;
+	const char *board, *product;
 
-	board = dmi_get_system_info(DMI_PRODUCT_NAME);
+	board = dmi_get_system_info(DMI_BOARD_NAME);
 	if (!board)
 		board = "";
+	product = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (!product)
+		product = "";
 
 	printk("\n");
-	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s\n",
+	printk(KERN_INFO "Pid: %d, comm: %.20s %s %s %.*s %s/%s\n",
 		current->pid, current->comm, print_tainted(),
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
-		init_utsname()->version, board);
+		init_utsname()->version, board, product);
 }
 
 void flush_thread(void)
