Return-Path: <linux-kernel-owner+w=401wt.eu-S1751775AbZHXHBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbZHXHBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZHXHBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:01:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41764 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbZHXHBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:01:22 -0400
Date: Mon, 24 Aug 2009 17:01:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: manual merge of the tip tree with the s390 tree
Message-Id: <20090824170119.57cf4f59.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/s390/kernel/time.c between commit
6342887c12d79c5a2c8c1de5be6f483e16a2acdd ("[S390] introduce
get_clock_monotonic") from the s390 tree and commit
23970e389e9cee43c4b41023935e1417271708b2 ("timekeeping: Introduce
read_boot_clock") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/s390/kernel/time.c
index 6f0d86f,6bff1a1..0000000
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@@ -183,12 -182,14 +183,14 @@@ static void timing_alert_interrupt(__u1
  static void etr_reset(void);
  static void stp_reset(void);
  
- unsigned long read_persistent_clock(void)
+ void read_persistent_clock(struct timespec *ts)
  {
- 	struct timespec ts;
+ 	tod_to_timeval(get_clock() - TOD_UNIX_EPOCH, ts);
+ }
  
- 	tod_to_timeval(get_clock() - TOD_UNIX_EPOCH, &ts);
- 	return ts.tv_sec;
+ void read_boot_clock(struct timespec *ts)
+ {
 -	tod_to_timeval(sched_clock_base_cc - TOD_UNIX_EPOCH, ts);
++	tod_to_timeval(sched_clock_base - TOD_UNIX_EPOCH, ts);
  }
  
  static cycle_t read_tod_clock(struct clocksource *cs)
