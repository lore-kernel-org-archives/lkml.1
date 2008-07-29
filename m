Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbYG2Hjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbYG2Hjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYG2Hjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:39:45 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:8538 "EHLO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYG2Hjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:39:44 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-2.tower-29.messagelabs.com!1217317183!9712396!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>, <trivial@kernel.org>
CC: Dave Young <hidave.darkstar@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] fix comment for printk rate limiting
Date: Tue, 29 Jul 2008 09:39:37 +0200
Message-ID: <1217317177-17812-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1211365251-7776-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <1211365251-7776-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 Jul 2008 07:39:38.0108 (UTC) FILETIME=[410B93C0:01C8F14E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment assumed the burst to be one and the ratelimit used to be named
printk_ratelimit_jiffies.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
Hello,

The comment was already wrong before commit

	717115e... printk ratelimiting rewrite

but I selected the Cc: list from this commit.

@trivial: I already sent a patch that updates the comment to the state before
717115e.  You probably should drop this now as it became wrong.

Best regards
Uwe

 kernel/printk.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index a7f7559..b51b156 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1309,14 +1309,14 @@ void tty_write_message(struct tty_struct *tty, char *msg)
 
 #if defined CONFIG_PRINTK
 
-DEFINE_RATELIMIT_STATE(printk_ratelimit_state, 5 * HZ, 10);
 /*
  * printk rate limiting, lifted from the networking subsystem.
  *
- * This enforces a rate limit: not more than one kernel message
- * every printk_ratelimit_jiffies to make a denial-of-service
- * attack impossible.
+ * This enforces a rate limit: not more than 10 kernel messages
+ * every 5s to make a denial-of-service attack impossible.
  */
+DEFINE_RATELIMIT_STATE(printk_ratelimit_state, 5 * HZ, 10);
+
 int printk_ratelimit(void)
 {
 	return __ratelimit(&printk_ratelimit_state);
-- 
1.5.6.3

