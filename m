Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322Ab0ANCPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0ANCPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:15:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754Ab0ANCPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:15:01 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44473 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab0ANCPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:15:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [resend][PATCH 1/2] kprobetrace,doc: shell need single quote to use $ character
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100114111032.D720.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 11:14:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shell interpret $val is as shell variable. thus we need quote if
we use echo command.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 Documentation/trace/kprobetrace.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 47aabee..2be6e19 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -82,13 +82,13 @@ Usage examples
 To add a probe as a new event, write a new definition to kprobe_events
 as below.
 
-  echo p:myprobe do_sys_open dfd=$arg0 filename=$arg1 flags=$arg2 mode=$arg3 > /sys/kernel/debug/tracing/kprobe_events
+  echo 'p:myprobe do_sys_open dfd=$arg0 filename=$arg1 flags=$arg2 mode=$arg3' > /sys/kernel/debug/tracing/kprobe_events
 
  This sets a kprobe on the top of do_sys_open() function with recording
 1st to 4th arguments as "myprobe" event. As this example shows, users can
 choose more familiar names for each arguments.
 
-  echo r:myretprobe do_sys_open $retval >> /sys/kernel/debug/tracing/kprobe_events
+  echo 'r:myretprobe do_sys_open $retval' >> /sys/kernel/debug/tracing/kprobe_events
 
  This sets a kretprobe on the return point of do_sys_open() function with
 recording return value as "myretprobe" event.
-- 
1.6.5.2



--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


