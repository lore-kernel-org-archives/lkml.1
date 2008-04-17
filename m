Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbYDQBRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbYDQBRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759618AbYDQBH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:57 -0400
Received: from sous-sol.org ([216.99.217.87]:58892 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759601AbYDQBH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:56 -0400
Message-Id: <20080417010359.041593305@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:19 -0700
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
       Mike Pagano <mpagano@gentoo.org>, kernel@gentoo.org, agx@sigxcpu.org,
       Paul Mackerras <paulus@samba.org>
Subject: POWERPC: Fix build of modular drivers/macintosh/apm_emu.c
Content-Disposition: inline; filename=powerpc-fix-build-of-modular-drivers-macintosh-apm_emu.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Guido Guenther <agx@sigxcpu.org>

upstream commit: 620a245978d007279bc5c7c64e15f5f63af9af98

Currently, if drivers/macintosh/apm_emu is a module and the config
doesn't have CONFIG_SUSPEND we get:

ERROR: "pmu_batteries" [drivers/macintosh/apm_emu.ko] undefined!
ERROR: "pmu_battery_count" [drivers/macintosh/apm_emu.ko] undefined!
ERROR: "pmu_power_flags" [drivers/macintosh/apm_emu.ko] undefined!

on PPC32.  The variables aren't wrapped in '#if defined(CONFIG_SUSPEND)'
so we probably shouldn't wrap the exports either.  This removes the
CONFIG_SUSPEND part of the export, which fixes compilation on ppc32.

Signed-off-by: Guido Guenther <agx@sigxcpu.org>
Signed-off-by: Paul Mackerras <paulus@samba.org>

mpagano@gentoo.org notes:

The details can be found at http://bugs.gentoo.org/show_bug.cgi?id=217629. 

Cc: Mike Pagano <mpagano@gentoo.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/macintosh/via-pmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -2842,7 +2842,7 @@ EXPORT_SYMBOL(pmu_wait_complete);
 EXPORT_SYMBOL(pmu_suspend);
 EXPORT_SYMBOL(pmu_resume);
 EXPORT_SYMBOL(pmu_unlock);
-#if defined(CONFIG_PM_SLEEP) && defined(CONFIG_PPC32)
+#if defined(CONFIG_PPC32)
 EXPORT_SYMBOL(pmu_enable_irled);
 EXPORT_SYMBOL(pmu_battery_count);
 EXPORT_SYMBOL(pmu_batteries);

-- 
