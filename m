Return-Path: <linux-kernel-owner+w=401wt.eu-S1760286AbZCNAjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286AbZCNAjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbZCNATd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:33 -0400
Received: from kroah.org ([198.145.64.141]:34804 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751615AbZCNATU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:48 2009
Message-Id: <20090314000747.945349883@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:07 -0700
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
Subject: [patch 59/96] sdhci: fix led naming
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=sdhci-fix-led-naming.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1690,7 +1690,9 @@ int sdhci_add_host(struct sdhci_host *ho
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
@@ -220,6 +220,7 @@ struct sdhci_host {
 
 #ifdef CONFIG_LEDS_CLASS
 	struct led_classdev	led;		/* LED control */
+	char   led_name[32];
 #endif
 
 	spinlock_t		lock;		/* Mutex */


