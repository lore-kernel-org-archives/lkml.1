Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYLWBrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYLWBrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 20:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbYLWBqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 20:46:52 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:57546 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbYLWBqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 20:46:52 -0500
Date: Tue, 23 Dec 2008 01:47:46 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Magnus Damm <damm@igel.co.jp>, linux-kernel@vger.kernel.org
Subject: [PATCH mmotm] clocksource pass clocksource powerpc fix
Message-ID: <Pine.LNX.4.64.0812230141370.23109@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix powerpc build of clocksource pass clocksource mods:

arch/powerpc/kernel/time.c:88: warning: initialization from incompatible pointer type
arch/powerpc/kernel/time.c:99: warning: initialization from incompatible pointer type
arch/powerpc/kernel/time.c:770: error: conflicting types for 'rtc_read'
arch/powerpc/kernel/time.c:80: error: previous declaration of 'rtc_read' was here
arch/powerpc/kernel/time.c:775: error: conflicting types for 'timebase_read'
arch/powerpc/kernel/time.c:91: error: previous declaration of 'timebase_read' was here
make[1]: *** [arch/powerpc/kernel/time.o] Error 1
make: *** [arch/powerpc/kernel] Error 2

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Follow clocksource-pass-clocksource-to-read-callback-v2.patch

 arch/powerpc/kernel/time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm/arch/powerpc/kernel/time.c	2008-12-16 18:05:13.000000000 +0000
+++ fixed/arch/powerpc/kernel/time.c	2008-12-16 19:19:51.000000000 +0000
@@ -77,7 +77,7 @@
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
 
-static cycle_t rtc_read(void);
+static cycle_t rtc_read(struct clocksource *);
 static struct clocksource clocksource_rtc = {
 	.name         = "rtc",
 	.rating       = 400,
@@ -88,7 +88,7 @@ static struct clocksource clocksource_rt
 	.read         = rtc_read,
 };
 
-static cycle_t timebase_read(void);
+static cycle_t timebase_read(struct clocksource *);
 static struct clocksource clocksource_timebase = {
 	.name         = "timebase",
 	.rating       = 400,
