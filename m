Return-Path: <linux-kernel-owner+w=401wt.eu-S935912AbXEUT5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935912AbXEUT5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934216AbXEUTdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:33:13 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:54421 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765637AbXEUTdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:33:11 -0400
Message-Id: <20070521191744.685169000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:58 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Andi Kleen <ak@suse.de>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <dada1@cosmosbay.com>,
       dang@gentoo.org, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 46/69] [PATCH] x86_64 : Fix vgettimeofday()
Content-Disposition: inline; filename=x86_64-fix-vgettimeofday.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Eric Dumazet <dada1@cosmosbay.com>

vgettimeofday() may return some bad timeval values, (tv_usec = 1000000), because of a wrong compare.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86_64/kernel/vsyscall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.1.orig/arch/x86_64/kernel/vsyscall.c
+++ linux-2.6.21.1/arch/x86_64/kernel/vsyscall.c
@@ -132,7 +132,7 @@ static __always_inline void do_vgettimeo
 
 	/* convert to usecs and add to timespec: */
 	tv->tv_usec += nsec_delta / NSEC_PER_USEC;
-	while (tv->tv_usec > USEC_PER_SEC) {
+	while (tv->tv_usec >= USEC_PER_SEC) {
 		tv->tv_sec += 1;
 		tv->tv_usec -= USEC_PER_SEC;
 	}

-- 
