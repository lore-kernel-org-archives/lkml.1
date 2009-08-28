Return-Path: <linux-kernel-owner+w=401wt.eu-S1752741AbZH1M6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbZH1M6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZH1M6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:58:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:42498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbZH1M6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:58:04 -0400
Date: Fri, 28 Aug 2009 12:57:39 GMT
From: tip-bot for john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, mlichvar@redhat.com, drepper@redhat.com,
       tglx@linutronix.de, kukabu@gmail.com
Reply-To: drepper@redhat.com, mlichvar@redhat.com, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       tglx@linutronix.de, kukabu@gmail.com
In-Reply-To: <1251417882.7905.42.camel@localhost.localdomain>
References: <1251417882.7905.42.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/ntp] ntp: Provide compability defines (You say MOD_NANO, I say ADJ_NANO)
Message-ID: <tip-c95b4502ad7fe8f3b9954aec794b00ac0046ab3a@git.kernel.org>
Git-Commit-ID: c95b4502ad7fe8f3b9954aec794b00ac0046ab3a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 12:57:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c95b4502ad7fe8f3b9954aec794b00ac0046ab3a
Gitweb:     http://git.kernel.org/tip/c95b4502ad7fe8f3b9954aec794b00ac0046ab3a
Author:     john stultz <johnstul@us.ibm.com>
AuthorDate: Thu, 27 Aug 2009 17:04:42 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Aug 2009 14:53:24 +0200

ntp: Provide compability defines (You say MOD_NANO, I say ADJ_NANO)

MOD_NANO, ADJ_NANO, MOD_NANO, ADJ_NANO!
Lets call the whole thing off!
But oh! If we call the whole thing off,
Then we must part.
And oh! If we ever part,
Then that might break my heart^H^H^H^Hclock!
So, if you like MOD_NANO and I like ADJ_NANO,
I'll include MOD_NANO and give up ADJ_NANO (not really!).
For we know we need each other,
So we better call the calling off off.
Let's call the whole thing off!

The tumultuous NTP and Linux relationship has hit another snag: Ends
up NTPd still uses the "xntp 3.4 compatability names" and when the
STA_NANO value was added (along with ADJ_NANO), NTPd expected MOD_NANO
to be added and has apparently hit some build errors.

Report to ntp hackers:
https://lists.ntp.org/pipermail/hackers/2009-August/004455.html

Related Bugs:
https://support.ntp.org/bugs/show_bug.cgi?id=1219
https://bugzilla.redhat.com/show_bug.cgi?id=505566

So in an effort to make peace, here's a patch to help get things
building again. I also have updated the comment to make sure folks
don't think the MOD_* values are just legacy constants.

Of course, NTPd really uses the glibc-headers, so those will need to
be similarly updated before things are working again (the RH bug above
should probably cover that).

Thanks to Michael Tatarinov and Hal Murray for finding and reporting
the issue!

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: hmurray@megapathdsl.net
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Michael Tatarinov <kukabu@gmail.com>
LKML-Reference: <1251417882.7905.42.camel@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>



---
 include/linux/timex.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/timex.h b/include/linux/timex.h
index e6967d1..782ccd4 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -115,13 +115,16 @@ struct timex {
 #define ADJ_OFFSET_SS_READ	0xa001	/* read-only adjtime */
 #endif
 
-/* xntp 3.4 compatibility names */
+/* NTP userland likes the MOD_ prefix better */
 #define MOD_OFFSET	ADJ_OFFSET
 #define MOD_FREQUENCY	ADJ_FREQUENCY
 #define MOD_MAXERROR	ADJ_MAXERROR
 #define MOD_ESTERROR	ADJ_ESTERROR
 #define MOD_STATUS	ADJ_STATUS
 #define MOD_TIMECONST	ADJ_TIMECONST
+#define MOD_TAI	ADJ_TAI
+#define MOD_MICRO	ADJ_MICRO
+#define MOD_NANO	ADJ_NANO
 
 
 /*
