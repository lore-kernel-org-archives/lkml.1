Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbZBNBai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbZBNBai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761932AbZBNBQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:09 -0500
Received: from kroah.org ([198.145.64.141]:50207 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764102AbZBNBQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:05 -0500
Date: Fri, 13 Feb 2009 17:12:33 -0800
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
       alan@lxorguk.ukuu.org.uk, Jiri Slaby <jirislaby@gmail.com>
Subject: [patch 07/48] parport: parport_serial, dont bind netmos ibm 0299
Message-ID: <20090214011233.GH17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="parport-parport_serial-don-t-bind-netmos-ibm-0299.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 3abdbf90a3ffb006108c831c56b092e35483b6ec upstream.

Since netmos 9835 with subids 0x1014(IBM):0x0299 is now bound with
serial/8250_pci, because it has no parallel ports and subdevice id isn't
in the expected form, return -ENODEV from probe function.

This is performed in netmos preinit_hook.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/parport/parport_serial.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -64,6 +64,11 @@ struct parport_pc_pci {
 
 static int __devinit netmos_parallel_init(struct pci_dev *dev, struct parport_pc_pci *card, int autoirq, int autodma)
 {
+	/* the rule described below doesn't hold for this device */
+	if (dev->device == PCI_DEVICE_ID_NETMOS_9835 &&
+			dev->subsystem_vendor == PCI_VENDOR_ID_IBM &&
+			dev->subsystem_device == 0x0299)
+		return -ENODEV;
 	/*
 	 * Netmos uses the subdevice ID to indicate the number of parallel
 	 * and serial ports.  The form is 0x00PS, where <P> is the number of

