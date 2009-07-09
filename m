Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbZGISeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbZGISeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 14:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbZGISeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 14:34:12 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:55665 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbZGISeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 14:34:11 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAPfUVUpR9Rz0/2dsb2JhbADSdwmCKoFVBYE6
Date: Thu, 9 Jul 2009 20:34:05 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>,
       Jiri Slaby <jirislaby@gmail.com>, Raphael Assenat <raph@8d.com>,
       Slobodan =?utf-8?B?VG9tacSH?= <stomic@gmail.com>
Subject: [WATCHDOG] v2.6.31-rc patches - Part 4: fixes and small changes
Message-ID: <20090709183405.GR23797@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/bcm47xx_wdt.c  |    2 +-
 drivers/watchdog/sa1100_wdt.c   |    5 +++--
 drivers/watchdog/w83627hf_wdt.c |    5 +++++
 drivers/watchdog/w83697ug_wdt.c |    4 +++-
 4 files changed, 12 insertions(+), 4 deletions(-)

with these Changes:

Author: Slobodan Tomić <stomic@gmail.com>
Date:   Sun Jun 28 21:20:36 2009 +0200

    [WATCHDOG] w83627hf_wdt.c: add support for the W83627EHF support
    
    Add support for the W83627EHF/EF and W83627EHG/EG chipsets.
    
    Signed-off-by: Slobodan Tomić <stomic@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Raphael Assenat <raph@8d.com>
Date:   Mon Jun 29 13:56:52 2009 -0400

    [WATCHDOG] SA1100 watchdog maximum timeout
    
    This patch replaces the hardcoded 255 seconds limit for a real limit based on
    oscr_freq.
    
    Also, the 'firmware_version' field is changed to '1' to allow the user
    space application to easily detect that this driver supports a higher
    maximum timeout.
    
    Signed-off-by: Raphael Assenat <raph@8D.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Mon Jun 29 18:00:39 2009 +0200

    [WATCHDOG] w83697ug, fix lock imbalance
    
    Don't forget to unlock io_lock when w83697ug_select_wd_register fails in
    wdt_ctrl.
    
    Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Joe Perches <joe@perches.com>
Date:   Sun Jun 28 09:26:57 2009 -0700

    [WATCHDOG] drivers/watchdog/bcm47xx_wdt.c: Remove unnecessary semicolons
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index 5c7011c..751c003 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -161,7 +161,7 @@ static long bcm47xx_wdt_ioctl(struct file *file,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	int new_value, retval = -EINVAL;;
+	int new_value, retval = -EINVAL;
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index ee1caae..0162454 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -38,7 +38,7 @@
 
 static unsigned long oscr_freq;
 static unsigned long sa1100wdt_users;
-static int pre_margin;
+static unsigned int pre_margin;
 static int boot_status;
 
 /*
@@ -84,6 +84,7 @@ static const struct watchdog_info ident = {
 	.options	= WDIOF_CARDRESET | WDIOF_SETTIMEOUT
 				| WDIOF_KEEPALIVEPING,
 	.identity	= "SA1100/PXA255 Watchdog",
+	.firmware_version	= 1,
 };
 
 static long sa1100dog_ioctl(struct file *file, unsigned int cmd,
@@ -118,7 +119,7 @@ static long sa1100dog_ioctl(struct file *file, unsigned int cmd,
 		if (ret)
 			break;
 
-		if (time <= 0 || time > 255) {
+		if (time <= 0 || (oscr_freq * (long long)time >= 0xffffffff)) {
 			ret = -EINVAL;
 			break;
 		}
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 916890a..f201acc 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -89,6 +89,11 @@ static void w83627hf_select_wd_register(void)
 		c = ((inb_p(WDT_EFDR) & 0xf7) | 0x04); /* select WDT0 */
 		outb_p(0x2b, WDT_EFER);
 		outb_p(c, WDT_EFDR);	/* set GPIO3 to WDT0 */
+	} else if (c == 0x88) {	/* W83627EHF */
+		outb_p(0x2d, WDT_EFER); /* select GPIO5 */
+		c = inb_p(WDT_EFDR) & ~0x01; /* PIN77 -> WDT0# */
+		outb_p(0x2d, WDT_EFER);
+		outb_p(c, WDT_EFDR); /* set GPIO5 to WDT0 */
 	}
 
 	outb_p(0x07, WDT_EFER); /* point to logical device number reg */
diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
index 883b5f7..a6c12de 100644
--- a/drivers/watchdog/w83697ug_wdt.c
+++ b/drivers/watchdog/w83697ug_wdt.c
@@ -149,8 +149,10 @@ static void wdt_ctrl(int timeout)
 {
 	spin_lock(&io_lock);
 
-	if (w83697ug_select_wd_register() < 0)
+	if (w83697ug_select_wd_register() < 0) {
+		spin_unlock(&io_lock);
 		return;
+	}
 
 	outb_p(0xF4, WDT_EFER);    /* Select CRF4 */
 	outb_p(timeout, WDT_EFDR); /* Write Timeout counter to CRF4 */
