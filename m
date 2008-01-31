Return-Path: <linux-kernel-owner+w=401wt.eu-S1764104AbYAaVKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764104AbYAaVKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbYAaVKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:10:34 -0500
Received: from mail.suse.de ([195.135.220.2]:49645 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbYAaVKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:10:33 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] nozomi: constify driver
Date: Thu, 31 Jan 2008 22:10:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
Cc: jirislaby@gmail.com, Jan Engelhardt <jengelh@computergmbh.de>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801312210.30722.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This one is based on the last patch i sent
(Re: [PATCH 012/196 ver2] nozomi driver) and is a rework
of the nozomi constify patch from Jan Engelhardt.

Signed-off-by: Frank Seidel <fseidel@suse.de>
---
 drivers/char/nozomi.c |   50 ++++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -395,7 +395,7 @@ struct buffer {
 } __attribute__ ((packed));
 
 /*    Global variables */
-static struct pci_device_id nozomi_pci_tbl[] = {
+static const struct pci_device_id nozomi_pci_tbl[] __devinitdata = {
 	{PCI_DEVICE(VENDOR1, DEVICE1)},
 	{},
 };
@@ -471,12 +471,12 @@ out:
  * -Optimize
  * -Rewrite cleaner
  */
-static u32 write_mem32(void __iomem *mem_addr_start, u32 *buf,
+static u32 write_mem32(void __iomem *mem_addr_start, const u32 *buf,
 			u32 size_bytes)
 {
 	u32 i = 0;
 	u32 *ptr = (__force u32 *) mem_addr_start;
-	u16 *buf16;
+	const u16 *buf16;
 
 	if (unlikely(!ptr || !buf))
 		return 0;
@@ -484,7 +484,7 @@ static u32 write_mem32(void __iomem *mem
 	/* shortcut for extremely often used cases */
 	switch (size_bytes) {
 	case 2:	/* 2 bytes */
-		buf16 = (u16 *) buf;
+		buf16 = (const u16 *)buf;
 		writew(__cpu_to_le16(*buf16), (void __iomem *)ptr);
 		return 2;
 		break;
@@ -501,7 +501,7 @@ static u32 write_mem32(void __iomem *mem
 	while (i < size_bytes) {
 		if (size_bytes - i == 2) {
 			/* 2 bytes */
-			buf16 = (u16 *) buf;
+			buf16 = (const u16 *)buf;
 			writew(__cpu_to_le16(*buf16), (void __iomem *)ptr);
 			i += 2;
 		} else {
@@ -723,8 +723,7 @@ static int nozomi_read_config_table(stru
 /* Enable uplink interrupts  */
 static void enable_transmit_ul(enum port_type port, struct nozomi *dc)
 {
-	u16 mask[NOZOMI_MAX_PORTS] = \
-			{MDM_UL, DIAG_UL, APP1_UL, APP2_UL, CTRL_UL};
+	static const u16 mask[] = {MDM_UL, DIAG_UL, APP1_UL, APP2_UL, CTRL_UL};
 
 	if (port < NOZOMI_MAX_PORTS) {
 		dc->last_ier |= mask[port];
@@ -737,8 +736,8 @@ static void enable_transmit_ul(enum port
 /* Disable uplink interrupts  */
 static void disable_transmit_ul(enum port_type port, struct nozomi *dc)
 {
-	u16 mask[NOZOMI_MAX_PORTS] = \
-			{~MDM_UL, ~DIAG_UL, ~APP1_UL, ~APP2_UL, ~CTRL_UL};
+	static const u16 mask[] =
+		{~MDM_UL, ~DIAG_UL, ~APP1_UL, ~APP2_UL, ~CTRL_UL};
 
 	if (port < NOZOMI_MAX_PORTS) {
 		dc->last_ier &= mask[port];
@@ -751,8 +750,7 @@ static void disable_transmit_ul(enum por
 /* Enable downlink interrupts */
 static void enable_transmit_dl(enum port_type port, struct nozomi *dc)
 {
-	u16 mask[NOZOMI_MAX_PORTS] = \
-			{MDM_DL, DIAG_DL, APP1_DL, APP2_DL, CTRL_DL};
+	static const u16 mask[] = {MDM_DL, DIAG_DL, APP1_DL, APP2_DL, CTRL_DL};
 
 	if (port < NOZOMI_MAX_PORTS) {
 		dc->last_ier |= mask[port];
@@ -765,8 +763,8 @@ static void enable_transmit_dl(enum port
 /* Disable downlink interrupts */
 static void disable_transmit_dl(enum port_type port, struct nozomi *dc)
 {
-	u16 mask[NOZOMI_MAX_PORTS] = \
-			{~MDM_DL, ~DIAG_DL, ~APP1_DL, ~APP2_DL, ~CTRL_DL};
+	static const u16 mask[] =
+		{~MDM_DL, ~DIAG_DL, ~APP1_DL, ~APP2_DL, ~CTRL_DL};
 
 	if (port < NOZOMI_MAX_PORTS) {
 		dc->last_ier &= mask[port];
@@ -780,13 +778,13 @@ static void disable_transmit_dl(enum por
  * Return 1 - send buffer to card and ack.
  * Return 0 - don't ack, don't send buffer to card.
  */
-static int send_data(enum port_type index, struct nozomi *dc)
+static int send_data(enum port_type index, const struct nozomi *dc)
 {
 	u32 size = 0;
-	struct port *port = &dc->port[index];
-	u8 toggle = port->toggle_ul;
+	const struct port *port = &dc->port[index];
+	const u8 toggle = port->toggle_ul;
 	void __iomem *addr = port->ul_addr[toggle];
-	u32 ul_size = port->ul_size[toggle];
+	const u32 ul_size = port->ul_size[toggle];
 	struct tty_struct *tty = port->tty;
 
 	/* Get data from tty and place in buf for now */
@@ -1306,7 +1304,7 @@ static void nozomi_setup_private_data(st
 static ssize_t card_type_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
-	struct nozomi *dc = pci_get_drvdata(to_pci_dev(dev));
+	const struct nozomi *dc = pci_get_drvdata(to_pci_dev(dev));
 
 	return sprintf(buf, "%d\n", dc->card_type);
 }
@@ -1315,7 +1313,7 @@ static DEVICE_ATTR(card_type, S_IRUGO, c
 static ssize_t open_ttys_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
-	struct nozomi *dc = pci_get_drvdata(to_pci_dev(dev));
+	const struct nozomi *dc = pci_get_drvdata(to_pci_dev(dev));
 
 	return sprintf(buf, "%u\n", dc->open_ttys);
 }
@@ -1682,7 +1680,7 @@ static int ntty_write_room(struct tty_st
 {
 	struct port *port = tty->driver_data;
 	int room = 0;
-	struct nozomi *dc = get_dc_by_tty(tty);
+	const struct nozomi *dc = get_dc_by_tty(tty);
 
 	if (!dc || !port)
 		return 0;
@@ -1702,9 +1700,9 @@ exit:
 /* Gets io control parameters */
 static int ntty_tiocmget(struct tty_struct *tty, struct file *file)
 {
-	struct port *port = tty->driver_data;
-	struct ctrl_dl *ctrl_dl = &port->ctrl_dl;
-	struct ctrl_ul *ctrl_ul = &port->ctrl_ul;
+	const struct port *port = tty->driver_data;
+	const struct ctrl_dl *ctrl_dl = &port->ctrl_dl;
+	const struct ctrl_ul *ctrl_ul = &port->ctrl_ul;
 
 	return	(ctrl_ul->RTS ? TIOCM_RTS : 0) |
 		(ctrl_ul->DTR ? TIOCM_DTR : 0) |
@@ -1734,7 +1732,7 @@ static int ntty_tiocmset(struct tty_stru
 static int ntty_cflags_changed(struct port *port, unsigned long flags,
 		struct async_icount *cprev)
 {
-	struct async_icount cnow = port->tty_icount;
+	const struct async_icount cnow = port->tty_icount;
 	int ret;
 
 	ret =	((flags & TIOCM_RNG) && (cnow.rng != cprev->rng)) ||
@@ -1749,7 +1747,7 @@ static int ntty_cflags_changed(struct po
 
 static int ntty_ioctl_tiocgicount(struct port *port, void __user *argp)
 {
-	struct async_icount cnow = port->tty_icount;
+	const struct async_icount cnow = port->tty_icount;
 	struct serial_icounter_struct icount;
 
 	icount.cts = cnow.cts;
@@ -1860,7 +1858,7 @@ exit_in_buffer:
 	return rval;
 }
 
-static struct tty_operations tty_ops = {
+static const struct tty_operations tty_ops = {
 	.ioctl = ntty_ioctl,
 	.open = ntty_open,
 	.close = ntty_close,
