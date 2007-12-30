Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbXL3QsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbXL3QsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 11:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbXL3Qr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 11:47:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40659 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXL3Qr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 11:47:57 -0500
Date: Sun, 30 Dec 2007 17:45:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler updates
Message-ID: <20071230164545.GA13459@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

Warning fix for sparc64 - no code changed. Thanks!

	Ingo

------------------>
Ingo Molnar (1):
      sched: fix gcc warnings

 sched_debug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index d30467b..80fbbfc 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -31,9 +31,9 @@
 /*
  * Ease the printing of nsec fields:
  */
-static long long nsec_high(long long nsec)
+static long long nsec_high(unsigned long long nsec)
 {
-	if (nsec < 0) {
+	if ((long long)nsec < 0) {
 		nsec = -nsec;
 		do_div(nsec, 1000000);
 		return -nsec;
@@ -43,9 +43,9 @@ static long long nsec_high(long long nsec)
 	return nsec;
 }
 
-static unsigned long nsec_low(long long nsec)
+static unsigned long nsec_low(unsigned long long nsec)
 {
-	if (nsec < 0)
+	if ((long long)nsec < 0)
 		nsec = -nsec;
 
 	return do_div(nsec, 1000000);

