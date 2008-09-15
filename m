Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYIOTAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYIOTAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 15:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYIOS7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:59:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32797 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbYIOS7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:59:53 -0400
Date: Mon, 15 Sep 2008 11:59:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] aio: fix sysctl build error
Message-Id: <20080915115940.718eea60.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

Put aio_nr sysctl inside ifdef CONFIG_AIO block to fix this build error:

kernel/built-in.o:(.data+0x2a2c): undefined reference to `aio_nr'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.27-rc5-mm1.orig/kernel/sysctl.c
+++ linux-2.6.27-rc5-mm1/kernel/sysctl.c
@@ -1336,6 +1336,7 @@ static struct ctl_table fs_table[] = {
 		.extra2		= &two,
 	},
 #endif
+#ifdef CONFIG_AIO
 	{
 		.procname	= "aio-nr",
 		.data		= &aio_nr,
@@ -1343,7 +1344,6 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0444,
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
-#ifdef CONFIG_AIO
 	{
 		.procname	= "aio-max-nr",
 		.data		= &aio_max_nr,
