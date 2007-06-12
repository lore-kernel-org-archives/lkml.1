Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbXFLDOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbXFLDOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXFLDN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:13:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbXFLDN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:13:56 -0400
Date: Mon, 11 Jun 2007 23:13:54 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Allow softlockup to be runtime disabled.
Message-ID: <20070612031354.GA18471@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's useful sometimes to disable the softlockup checker at boottime.
Especially if it triggers during a distro install.

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6/init/main.c~	2006-03-05 00:45:51.000000000 -0500
+++ linux-2.6/init/main.c	2006-03-05 00:49:41.000000000 -0500
@@ -732,6 +732,15 @@ static void __init do_basic_setup(void)
 	do_initcalls();
 }
 
+static int __initdata nosoftlockup;
+
+static int __init nosoftlockup_setup(char *str)
+{
+	nosoftlockup = 1;
+	return 1;
+}
+__setup("nosoftlockup", nosoftlockup_setup);
+
 static void __init do_pre_smp_initcalls(void)
 {
 	extern int spawn_ksoftirqd(void);
@@ -649,7 +657,8 @@ static void do_pre_smp_initcalls(void)
 	migration_init();
 #endif
 	spawn_ksoftirqd();
-	spawn_softlockup_task();
+	if (!nosoftlockup)
+		spawn_softlockup_task();
 }
 
 static void run_init_process(char *init_filename)

-- 
http://www.codemonkey.org.uk
