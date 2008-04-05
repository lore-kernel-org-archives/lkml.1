Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYDENvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYDENvv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYDENup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:50:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:17899 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbYDENuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=AYZDB9cyroRQzeVsYyi83mHowKdJA74ehg+XFc7MNKMmU+ERz8PqU9a8KBz3JaQuPN22fQlWYxEuxsdQshoo0WE5d/Z9ipskTfCny9f/6Ve3C+cppb8t1zMt59Hls2K7meJE5AMctxFZ27tvPB4YnjXpSjznX6F2b7BhMO8C3E4=
References: <20080405133903.770639386@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Apr 2008 22:39:09 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 6/9] x86: use cpu_online()
Content-Disposition: inline; filename=x86-use-cpu_online.patch
Message-ID: <47f783ad.2b26360a.3f2e.ffff8ba5@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/reboot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: 2.6-git/arch/x86/kernel/reboot.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/reboot.c
+++ 2.6-git/arch/x86/kernel/reboot.c
@@ -412,12 +412,12 @@ static void native_machine_shutdown(void
 #ifdef CONFIG_X86_32
 	/* See if there has been given a command line override */
 	if ((reboot_cpu != -1) && (reboot_cpu < NR_CPUS) &&
-		cpu_isset(reboot_cpu, cpu_online_map))
+		cpu_online(reboot_cpu))
 		reboot_cpu_id = reboot_cpu;
 #endif
 
 	/* Make certain the cpu I'm about to reboot on is online */
-	if (!cpu_isset(reboot_cpu_id, cpu_online_map))
+	if (!cpu_online(reboot_cpu_id))
 		reboot_cpu_id = smp_processor_id();
 
 	/* Make certain I only run on the appropriate processor */

-- 
