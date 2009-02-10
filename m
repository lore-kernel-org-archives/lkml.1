Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbZBJTSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbZBJTSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbZBJTEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:13 -0500
Received: from kroah.org ([198.145.64.141]:54111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755922AbZBJTEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:10 -0500
Date: Tue, 10 Feb 2009 11:01:08 -0800
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
       alan@lxorguk.ukuu.org.uk, Michael Bramer <grisu@deb-support.de>,
       Alan Cox <number6@the-village.bc.nu>
Subject: [patch 40/53] Add support for 8-port RS-232 MIC-3620 from advantech
Message-ID: <20090210190108.GO14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="add-support-for-8-port-rs-232-mic-3620-from-advantech.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Michael Bramer <michael@debsupport.de>

commit 78d70d48132ce4c678a95b771ffa1af4fb5a03ec upstream.

This Patch add the device information for the
MIC-3620 8-port RS-232 cPCI card from Advantech Co. Ltd.

Signed-off-by: Michael Bramer <grisu@deb-support.de>
Signed-off-by: Alan Cox <number6@the-village.bc.nu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250_pci.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -766,6 +766,8 @@ pci_default_setup(struct serial_private 
 #define PCI_SUBDEVICE_ID_OCTPRO422	0x0208
 #define PCI_SUBDEVICE_ID_POCTAL232	0x0308
 #define PCI_SUBDEVICE_ID_POCTAL422	0x0408
+#define PCI_VENDOR_ID_ADVANTECH		0x13fe
+#define PCI_DEVICE_ID_ADVANTECH_PCI3620	0x3620
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -2132,6 +2134,10 @@ static int pciserial_resume_one(struct p
 #endif
 
 static struct pci_device_id serial_pci_tbl[] = {
+	/* Advantech use PCI_DEVICE_ID_ADVANTECH_PCI3620 (0x3620) as 'PCI_SUBVENDOR_ID' */
+	{	PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI3620,
+		PCI_DEVICE_ID_ADVANTECH_PCI3620, 0x0001, 0, 0,
+		pbn_b2_8_921600 },
 	{	PCI_VENDOR_ID_V3, PCI_DEVICE_ID_V3_V960,
 		PCI_SUBVENDOR_ID_CONNECT_TECH,
 		PCI_SUBDEVICE_ID_CONNECT_TECH_BH8_232, 0, 0,

