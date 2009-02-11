Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbZBKAfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbZBKAfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbZBKA21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:28:27 -0500
Received: from kroah.org ([198.145.64.141]:51194 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757654AbZBKA2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:28:23 -0500
Date: Tue, 10 Feb 2009 16:25:00 -0800
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
       alan@lxorguk.ukuu.org.uk, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@redhat.com>
Subject: [patch 22/56] 8250_pci: add support for netmos 9835 IBM devices
Message-ID: <20090211002500.GW14660@kroah.com>
References: <20090211001439.873435357@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="8250_pci-add-support-for-netmos-9835-ibm-devices.patch"
In-Reply-To: <20090211002328.GA14660@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 25cf9bc1fcb085daaeb82b09bab0fb3c40570887 upstream.

Most of netmos 9835 hardware is handled by parport-serial.  IBM introduces
a device which doesn't have any parallel ports and have screwed subdevice
PCI id (not corresponding to port numbers).

Handle this device (9710:9835 1014:0299) properly.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250_pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -599,6 +599,10 @@ static int pci_netmos_init(struct pci_de
 	/* subdevice 0x00PS means <P> parallel, <S> serial */
 	unsigned int num_serial = dev->subsystem_device & 0xf;
 
+	if (dev->subsystem_vendor == PCI_VENDOR_ID_IBM &&
+			dev->subsystem_device == 0x0299)
+		return 0;
+
 	if (num_serial == 0)
 		return -ENODEV;
 	return num_serial;
@@ -2846,6 +2850,10 @@ static struct pci_device_id serial_pci_t
 		0,
 		pbn_b0_8_115200 },
 
+	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
+		PCI_VENDOR_ID_IBM, 0x0299,
+		0, 0, pbn_b0_bt_2_115200 },
+
 	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL

