Return-Path: <linux-kernel-owner+w=401wt.eu-S934635AbXEVTGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934635AbXEVTGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758482AbXEVTGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:06:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62535 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385AbXEVTGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:06:11 -0400
Date: Tue, 22 May 2007 12:09:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] add "notime" boot option
Message-Id: <20070522120938.db67f1e9.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add "notime" boot option to prevent timing data from being printed on
each printk message line.

We've seen a few cases of 'time' data locking problems (possibly
involving netconsole or net drivers).  If a kernel is built with
CONFIG_PRINTK_TIME=y, it may have a boot locking hang.  Booting
with "notime" may (i.e., could) prevent the lock hang and allow the
kernel to boot successfully, without requiring a kernel rebuild.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 kernel/printk.c                     |   10 +++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- linux-2622-rc2.orig/Documentation/kernel-parameters.txt
+++ linux-2622-rc2/Documentation/kernel-parameters.txt
@@ -1227,6 +1227,8 @@ and is between 256 and 4096 characters. 
 
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
+	notime		Do not print timing data on each printk message line.
+
 	notsc		[BUGS=IA-32] Disable Time Stamp Counter
 
 	nousb		[USB] Disable the USB subsystem
--- linux-2622-rc2.orig/kernel/printk.c
+++ linux-2622-rc2/kernel/printk.c
@@ -458,9 +458,17 @@ static int __init printk_time_setup(char
 	printk_time = 1;
 	return 1;
 }
-
 __setup("time", printk_time_setup);
 
+static int __init printk_notime_setup(char *str)
+{
+	if (*str)
+		return 0;
+	printk_time = 0;
+	return 1;
+}
+__setup("notime", printk_notime_setup);
+
 __attribute__((weak)) unsigned long long printk_clock(void)
 {
 	return sched_clock();
