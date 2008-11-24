Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbYKXOqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbYKXOqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 09:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYKXOqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 09:46:33 -0500
Received: from styx.suse.cz ([82.119.242.94]:46398 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752657AbYKXOqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 09:46:32 -0500
Subject: Fix clock_gettime with CLOCK_PROCESS_CPUTIME_ID
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Organization: SUSE LINUX
Date: Mon, 24 Nov 2008 15:46:31 +0100
Message-Id: <1227537991.20064.6.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since CLOCK_PROCESS_CPUTIME_ID is in fact translated to -6, the switch
statement in cpu_clock_sample_group() must first mask off the irrelevant
bits, similar to cpu_clock_sample().

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

--
 posix-cpu-timers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -311,7 +311,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 	struct task_cputime cputime;
 
 	thread_group_cputime(p, &cputime);
-	switch (which_clock) {
+	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:


