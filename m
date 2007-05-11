Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbXEKTJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbXEKTJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbXEKTIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:08:55 -0400
Received: from outmx034.isp.belgacom.be ([195.238.6.171]:42336 "EHLO
	outmx034.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbXEKTIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:08:54 -0400
Date: Fri, 11 May 2007 21:10:12 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [WATCHDOG] iTCO_wdt.c - fix ACPIBASE
Message-ID: <20070511191012.GA3060@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/char/watchdog/iTCO_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri May 11 18:59:24 2007 +0000

    [WATCHDOG] iTCO_wdt.c - fix ACPI Base register
    
    The ACPI/PM base I/O address which is the base
    for the TCO registers is defined as bits [15:7]
    (highest bit is 31, lowest is 0)
    
    The code however only reads bits [14:7]. So
            base_address &= 0x00007f80;
    needs to be:
            base_address &= 0x0000ff80;
    
    This patch fixes this.
    
    Signed-off-by: Ate Wijma <ajwijma@hotmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/char/watchdog/iTCO_wdt.c b/drivers/char/watchdog/iTCO_wdt.c
index 3c9684c..eac4f9b 100644
--- a/drivers/char/watchdog/iTCO_wdt.c
+++ b/drivers/char/watchdog/iTCO_wdt.c
@@ -571,7 +571,7 @@ static int iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device_id *ent,
 	 *      ACPIBASE is bits [15:7] from 0x40-0x43
 	 */
 	pci_read_config_dword(pdev, 0x40, &base_address);
-	base_address &= 0x00007f80;
+	base_address &= 0x0000ff80;
 	if (base_address == 0x00000000) {
 		/* Something's wrong here, ACPIBASE has to be set */
 		printk(KERN_ERR PFX "failed to get TCOBASE address\n");
