Return-Path: <linux-kernel-owner+w=401wt.eu-S932345Ab0A2JeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab0A2JeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932333Ab0A2JeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:34:10 -0500
Received: from hera.kernel.org ([140.211.167.34]:36807 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329Ab0A2JeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:34:06 -0500
Date: Fri, 29 Jan 2010 09:33:33 GMT
From: tip-bot for john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de
In-Reply-To: <1264719761.3437.47.camel@localhost.localdomain>
References: <1264719761.3437.47.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] ntp: Make time_esterror and time_maxerror static
Message-ID: <tip-1f5b8f8a2031ae9507eb67743cad4d424739bfff@git.kernel.org>
Git-Commit-ID: 1f5b8f8a2031ae9507eb67743cad4d424739bfff
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:33:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f5b8f8a2031ae9507eb67743cad4d424739bfff
Gitweb:     http://git.kernel.org/tip/1f5b8f8a2031ae9507eb67743cad4d424739bfff
Author:     john stultz <johnstul@us.ibm.com>
AuthorDate: Thu, 28 Jan 2010 15:02:41 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 29 Jan 2010 10:15:19 +0100

ntp: Make time_esterror and time_maxerror static

Make time_esterror and time_maxerror static as no one uses them
outside of ntp.c
    
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: richard@rsk.demon.co.uk
LKML-Reference: <1264719761.3437.47.camel@localhost.localdomain>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/timex.h |    3 ---
 kernel/time/ntp.c     |    4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

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
