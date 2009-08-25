Return-Path: <linux-kernel-owner+w=401wt.eu-S1754258AbZHYHN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbZHYHN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZHYHN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:13:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:40408 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbZHYHNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:13:53 -0400
Date: Tue, 25 Aug 2009 07:13:27 GMT
From: tip-bot for Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, lethal@linux-sh.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, tglx@linutronix.de, lethal@linux-sh.org,
       mingo@elte.hu
In-Reply-To: <20090824223239.GB20832@linux-sh.org>
References: <20090824223239.GB20832@linux-sh.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timekeeping: Fix up read_persistent_clock() breakage on sh
Message-ID: <tip-0ceb4c3e3f1ccaf121851e33c3ea269b8ad0f219@git.kernel.org>
Git-Commit-ID: 0ceb4c3e3f1ccaf121851e33c3ea269b8ad0f219
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 25 Aug 2009 07:13:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ceb4c3e3f1ccaf121851e33c3ea269b8ad0f219
Gitweb:     http://git.kernel.org/tip/0ceb4c3e3f1ccaf121851e33c3ea269b8ad0f219
Author:     Paul Mundt <lethal@linux-sh.org>
AuthorDate: Tue, 25 Aug 2009 07:32:39 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 25 Aug 2009 08:46:16 +0200

timekeeping: Fix up read_persistent_clock() breakage on sh

The recent commit "timekeeping: Increase granularity of
read_persistent_clock()" introduced read_persistent_clock()
rework which inadvertently broke the sh conversion:

	arch/sh/kernel/time.c:45: error: passing argument 1 of 'rtc_sh_get_time' from incompatible pointer type
	distcc[13470] ERROR: compile arch/sh/kernel/time.c on sprygo/32 failed
	make[2]: *** [arch/sh/kernel/time.o] Error 1

This trivial fix gets it working again.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
LKML-Reference: <20090824223239.GB20832@linux-sh.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/sh/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/kernel/time.c b/arch/sh/kernel/time.c
index 3f4706a..0e0e858 100644
--- a/arch/sh/kernel/time.c
+++ b/arch/sh/kernel/time.c
@@ -41,7 +41,7 @@ int (*rtc_sh_set_time)(const time_t) = null_rtc_set_time;
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
 void read_persistent_clock(struct timespec *ts)
 {
-	rtc_sh_get_time(&ts);
+	rtc_sh_get_time(ts);
 }
 
 int update_persistent_clock(struct timespec now)
