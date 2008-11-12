Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbYKLAdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbYKLAdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYKLA01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:27 -0500
Received: from kroah.org ([198.145.64.141]:42285 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752335AbYKLA0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:24 -0500
Date: Tue, 11 Nov 2008 16:23:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alok N Kataria <akataria@vmware.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 19/49] x86: dont use tsc_khz to calculate lpj if notsc is
	passed
Message-ID: <20081112002333.GT10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-don-t-use-tsc_khz-to-calculate-lpj-if-notsc-is-passed.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alok Kataria <akataria@vmware.com>

commit 70de9a97049e0ba79dc040868564408d5ce697f9 upstream

Impact: fix udelay when "notsc" boot parameter is passed

With notsc passed on commandline, tsc may not be used for
udelays, make sure that we do not use tsc_khz to calculate
the lpj value in such cases.

Reported-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/tsc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -639,10 +639,6 @@ void __init tsc_init(void)
 		cpu_khz = calibrate_cpu();
 #endif
 
-	lpj = ((u64)tsc_khz * 1000);
-	do_div(lpj, HZ);
-	lpj_fine = lpj;
-
 	printk("Detected %lu.%03lu MHz processor.\n",
 			(unsigned long)cpu_khz / 1000,
 			(unsigned long)cpu_khz % 1000);
@@ -662,6 +658,10 @@ void __init tsc_init(void)
 	/* now allow native_sched_clock() to use rdtsc */
 	tsc_disabled = 0;
 
+	lpj = ((u64)tsc_khz * 1000);
+	do_div(lpj, HZ);
+	lpj_fine = lpj;
+
 	use_tsc_delay();
 	/* Check and install the TSC clocksource */
 	dmi_check_system(bad_tsc_dmi_table);

-- 
