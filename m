Return-Path: <linux-kernel-owner+w=401wt.eu-S1160998AbXCNUmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160998AbXCNUmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161041AbXCNUmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:42:37 -0400
Received: from outmx039.isp.belgacom.be ([195.238.6.176]:40570 "EHLO
	outmx039.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1160998AbXCNUmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:42:36 -0400
Date: Wed, 14 Mar 2007 21:43:42 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [WATCHDOG] i8xx_tco - mark for removal patch
Message-ID: <20070314204342.GA2987@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I'm planning to remove the i8xx_tco watchdog driver
since we now have the iTCO_wdt driver that has a broader scope.

Therefor I created a small patch (that adds the driver to the
feature-removal-schedule list and defaults CONFIG_I8XX_TCO to n).
There is no impact at any of the drivers.

So can you please pull from 'master' branch of
        git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
        master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 Documentation/feature-removal-schedule.txt |    8 ++++++++
 drivers/char/watchdog/Kconfig              |    1 +
 2 files changed, 9 insertions(+)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Mar 11 12:59:47 2007 +0000

    [WATCHDOG] i8xx TCO driver - mark for removal
    
    Mark the i8xx TCO driver for removal.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
        http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c3b1430..0bc8b0b 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -316,3 +316,11 @@ Why:	The option/code is
 Who:	Johannes Berg <johannes@sipsolutions.net>
 
 ---------------------------
+
+What:	i8xx_tco watchdog driver
+When:	in 2.6.22
+Why:	the i8xx_tco watchdog driver has been replaced by the iTCO_wdt
+	watchdog driver.
+Who:	Wim Van Sebroeck <wim@iguana.be>
+
+---------------------------
diff --git a/drivers/char/watchdog/Kconfig b/drivers/char/watchdog/Kconfig
index ea09d0c..e812aa1 100644
--- a/drivers/char/watchdog/Kconfig
+++ b/drivers/char/watchdog/Kconfig
@@ -301,6 +301,7 @@ config I6300ESB_WDT
 config I8XX_TCO
 	tristate "Intel i8xx TCO Timer/Watchdog"
 	depends on WATCHDOG && (X86 || IA64) && PCI
+	default n
 	---help---
 	  Hardware driver for the TCO timer built into the Intel 82801
 	  I/O Controller Hub family.  The TCO (Total Cost of Ownership)
