Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbZLBNSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbZLBNSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZLBNSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:18:54 -0500
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:21462 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbZLBNSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:18:54 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFT4FUtR9cj9/2dsb2JhbADXRgqEJwQ
Date: Wed, 2 Dec 2009 14:18:59 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Florian Fainelli <florian@openwrt.org>
Subject: [WATCHDOG] v2.6.32-rc8 fix - rc32434_wdt.c: correct size for
	ioremap_nocache & modulestring
Message-ID: <20091202131859.GA21591@infomag.iguana.be>
References: <20091202101624.GP3772@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202101624.GP3772@infomag.iguana.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> Please pull from 'master' branch of
> 	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> or if master.kernel.org hasn't synced up yet:
> 	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> 
> This will update the following files:
> 
>  drivers/watchdog/rc32434_wdt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Florian had another fix for the rc32434_wdt.c driver.

So this update will consist of:

 drivers/watchdog/rc32434_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

with these Changes:

Author: Florian Fainelli <florian@openwrt.org>
Date:   Wed Dec 2 13:21:23 2009 +0100

    [PATCH] rc32434_wdt: fix compilation failure
    
    This patch fixes the compilation failure of
    rc32434 due to a bad module parameter description.
    
    Signed-off-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: H Hartley Sweeten <hartleys@visionengravers.com>
Date:   Tue Nov 24 21:06:26 2009 -0500

    [WATCHDOG] rc32434_wdt.c: use resource_size()
    
    The size value passed to ioremap_nocache() is not correct.
    Use resource_size() to get the correct value.
    
    Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
    Cc: Phil Sutter <n0-1@freewrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index f6cccc9..bf12d06 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -62,7 +62,7 @@ extern unsigned int idt_cpu_freq;
 static int timeout = WATCHDOG_TIMEOUT;
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout, "Watchdog timeout value, in seconds (default="
-		WATCHDOG_TIMEOUT ")");
+		__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
@@ -276,7 +276,7 @@ static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	wdt_reg = ioremap_nocache(r->start, r->end - r->start);
+	wdt_reg = ioremap_nocache(r->start, resource_size(r));
 	if (!wdt_reg) {
 		printk(KERN_ERR PFX "failed to remap I/O resources\n");
 		return -ENXIO;
