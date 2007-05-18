Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbXEREqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbXEREqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 00:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbXEREql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 00:46:41 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:32928 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750AbXEREql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 00:46:41 -0400
Date: Fri, 18 May 2007 13:45:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -rt] futex_performance_hack sysctl build fix
Message-ID: <20070518044559.GB22660@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-rt adds a futex_performance_hack sysctl, which is only defined if
kernel/futex.c is built in. This fixes the build in the CONFIG_FUTEX=n
case.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 kernel/sysctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.21-rt3/kernel/sysctl.c	2007-05-18 13:27:16.000000000 +0900
+++ linux-2.6.21-rt3-sh/kernel/sysctl.c	2007-05-18 13:41:23.000000000 +0900
@@ -226,6 +226,7 @@
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#ifdef CONFIG_FUTEX
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "futex_performance_hack",
@@ -234,6 +235,7 @@
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#endif
 	{
 		.ctl_name	= KERN_PANIC,
 		.procname	= "prof_pid",
