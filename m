Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYJDVcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYJDVcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbYJDVcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:32:10 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:2759 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbYJDVcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:32:09 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] dumpstack: i386: make kstack= an early boot-param and add oops=panic
Date: Sat,  4 Oct 2008 23:12:45 +0200
Message-Id: <1223154766-19350-7-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223154766-19350-6-git-send-email-heukelum@fastmail.fm>
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-2-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-3-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-4-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-5-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-6-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Sat, 04 Oct 2008 23:31:50 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.243; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - make kstack= and early_param
 - add oops=panic, setting panic_on_oops

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/dumpstack_32.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 96d78c9..d5347f1 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -421,13 +421,24 @@ die_nmi(char *str, struct pt_regs *regs, int do_panic)
 	do_exit(SIGSEGV);
 }
 
+static int __init oops_setup(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	if (!strcmp(s, "panic"))
+		panic_on_oops = 1;
+	return 0;
+}
+early_param("oops", oops_setup);
+
 static int __init kstack_setup(char *s)
 {
+	if (!s)
+		return -EINVAL;
 	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
-
-	return 1;
+	return 0;
 }
-__setup("kstack=", kstack_setup);
+early_param("kstack", kstack_setup);
 
 static int __init code_bytes_setup(char *s)
 {
-- 
1.5.4.3

