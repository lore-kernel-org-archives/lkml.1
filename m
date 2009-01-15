Return-Path: <linux-kernel-owner+w=401wt.eu-S934528AbZAOWJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528AbZAOWJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933554AbZAOWCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:07 -0500
Received: from kroah.org ([198.145.64.141]:38188 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765116AbZAOWCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:04 -0500
Date: Thu, 15 Jan 2009 13:59:24 -0800
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
       alan@lxorguk.ukuu.org.uk,
       Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [patch 15/85] USB: isp1760: use a specific PLX bridge instead of
	any bdridge
Message-ID: <20090115215924.GP17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-isp1760-use-a-specific-plx-bridge-instead-of-any-bdridge.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 6c0735687d37e25a65866823881bcbf39a6a023f upstream.

this driver can't handle (of course) any brdige class devices. So we
now are just active on one specific bridge which should be only the
isp1761 chip behind a PLX bridge.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Karl Bongers <kblists08@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/isp1760-if.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/usb/host/isp1760-if.c
+++ b/drivers/usb/host/isp1760-if.c
@@ -267,12 +267,16 @@ static void isp1761_pci_shutdown(struct 
 	printk(KERN_ERR "ips1761_pci_shutdown\n");
 }
 
-static const struct pci_device_id isp1760_plx [] = { {
-	/* handle any USB 2.0 EHCI controller */
-	PCI_DEVICE_CLASS(((PCI_CLASS_BRIDGE_OTHER << 8) | (0x06 << 16)), ~0),
-		.driver_data = 0,
-},
-{ /* end: all zeroes */ }
+static const struct pci_device_id isp1760_plx [] = {
+	{
+		.class          = PCI_CLASS_BRIDGE_OTHER << 8,
+		.class_mask     = ~0,
+		.vendor		= PCI_VENDOR_ID_PLX,
+		.device		= 0x5406,
+		.subvendor	= PCI_VENDOR_ID_PLX,
+		.subdevice	= 0x9054,
+	},
+	{ }
 };
 MODULE_DEVICE_TABLE(pci, isp1760_plx);
 

