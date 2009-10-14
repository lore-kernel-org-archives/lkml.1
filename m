Return-Path: <linux-kernel-owner+w=401wt.eu-S1761092AbZJNCCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761092AbZJNCCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 22:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760863AbZJNCCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 22:02:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109AbZJNCCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 22:02:45 -0400
Date: Tue, 13 Oct 2009 19:01:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Krauth.Julien" <Krauth.Julien@addi-data.com>
Cc: <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial: Add ADDI-DATA GmbH PCI-Express communication
 cards in 8250_pci.c and pci_ids.h
Message-Id: <20091013190152.7132cd7b.akpm@linux-foundation.org>
In-Reply-To: <DD0BA80209AFF04091B518EA708D0A0B013D20F0@ffserver>
References: <DD0BA80209AFF04091B518EA708D0A0B013D20F0@ffserver>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009 16:21:19 +0200 "Krauth.Julien" <Krauth.Julien@addi-data.com> wrote:

> Add support for ADDI-DATA GmbH PCI-Express communication cards:
> 
> APCIe-7300
> APCIe-7420
> APCIe-7500
> APCIe-7800
> 
> Warning: 8250_pci.c depends on pci_ids.h. 8250_pci.c
> 

I don't understand this warning.  Why are you telling us this?

> Signed-off-by: Krauth Julien <Krauth.Julien@addi-data.com>
> ---
> 
> These patches applies on kernel 2.6.31.1
> 
> --- linux-2.6.31.1-vanilla/include/linux/pci_ids.h	2009-09-24
> 17:45:25.000000000 +0200
> +++ linux-2.6.31.1/include/linux/pci_ids.h	2009-09-29
> 11:30:06.000000000 +0200

Your email client wordwraps the patches, thus corrupting them.  Please
fix that for next time.

I fixed that up and queued the patch with 2.6.32 intent, thanks.


From: "Krauth.Julien" <Krauth.Julien@addi-data.com>

Add support for ADDI-DATA GmbH PCI-Express communication cards:

APCIe-7300
APCIe-7420
APCIe-7500
APCIe-7800

Warning: 8250_pci.c depends on pci_ids.h. 8250_pci.c

Signed-off-by: Krauth Julien <Krauth.Julien@addi-data.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pci.c |   67 ++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h   |    4 ++
 2 files changed, 71 insertions(+)

diff -puN drivers/serial/8250_pci.c~serial-add-addi-data-gmbh-pci-express-communication-cards-in-8250_pcic-and-pci_idsh drivers/serial/8250_pci.c
--- a/drivers/serial/8250_pci.c~serial-add-addi-data-gmbh-pci-express-communication-cards-in-8250_pcic-and-pci_idsh
+++ a/drivers/serial/8250_pci.c
@@ -1566,6 +1566,10 @@ enum pci_board_num_t {
 	pbn_ni8430_4,
 	pbn_ni8430_8,
 	pbn_ni8430_16,
+	pbn_ADDIDATA_PCIe_1_3906250,
+	pbn_ADDIDATA_PCIe_2_3906250,
+	pbn_ADDIDATA_PCIe_4_3906250,
+	pbn_ADDIDATA_PCIe_8_3906250,
 };
 
 /*
@@ -2185,6 +2189,37 @@ static struct pciserial_board pci_boards
 		.uart_offset	= 0x10,
 		.first_offset	= 0x800,
 	},
+	/*
+	 * ADDI-DATA GmbH PCI-Express communication cards <info@addi-data.com>
+	 */
+	[pbn_ADDIDATA_PCIe_1_3906250] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.base_baud	= 3906250,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+	[pbn_ADDIDATA_PCIe_2_3906250] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 2,
+		.base_baud	= 3906250,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+	[pbn_ADDIDATA_PCIe_4_3906250] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 4,
+		.base_baud	= 3906250,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+	[pbn_ADDIDATA_PCIe_8_3906250] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 8,
+		.base_baud	= 3906250,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
 };
 
 static const struct pci_device_id softmodem_blacklist[] = {
@@ -3556,6 +3591,38 @@ static struct pci_device_id serial_pci_t
 		0,
 		pbn_b0_8_115200 },
 
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCIe7500,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_ADDIDATA_PCIe_4_3906250 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCIe7420,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_ADDIDATA_PCIe_2_3906250 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCIe7300,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_ADDIDATA_PCIe_1_3906250 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCIe7800,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_ADDIDATA_PCIe_8_3906250 },
+
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
 		PCI_VENDOR_ID_IBM, 0x0299,
 		0, 0, pbn_b0_bt_2_115200 },
diff -puN include/linux/pci_ids.h~serial-add-addi-data-gmbh-pci-express-communication-cards-in-8250_pcic-and-pci_idsh include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~serial-add-addi-data-gmbh-pci-express-communication-cards-in-8250_pcic-and-pci_idsh
+++ a/include/linux/pci_ids.h
@@ -2162,6 +2162,10 @@
 #define PCI_DEVICE_ID_ADDIDATA_APCI7420_3      0x700D
 #define PCI_DEVICE_ID_ADDIDATA_APCI7300_3      0x700E
 #define PCI_DEVICE_ID_ADDIDATA_APCI7800_3      0x700F
+#define PCI_DEVICE_ID_ADDIDATA_APCIe7300       0x7010
+#define PCI_DEVICE_ID_ADDIDATA_APCIe7420       0x7011
+#define PCI_DEVICE_ID_ADDIDATA_APCIe7500       0x7012
+#define PCI_DEVICE_ID_ADDIDATA_APCIe7800       0x7013
 
 #define PCI_VENDOR_ID_PDC		0x15e9
 
_

