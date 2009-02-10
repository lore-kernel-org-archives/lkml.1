Return-Path: <linux-kernel-owner+w=401wt.eu-S1757415AbZBJTRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbZBJTRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZBJTEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:11 -0500
Received: from kroah.org ([198.145.64.141]:54111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755909AbZBJTEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:09 -0500
Date: Tue, 10 Feb 2009 11:01:05 -0800
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
       alan@lxorguk.ukuu.org.uk, Niels de Vos <niels.devos@wincor-nixdorf.com>,
       Alan Cox <alan@redhat.com>
Subject: [patch 39/53] serial: set correct baud_base for Oxford
	Semiconductor Ltd EXSYS EX-41092 Dual 16950 Serial adapter
Message-ID: <20090210190105.GN14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="serial-set-correct-baud_base-for-oxford-semiconductor-ltd-exsys-ex-41092-dual-16950-serial-adapter.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Niels de Vos <niels.devos@wincor-nixdorf.com>

commit 39aced68d664291db3324d0fcf0985ab5626aac2 upstream.

The PCI-card identified as "Oxford Semiconductor Ltd EXSYS EX-41092 Dual
16950 Serial adapter" is only usable with other devices (i.e. not the same
card) after doing a "setserial /dev/ttyS<n> baud_base 115200".  This
baud_base should be default for this card.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250_pci.c |    3 +++
 include/linux/pci_ids.h   |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -2375,6 +2375,9 @@ static struct pci_device_id serial_pci_t
 		 * For now just used the hex ID 0x950a.
 		 */
 	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
+		PCI_SUBVENDOR_ID_SIIG, PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL, 0, 0,
+		pbn_b0_2_115200 },
+	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_2_1130000 },
 	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI954,
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1770,6 +1770,7 @@
 #define PCI_DEVICE_ID_SIIG_8S_20x_650	0x2081
 #define PCI_DEVICE_ID_SIIG_8S_20x_850	0x2082
 #define PCI_SUBDEVICE_ID_SIIG_QUARTET_SERIAL	0x2050
+#define PCI_SUBDEVICE_ID_SIIG_DUAL_SERIAL	0x2530
 
 #define PCI_VENDOR_ID_RADISYS		0x1331
 

