Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbZFZONa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbZFZONa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758287AbZFZONH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:13:07 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:61927 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753385AbZFZONG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:13:06 -0400
Subject: [PATCH 1/4] kmemleak: Enable task stacks scanning by default
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Date: Fri, 26 Jun 2009 15:12:41 +0100
Message-ID: <20090626141241.31504.48118.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090626140847.31504.79381.stgit@pc1117.cambridge.arm.com>
References: <20090626140847.31504.79381.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2009 14:12:41.0721 (UTC) FILETIME=[2B1E5690:01C9F668]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to reduce the number of false positives reported.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/kmemleak.txt |    8 ++++----
 mm/kmemleak.c              |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
index f655308..9426e94 100644
--- a/Documentation/kmemleak.txt
+++ b/Documentation/kmemleak.txt
@@ -31,12 +31,12 @@ Memory scanning parameters can be modified at run-time by writing to the
 /sys/kernel/debug/kmemleak file. The following parameters are supported:
 
   off		- disable kmemleak (irreversible)
-  stack=on	- enable the task stacks scanning
+  stack=on	- enable the task stacks scanning (default)
   stack=off	- disable the tasks stacks scanning
-  scan=on	- start the automatic memory scanning thread
+  scan=on	- start the automatic memory scanning thread (default)
   scan=off	- stop the automatic memory scanning thread
-  scan=<secs>	- set the automatic memory scanning period in seconds (0
-		  to disable it)
+  scan=<secs>	- set the automatic memory scanning period in seconds
+		  (default 600, 0 to stop the automatic scanning)
 
 Kmemleak can also be disabled at boot-time by passing "kmemleak=off" on
 the kernel command line.
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 17096d1..a38418a 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -194,7 +194,7 @@ static unsigned long jiffies_min_age;
 /* delay between automatic memory scannings */
 static signed long jiffies_scan_wait;
 /* enables or disables the task stacks scanning */
-static int kmemleak_stack_scan;
+static int kmemleak_stack_scan = 1;
 /* mutex protecting the memory scanning */
 static DEFINE_MUTEX(scan_mutex);
 /* mutex protecting the access to the /sys/kernel/debug/kmemleak file */

