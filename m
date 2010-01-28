Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610Ab0A1XC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0A1XC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539Ab0A1XC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:02:58 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:32880 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755468Ab0A1XC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:02:58 -0500
Subject: [PATCH]  ntp: Make time_esterror and time_maxerror static
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, richard@rsk.demon.co.uk,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 15:02:41 -0800
Message-ID: <1264719761.3437.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspired by Richard's earlier email, I noticed the ntp.c has a few
global values that could be static. This trivial patch cleans that up.

thanks
-john

    
Make time_esterror and time_maxerror static as no one uses them outside
of ntp.c
    
Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/include/linux/timex.h b/include/linux/timex.h
index 94f8fae..7a082b3 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -238,9 +238,6 @@ extern int tickadj;			/* amount of adjustment per tick */
  * phase-lock loop variables
  */
 extern int time_status;		/* clock synchronization status bits */
-extern long time_maxerror;	/* maximum error */
-extern long time_esterror;	/* estimated error */
-
 extern long time_adjust;	/* The amount of adjtime left */
 
 extern void ntp_init(void);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 4800f93..74b1b37 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -58,10 +58,10 @@ static s64			time_offset;
 static long			time_constant = 2;
 
 /* maximum error (usecs):						*/
-long				time_maxerror = NTP_PHASE_LIMIT;
+static long			time_maxerror = NTP_PHASE_LIMIT;
 
 /* estimated error (usecs):						*/
-long				time_esterror = NTP_PHASE_LIMIT;
+static long			time_esterror = NTP_PHASE_LIMIT;
 
 /* frequency offset (scaled nsecs/secs):				*/
 static s64			time_freq;


