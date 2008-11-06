Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYKFJYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYKFJYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 04:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbYKFJYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 04:24:35 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:8385 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753507AbYKFJYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 04:24:33 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEAPdGEklR9Rjf/2dsb2JhbACBdcgXg1U
Date: Thu, 6 Nov 2008 10:24:30 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Victor <avictor.za@gmail.com>
Subject: [WATCHDOG] v2.6.28-rc4 watchdog patches
Message-ID: <20081106092430.GE2690@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

attached a header fix and some extra support for the sam9 watchdog device.

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig        |    8 ++++----
 drivers/watchdog/at91sam9_wdt.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

with these Changes:

Author: Andrew Victor <linux@maxim.org.za>
Date:   Wed Nov 5 22:36:35 2008 +0200

    [WATCHDOG] SAM9 watchdog - supported on all SAM9 and CAP9 processors
    
    The SAM9 watchdog driver is usable on the whole family of AT91SAM9 and
    CAP9 processors.
    Update the configuration to indicate this and allow the driver to be selected.
    
    Signed-off-by: Andrew Victor <linux@maxim.org.za>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Andrew Victor <linux@maxim.org.za>
Date:   Wed Nov 5 22:18:41 2008 +0200

    [WATCHDOG] SAM9 watchdog - update for moved headers
    
    The architecture header files were recently moved from
    include/asm-arm/mach-at91/ to arch/arm/mach-at91/include/mach/.
    The SAM9 watchdog driver still includes a header from the old location.
    
    Signed-off-by: Andrew Victor <linux@maxim.org.za>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 1a22fe7..4fd3fa5 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -67,11 +67,11 @@ config AT91RM9200_WATCHDOG
 	  system when the timeout is reached.
 
 config AT91SAM9X_WATCHDOG
-	tristate "AT91SAM9X watchdog"
-	depends on WATCHDOG && (ARCH_AT91SAM9260 || ARCH_AT91SAM9261)
+	tristate "AT91SAM9X / AT91CAP9 watchdog"
+	depends on ARCH_AT91 && !ARCH_AT91RM9200
 	help
-	  Watchdog timer embedded into AT91SAM9X chips. This will reboot your
-	  system when the timeout is reached.
+	  Watchdog timer embedded into AT91SAM9X and AT91CAP9 chips. This will
+	  reboot your system when the timeout is reached.
 
 config 21285_WATCHDOG
 	tristate "DC21285 watchdog"
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index b4babfc..b1da287 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -30,7 +30,7 @@
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
 
-#include <asm/arch/at91_wdt.h>
+#include <mach/at91_wdt.h>
 
 #define DRV_NAME "AT91SAM9 Watchdog"
 
