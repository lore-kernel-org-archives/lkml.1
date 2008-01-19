Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYAST6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYAST6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 14:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYAST6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 14:58:08 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:22047 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbYAST6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 14:58:07 -0500
Date: Sat, 19 Jan 2008 11:57:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: tglx <tglx@linutronix.de>, akpm <akpm@linux-foundation.org>,
       samr <sam@ravnborg.org>
Subject: [PATCH] timer: fix section mismatch
Message-Id: <20080119115715.7efac363.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The caller is __cpuinit.
Also, this code block and its caller are inside #ifdef CONFIG_HOTPLUG_CPU
blocks, so this code should reflect that config symbol's usage.

WARNING: vmlinux.o(.text+0x4252f): Section mismatch: reference to .init.text: (between 'timer_cpu_notify' and 'msleep')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc8-git2.orig/kernel/timer.c
+++ linux-2.6.24-rc8-git2/kernel/timer.c
@@ -1289,7 +1289,7 @@ static void migrate_timer_list(tvec_base
 	}
 }
 
-static void __devinit migrate_timers(int cpu)
+static void __cpuinit migrate_timers(int cpu)
 {
 	tvec_base_t *old_base;
 	tvec_base_t *new_base;
