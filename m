Return-Path: <linux-kernel-owner+w=401wt.eu-S1751283AbXA3U71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbXA3U71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 15:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXA3U71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 15:59:27 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:3375 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbXA3U70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 15:59:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=M9pE5o9pI+fCrA6GWlX5cQXbxdOBt8e3FHMoM86Sfe5jP5jap7+D+u9xtBB/4XdqSObdl4UyyvjNq298YXnMDUybHRmWzVSTm7Zg8dQKGejiwn14VvEXY4TNZ47u/FbdXw6ZnshtuAhnW/jFSQ+DZz1VVoRM/sGHrwyjSbUyjFw=
Date: Tue, 30 Jan 2007 23:59:14 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Move TASK_XACCT, TASK_IO_ACCOUNTING up in menus
Message-ID: <20070130205914.GA5533@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since they depends on TASKSTATS, it would be nice to move them closer to
another options depending on TASKSTATS.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 Yes, it cost me ~10 minutes to turn TASK_XACCT on.

 init/Kconfig |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -192,6 +192,24 @@ config TASK_DELAY_ACCT
 
 	  Say N if unsure.
 
+config TASK_XACCT
+	bool "Enable extended accounting over taskstats (EXPERIMENTAL)"
+	depends on TASKSTATS
+	help
+	  Collect extended task accounting data and send the data
+	  to userland for processing over the taskstats interface.
+
+	  Say N if unsure.
+
+config TASK_IO_ACCOUNTING
+	bool "Enable per-task storage I/O accounting (EXPERIMENTAL)"
+	depends on TASK_XACCT
+	help
+	  Collect information on the number of bytes of storage I/O which this
+	  task has caused.
+
+	  Say N if unsure.
+
 config UTS_NS
 	bool "UTS Namespaces"
 	default n
@@ -295,24 +313,6 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say N.
 
-config TASK_XACCT
-	bool "Enable extended accounting over taskstats (EXPERIMENTAL)"
-	depends on TASKSTATS
-	help
-	  Collect extended task accounting data and send the data
-	  to userland for processing over the taskstats interface.
-
-	  Say N if unsure.
-
-config TASK_IO_ACCOUNTING
-	bool "Enable per-task storage I/O accounting (EXPERIMENTAL)"
-	depends on TASK_XACCT
-	help
-	  Collect information on the number of bytes of storage I/O which this
-	  task has caused.
-
-	  Say N if unsure.
-
 config SYSCTL
 	bool
 

