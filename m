Return-Path: <linux-kernel-owner+w=401wt.eu-S1030650AbXCSVm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030650AbXCSVm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030626AbXCSVlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:41:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:55711 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965028AbXCSVlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:41:16 -0400
Date: Mon, 19 Mar 2007 14:39:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, mingo@elte.hu,
       tglx@linutronix.de
Subject: [patch 15/31] fix MTIME_SEC_MAX on 32-bit
Message-ID: <20070319213927.GQ9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-mtime_sec_max-on-32-bit.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

The maximum seconds value we can handle on 32bit is LONG_MAX.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/ktime.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -57,7 +57,11 @@ typedef union {
 } ktime_t;
 
 #define KTIME_MAX			((s64)~((u64)1 << 63))
-#define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#if (BITS_PER_LONG == 64)
+# define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
+#else
+# define KTIME_SEC_MAX			LONG_MAX
+#endif
 
 /*
  * ktime_t definitions when using the 64-bit scalar representation:

-- 
