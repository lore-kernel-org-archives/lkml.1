Return-Path: <linux-kernel-owner+w=401wt.eu-S933031AbXIUWq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbXIUWq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763526AbXIUWco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:57095 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763985AbXIUWci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:38 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [37/50] x86_64: Clean up mce= argument parsing slightly
Message-Id: <20070921223237.36D821479D@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Move the = into the __setup line.
Document the option in kernel-parameters.txt by adding a pointer
to the x86-64 specific documentation.

Pointed out by Robert Day
Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/kernel-parameters.txt |    2 ++
 arch/x86_64/kernel/mce.c            |    4 +---
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -970,6 +970,8 @@ and is between 256 and 4096 characters. 
 
 	mce		[X86-32] Machine Check Exception
 
+	mce=option	[X86-64] See Documentation/x86-64/boot-options.txt
+
 	md=		[HW] RAID subsystems devices and level
 			See Documentation/md.txt.
 
Index: linux/arch/x86_64/kernel/mce.c
===================================================================
--- linux.orig/arch/x86_64/kernel/mce.c
+++ linux/arch/x86_64/kernel/mce.c
@@ -699,8 +699,6 @@ static int __init mcheck_disable(char *s
    mce=nobootlog Don't log MCEs from before booting. */
 static int __init mcheck_enable(char *str)
 {
-	if (*str == '=')
-		str++;
 	if (!strcmp(str, "off"))
 		mce_dont_init = 1;
 	else if (!strcmp(str, "bootlog") || !strcmp(str,"nobootlog"))
@@ -713,7 +711,7 @@ static int __init mcheck_enable(char *st
 }
 
 __setup("nomce", mcheck_disable);
-__setup("mce", mcheck_enable);
+__setup("mce=", mcheck_enable);
 
 /* 
  * Sysfs support
