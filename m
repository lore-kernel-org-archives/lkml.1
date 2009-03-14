Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbZCNA1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbZCNA1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbZCNASu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:50 -0400
Received: from kroah.org ([198.145.64.141]:46871 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753173AbZCNASq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:46 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:42 2009
Message-Id: <20090314000742.835474392@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Phil Sutter <n0-1@freewrt.org>,
       Wim Van Sebroeck <wim@iguana.be>
Subject: [patch 26/96] WATCHDOG: rc32434_wdt: fix sections
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=watchdog-rc32434_wdt-fix-sections.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Phil Sutter <n0-1@freewrt.org>

commit d9a8798c4bab5ccd40e45e011f668099cfb3eb83 upstream.

Fix init and exit sections.

Signed-off-by: Phil Sutter <n0-1@freewrt.org>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/rc32434_wdt.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -33,7 +33,7 @@
 #include <asm/time.h>
 #include <asm/mach-rc32434/integ.h>
 
-#define VERSION "0.3"
+#define VERSION "0.4"
 
 static struct {
 	unsigned long inuse;
@@ -241,10 +241,10 @@ static struct miscdevice rc32434_wdt_mis
 	.fops	= &rc32434_wdt_fops,
 };
 
-static char banner[] = KERN_INFO KBUILD_MODNAME
+static char banner[] __devinitdata = KERN_INFO KBUILD_MODNAME
 		": Watchdog Timer version " VERSION ", timer margin: %d sec\n";
 
-static int rc32434_wdt_probe(struct platform_device *pdev)
+static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct resource *r;
@@ -279,7 +279,7 @@ unmap:
 	return ret;
 }
 
-static int rc32434_wdt_remove(struct platform_device *pdev)
+static int __devexit rc32434_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&rc32434_wdt_miscdev);
 	iounmap(wdt_reg);
@@ -288,8 +288,8 @@ static int rc32434_wdt_remove(struct pla
 
 static struct platform_driver rc32434_wdt = {
 	.probe	= rc32434_wdt_probe,
-	.remove = rc32434_wdt_remove,
-	.driver = {
+	.remove	= __devexit_p(rc32434_wdt_remove),
+	.driver	= {
 		.name = "rc32434_wdt",
 	}
 };


