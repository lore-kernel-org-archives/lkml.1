Return-Path: <linux-kernel-owner+w=401wt.eu-S937656AbXFHHVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937656AbXFHHVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936377AbXFHHRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:17:17 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33167 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937860AbXFHHRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:17:15 -0400
Message-Id: <20070608071541.946305000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>,
       "Jung-Ik (John) Lee" <jilee@google.com>, Len Brown <lenb@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 12/32] acpi-thermal: fix mod_timer() interval
Content-Disposition: inline; filename=acpi-thermal-fix-mod_timer-interval.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From:  Andrew Morton <akpm@linux-foundation.org>

Use relative time, not absolute.  Discovered by Jung-Ik (John) Lee
<jilee@google.com>.

Cc: Jung-Ik (John) Lee <jilee@google.com>
Acked-by: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/acpi/thermal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.20.13.orig/drivers/acpi/thermal.c
+++ linux-2.6.20.13/drivers/acpi/thermal.c
@@ -758,7 +758,8 @@ static void acpi_thermal_check(void *dat
 			del_timer(&(tz->timer));
 	} else {
 		if (timer_pending(&(tz->timer)))
-			mod_timer(&(tz->timer), (HZ * sleep_time) / 1000);
+			mod_timer(&(tz->timer),
+					jiffies + (HZ * sleep_time) / 1000);
 		else {
 			tz->timer.data = (unsigned long)tz;
 			tz->timer.function = acpi_thermal_run;

-- 
