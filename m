Return-Path: <linux-kernel-owner+w=401wt.eu-S1763859AbZCNBhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763859AbZCNBhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZCNBUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:51 -0400
Received: from kroah.org ([198.145.64.141]:35226 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753324AbZCNBU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:38 2009
Message-Id: <20090314011038.351676800@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:24 -0700
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
       alan@lxorguk.ukuu.org.uk, Helmut Schaa <helmut.schaa@googlemail.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 047/114] sdhci: fix led naming
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=sdhci-fix-led-naming.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Helmut Schaa <helmut.schaa@googlemail.com>

commit 5dbace0c9ba110c1a3810a89fa6bf12b7574b5a3 upstream.

Fix the led device naming for the sdhci driver.

The led class documentation defines the led name to have the
form "devicename:colour:function" while not applicable sections
should be left blank.

To comply with the documentation the led device name is changed
from "mmc*" to "mmc*::".

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/sdhci.c |    4 +++-
 drivers/mmc/host/sdhci.h |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1718,7 +1718,9 @@ int sdhci_add_host(struct sdhci_host *ho
 #endif
 
 #ifdef CONFIG_LEDS_CLASS
-	host->led.name = mmc_hostname(mmc);
+	snprintf(host->led_name, sizeof(host->led_name),
+		"%s::", mmc_hostname(mmc));
+	host->led.name = host->led_name;
 	host->led.brightness = LED_OFF;
 	host->led.default_trigger = mmc_hostname(mmc);
 	host->led.brightness_set = sdhci_led_control;
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -222,6 +222,7 @@ struct sdhci_host {
 
 #ifdef CONFIG_LEDS_CLASS
 	struct led_classdev	led;		/* LED control */
+	char   led_name[32];
 #endif
 
 	spinlock_t		lock;		/* Mutex */


