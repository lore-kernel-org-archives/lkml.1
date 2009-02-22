Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbZBVAB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbZBVAB0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbZBVABF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:01:05 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:49361 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475AbZBVABB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:01:01 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 01/16] kexec/i386: fix sparse warnings: Using plain integer as
	NULL pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:00:57 +0100
Message-ID: <20090222000051.17557.85888.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  arch/x86/kernel/machine_kexec_32.c:124:22: warning: Using plain integer as NULL pointer
  arch/x86/kernel/traps.c:950:24: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 arch/x86/kernel/machine_kexec_32.c |    2 +-
 arch/x86/kernel/traps.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 37f4200..f5fc8c7 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -121,7 +121,7 @@ static void machine_kexec_page_table_set_one(
 static void machine_kexec_prepare_page_tables(struct kimage *image)
 {
 	void *control_page;
-	pmd_t *pmd = 0;
+	pmd_t *pmd = NULL;
 
 	control_page = page_address(image->control_code_page);
 #ifdef CONFIG_X86_PAE
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ba90406..6882089 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -947,7 +947,7 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
 	info.si_signo = SIGILL;
 	info.si_errno = 0;
 	info.si_code = ILL_BADSTK;
-	info.si_addr = 0;
+	info.si_addr = NULL;
 	if (notify_die(DIE_TRAP, "iret exception",
 			regs, error_code, 32, SIGILL) == NOTIFY_STOP)
 		return;

