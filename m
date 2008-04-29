Return-Path: <linux-kernel-owner+w=401wt.eu-S1758861AbYD2Bes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861AbYD2Bes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYD2Bek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:34:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33531 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYD2Bej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:34:39 -0400
Message-ID: <48167B03.3010509@jp.fujitsu.com>
Date: Tue, 29 Apr 2008 10:33:55 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] stop_machine: add stopmachine_timeout sysctl entry
References: <481678F5.7080504@jp.fujitsu.com>
In-Reply-To: <481678F5.7080504@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There would be some system which cannot accept the arbitrary
timeout value(= 5sec).

This patch allow us to change the value via sysctl.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 kernel/stop_machine.c |    2 +-
 kernel/sysctl.c       |   10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index cd2ba88..cc6c8ec 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -31,7 +31,7 @@ static unsigned int stopmachine_num_threads;
 static atomic_t stopmachine_thread_ack;
 static atomic_t stopmachine_busy_exit;
 
-static unsigned long stopmachine_timeout = 5; /* secs, arbitrary */
+unsigned long stopmachine_timeout = 5; /* secs, arbitrary */
 
 static int stopmachine(void *cpu)
 {
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index fd33648..fe489a7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -80,6 +80,7 @@ extern int compat_log;
 extern int maps_protect;
 extern int sysctl_stat_interval;
 extern int latencytop_enabled;
+extern unsigned long stopmachine_timeout;
 
 /* Constants used for minimum and  maximum */
 #if defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
@@ -809,6 +810,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dostring,
 		.strategy	= &sysctl_string,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "stopmachine_timeout",
+		.data		= &stopmachine_timeout,
+		.maxlen		= sizeof(unsigned long),
+		.mode		= 0644,
+		.proc_handler	= &proc_doulongvec_minmax,
+		.strategy	= &sysctl_intvec,
+	},
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt

