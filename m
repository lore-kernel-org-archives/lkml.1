Return-Path: <linux-kernel-owner+w=401wt.eu-S1752569AbXE3Bsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbXE3Bsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 21:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbXE3Bsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 21:48:31 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:30471 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXE3Bsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 21:48:30 -0400
Date: Tue, 29 May 2007 18:40:32 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 1/5] console: more buf for index parsing
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200705291840.32617.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/5] console: more buf for index parsing

change name to buf according to the usage as name + index

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/kernel/printk.c b/kernel/printk.c
index 0bbdeac..4961410 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -654,7 +654,7 @@ static void call_console_drivers(unsigned long start, unsigned long end)
  */
 static int __init console_setup(char *str)
 {
-	char name[sizeof(console_cmdline[0].name)];
+	char buf[sizeof(console_cmdline[0].name) + 4]; /* 4 for index */
 	char *s, *options;
 	int idx;
 
@@ -662,27 +662,27 @@ static int __init console_setup(char *str)
 	 * Decode str into name, index, options.
 	 */
 	if (str[0] >= '0' && str[0] <= '9') {
-		strcpy(name, "ttyS");
-		strncpy(name + 4, str, sizeof(name) - 5);
+		strcpy(buf, "ttyS");
+		strncpy(buf + 4, str, sizeof(buf) - 5);
 	} else {
-		strncpy(name, str, sizeof(name) - 1);
+		strncpy(buf, str, sizeof(buf) - 1);
 	}
-	name[sizeof(name) - 1] = 0;
+	buf[sizeof(buf) - 1] = 0;
 	if ((options = strchr(str, ',')) != NULL)
 		*(options++) = 0;
 #ifdef __sparc__
 	if (!strcmp(str, "ttya"))
-		strcpy(name, "ttyS0");
+		strcpy(buf, "ttyS0");
 	if (!strcmp(str, "ttyb"))
-		strcpy(name, "ttyS1");
+		strcpy(buf, "ttyS1");
 #endif
-	for (s = name; *s; s++)
+	for (s = buf; *s; s++)
 		if ((*s >= '0' && *s <= '9') || *s == ',')
 			break;
 	idx = simple_strtoul(s, NULL, 10);
 	*s = 0;
 
-	add_preferred_console(name, idx, options);
+	add_preferred_console(buf, idx, options);
 	return 1;
 }
 __setup("console=", console_setup);
@@ -709,7 +709,7 @@ int __init add_preferred_console(char *name, int idx, char *options)
 	 *	See if this tty is not yet registered, and
 	 *	if we have a slot free.
 	 */
-	for(i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
+	for (i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
 		if (strcmp(console_cmdline[i].name, name) == 0 &&
 			  console_cmdline[i].index == idx) {
 				selected_console = i;
