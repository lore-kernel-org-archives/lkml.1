Return-Path: <linux-kernel-owner+w=401wt.eu-S1763170AbYBBIjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763170AbYBBIjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 03:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755492AbYBBIjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 03:39:06 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:1263 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbYBBIjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 03:39:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=D9fA1KkAPVogZeG/esNmDHvCajeK9oLdRW4dh31tb9Sg/+RRCQH7GGOv3trhYLivN28a/UxUe4mTIRFmNw3Y9beQFejxO4CxHlQcxd38dzeFt3D5NfUR3UHuzcq2yxew02/t5lMMKO51dIhmnp5S5U+W0nM/pJN1oIsEizfZ+Rs=
Message-ID: <804dabb00802020039j7ec7b66dlbf05fc9a80e1600a@mail.gmail.com>
Date: Sat, 2 Feb 2008 16:39:02 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Section mismatch warning patch - microcode.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors during compilation is corrected by the following
patch (against the latest linus tree):

WARNING: arch/x86/kernel/microcode.o(.exit.text+0x6): Section mismatch
in reference from the function cleanup_module() to the variable
.cpuinit.data:mc_cpu_notifier

Please comment.   Thanks.



diff -Nurp /tmp/microcode.c arch/x86/kernel/microcode.c
--- /tmp/microcode.c    2008-02-02 16:46:43.000000000 +0800
+++ arch/x86/kernel/microcode.c 2008-02-02 16:41:58.000000000 +0800
@@ -797,7 +797,7 @@ mc_cpu_callback(struct notifier_block *n
        return NOTIFY_OK;
 }

-static struct notifier_block __refdata mc_cpu_notifier = {
+static struct notifier_block mc_cpu_notifier __initdata = {
        .notifier_call = mc_cpu_callback,
 };

@@ -831,7 +831,7 @@ static int __init microcode_init (void)
        return 0;
 }

-static void __exit microcode_exit (void)
+static void __init microcode_exit (void)
 {
        microcode_dev_exit();
