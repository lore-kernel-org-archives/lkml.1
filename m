Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbZAHCLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbZAHCLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 21:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbZAHCKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 21:10:34 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43445 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866AbZAHCKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 21:10:30 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
       Martin Mares <mj@ucw.cz>, Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH 2/3] sysrq documentation: document why the command header only is shown
Date: Thu,  8 Jan 2009 02:10:25 +0000
Message-Id: <1231380626-20597-3-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1231380626-20597-1-git-send-email-apw@canonical.com>
References: <1231380626-20597-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the interactions between loglevel and the sysrq output.  Also
document how to work round it should output be required on the console.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Martin Mares <mj@ucw.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>

---
 Documentation/sysrq.txt |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysrq.txt b/Documentation/sysrq.txt
index 265f637..9e592c7 100644
--- a/Documentation/sysrq.txt
+++ b/Documentation/sysrq.txt
@@ -210,6 +210,24 @@ within a function called by handle_sysrq, you must be aware that you are in
 a lock (you are also in an interrupt handler, which means don't sleep!), so
 you must call __handle_sysrq_nolock instead.
 
+*  When I hit a SysRq key combination only the header appears on the console?
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Sysrq output is subject to the same console loglevel control as all
+other console output.  This means that if the kernel was booted 'quiet'
+as is common on distro kernels the output may not appear on the actual
+console, even though it will appear in the dmesg buffer, and be accessible
+via the dmesg command and to the consumers of /proc/kmsg.  As a specific
+exception the header line from the sysrq command is passed to all console
+consumers as if the current loglevel was maximum.  If only the header
+is emitted it is almost certain that the kernel loglevel is too low.
+Should you require the output on the console channel then you will need
+to temporarily up the console loglevel using alt-sysrq-8 or:
+
+    echo 8 > /proc/sysrq-trigger
+
+Remember to return the loglevel to normal after triggering the sysrq
+command you are interested in.
+
 *  I have more questions, who can I ask?
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 And I'll answer any questions about the registration system you got, also
-- 
1.6.0.4.911.gc990

