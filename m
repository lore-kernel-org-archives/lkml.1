Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbYILTsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbYILTsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbYILTso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:48:44 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:54207 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbYILTsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:48:43 -0400
X-BigFish: VPS-8(zz936eQzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <48CAC851.4020408@am.sony.com>
Date: Fri, 12 Sep 2008 12:51:45 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-embedded <linux-embedded@vger.kernel.org>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH]  Add better resolution to initcall_debug timings
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2008 19:48:30.0597 (UTC) FILETIME=[883A9350:01C91510]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the time resolution for initcall_debug to microseconds,
from milliseconds.  This is handy to determine which
initcalls you want to work on for faster booting.

One one of my test machines, over 90% of the initcalls are
less than a millisecond and (without this patch) these are
all reported as 0 msecs.  Working on the 900 us ones is more
important than the 4 us ones.

With 'quiet' on the kernel command line, this adds no significant
overhead to kernel boot time.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 init/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index bdc8be0..f441cad 100644
--- a/init/main.c
+++ b/init/main.c
@@ -719,8 +719,8 @@ int do_one_initcall(initcall_t fn)
 		delta = ktime_sub(t1, t0);

 		print_fn_descriptor_symbol("initcall %s", fn);
-		printk(" returned %d after %Ld msecs\n", result,
-			(unsigned long long) delta.tv64 >> 20);
+		printk(" returned %d after %Ld usecs\n", result,
+			(unsigned long long) delta.tv64 >> 10);
 	}

 	msgbuf[0] = 0;
-- 
1.5.6

