Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbYKDUPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbYKDUPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 15:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYKDUOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 15:14:52 -0500
Received: from jester.euphonynet.be ([212.87.96.13]:50383 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYKDUOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 15:14:52 -0500
Content-Disposition: inline
From: Bart Van Assche <bart.vanassche@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH][RESEND] C99 initializers for DEFINE_RATELIMIT_STATE()
Date: Tue, 4 Nov 2008 21:14:48 +0100
User-Agent: KMail/1.10.0 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200811042114.48495.bart.vanassche@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few months ago (July 25, 2008) the printk ratelimiting code has been
rewritten. This patch added a.o. the new macro DEFINE_RATELIMIT_STATE(). The
patch below converts the initializers in that macro to C99 style.

For more information about the printk ratelimiting rewrite, see also commit
717115e1a5856b57af0f71e1df7149108294fc10
(http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=commit;h=717115e1a5856b57af0f71e1df7149108294fc10).

Impact: cleanup, no functionality changed.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>

diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 18a5b9b..61cc908 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -13,8 +13,9 @@ struct ratelimit_state {
 	unsigned long begin;
 };
 
-#define DEFINE_RATELIMIT_STATE(name, interval, burst)		\
-		struct ratelimit_state name = {interval, burst,}
+#define DEFINE_RATELIMIT_STATE(name, interval_value, burst_value)	\
+	struct ratelimit_state name =					\
+		{ .interval = (interval_value), .burst = (burst_value) }
 
 extern int __ratelimit(struct ratelimit_state *rs);
 

-------------------------------------------------------
