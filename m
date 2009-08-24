Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbZHXWcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbZHXWcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZHXWcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:32:39 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:32965 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbZHXWcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:32:39 -0400
Date: Tue, 25 Aug 2009 07:32:39 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip] timekeeping: Fix up read_persistent_clock() breakage on sh.
Message-ID: <20090824223239.GB20832@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent commit "timekeeping: Increase granularity of
read_persistent_clock()" introduced read_persistent_clock() rework which
inadvertently broke the sh conversion:

	arch/sh/kernel/time.c:45: error: passing argument 1 of 'rtc_sh_get_time' from incompatible pointer type
	distcc[13470] ERROR: compile arch/sh/kernel/time.c on sprygo/32 failed
	make[2]: *** [arch/sh/kernel/time.o] Error 1

This trivial fix gets it working again.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>

---

 arch/sh/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
