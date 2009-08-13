Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbZHMUJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbZHMUJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932170AbZHMUJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:09:17 -0400
Received: from kroah.org ([198.145.64.141]:41756 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbZHMT7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:39 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:29 2009
Message-Id: <20090813195129.603296702@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 34/74] posix-timers: Fix oops in clock_nanosleep() with CLOCK_MONOTONIC_RAW
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=posix-timers-fix-oops-in-clock_nanosleep-with-clock_monotonic_raw.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

commit 70d715fd0597f18528f389b5ac59102263067744 upstream.

Prevent calling do_nanosleep() with clockid
CLOCK_MONOTONIC_RAW, it may cause oops, such as NULL pointer
dereference.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <4A764FF3.50607@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/posix-timers.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -202,6 +202,12 @@ static int no_timer_create(struct k_itim
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
@@ -254,6 +260,7 @@ static __init int init_posix_timers(void
 		.clock_get = posix_get_monotonic_raw,
 		.clock_set = do_posix_clock_nosettime,
 		.timer_create = no_timer_create,
+		.nsleep = no_nsleep,
 	};
 
 	register_posix_clock(CLOCK_REALTIME, &clock_realtime);


