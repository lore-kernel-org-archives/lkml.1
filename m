Return-Path: <linux-kernel-owner+w=401wt.eu-S1764822AbZAONap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764822AbZAONap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbZAONaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:30:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60776 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757785AbZAONaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:30:17 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/8] 8250_pci: add support for netmos 9835 IBM devices
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 13:30:34 +0000
Message-ID: <20090115133030.21366.97252.stgit@localhost.localdomain>
In-Reply-To: <20090115132718.21366.56187.stgit@localhost.localdomain>
References: <20090115132718.21366.56187.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Most of netmos 9835 hardware is handled by parport-serial.  IBM introduces
a device which doesn't have any parallel ports and have screwed subdevice
PCI id (not corresponding to port numbers).

Handle this device (9710:9835 1014:0299) properly.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/8250_pci.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index c088146..2a36712 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -602,6 +602,10 @@ static int pci_netmos_init(struct pci_dev *dev)
 	/* subdevice 0x00PS means <P> parallel, <S> serial */
 	unsigned int num_serial = dev->subsystem_device & 0xf;
 
+	if (dev->subsystem_vendor == PCI_VENDOR_ID_IBM &&
+			dev->subsystem_device == 0x0299)
+		return 0;
+
 	if (num_serial == 0)
 		return -ENODEV;
 	return num_serial;
@@ -3096,6 +3100,10 @@ static struct pci_device_id serial_pci_tbl[] = {
 		0,
 		pbn_b0_8_115200 },
 
+	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
+		PCI_VENDOR_ID_IBM, 0x0299,
+		0, 0, pbn_b0_bt_2_115200 },
+
 	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL

