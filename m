Return-Path: <linux-kernel-owner+w=401wt.eu-S1753868AbYLSSXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbYLSSXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 13:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYLSSXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 13:23:08 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:28201 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYLSSXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 13:23:07 -0500
Message-ID: <494BE687.2040700@ct.jp.nec.com>
Date: Fri, 19 Dec 2008 10:23:03 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Toshikazu Nakayama <nakayama.ts@ncos.nec.co.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] printk: fix discarding message when recursion_bug
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: fix

When recursion_bug is true, kernel discards original message because printk_buf
contains recursion_bug_msg with NULL terminator. The sizeof(recursion_bug_msg)
makes this, use strlen() to get correct length without NULL terminator.

Reported-by: Toshikazu Nakayama <nakayama.ts@ncos.nec.co.jp>
Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index f492f15..e651ab0 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -662,7 +662,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	if (recursion_bug) {
 		recursion_bug = 0;
 		strcpy(printk_buf, recursion_bug_msg);
-		printed_len = sizeof(recursion_bug_msg);
+		printed_len = strlen(recursion_bug_msg);
 	}
 	/* Emit the output into the temporary buffer */
 	printed_len += vscnprintf(printk_buf + printed_len,
-- 
1.6.0.4

