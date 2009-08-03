Return-Path: <linux-kernel-owner+w=401wt.eu-S1754134AbZHCCuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134AbZHCCuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 22:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZHCCuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 22:50:23 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34639 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbZHCCuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 22:50:23 -0400
Message-ID: <4A764FF3.50607@ct.jp.nec.com>
Date: Mon, 03 Aug 2009 11:48:19 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] posix-timers: fix oops in clock_nanosleep() with CLOCK_MONOTONIC_RAW
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Prevent calling do_nanosleep() with clockid CLOCK_MONOTONIC_RAW, it may
cause oops, such as NULL pointer dereference.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 kernel/posix-timers.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 052ec4d..d089d05 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -202,6 +202,12 @@ static int no_timer_create(struct k_itimer *new_timer)
 	return -EOPNOTSUPP;
 }
 
+static int no_nsleep(const clockid_t which_clock, int flags,
+		     struct timespec *tsave, struct timespec __user *rmtp)
+{
+	return -EOPNOTSUPP;
+}
+
 /*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
@@ -254,6 +260,7 @@ static __init int init_posix_timers(void)
 		.clock_get = posix_get_monotonic_raw,
 		.clock_set = do_posix_clock_nosettime,
 		.timer_create = no_timer_create,
+		.nsleep = no_nsleep,
 	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
-- 
1.6.3.3

