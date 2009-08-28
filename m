Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbZH1AGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbZH1AGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 20:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZH1AGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 20:06:11 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54874 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbZH1AGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 20:06:10 -0400
Subject: [PATCH] You say MOD_NANO, I say ADJ_NANO
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@tglx.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Miroslav Lichvar <mlichvar@redhat.com>, hmurray@megapathdsl.net,
       Ulrich Drepper <drepper@redhat.com>,
       Michael Tatarinov <kukabu@gmail.com>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 17:04:42 -0700
Message-Id: <1251417882.7905.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


The tumultuous NTP and Linux relationship has hit another snag: Ends up
NTPd still uses the "xntp 3.4 compatability names" and when the STA_NANO
value was added (along with ADJ_NANO), NTPd expected MOD_NANO to be
added and has apparently hit some build errors.

Report to ntp hackers:
https://lists.ntp.org/pipermail/hackers/2009-August/004455.html

Related Bugs:
https://support.ntp.org/bugs/show_bug.cgi?id=1219
https://bugzilla.redhat.com/show_bug.cgi?id=505566

So in an effort to make peace, here's a patch to help get things
building again. I also have updated the comment to make sure folks don't
think the MOD_* values are just legacy constants.

Of course, NTPd really uses the glibc-headers, so those will need to be
similarly updated before things are working again (the RH bug above
should probably cover that).

Thanks to Michael Tatarinov and Hal Murray for finding and reporting the
issue!

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>

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



