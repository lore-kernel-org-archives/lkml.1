Return-Path: <linux-kernel-owner+w=401wt.eu-S1756688AbYBAIOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbYBAIOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 03:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbYBAIOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 03:14:10 -0500
Received: from mail.suse.de ([195.135.220.2]:37467 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628AbYBAIOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:14:07 -0500
From: Frank Seidel <fseidel@suse.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v2 3/3] nozomi: finish constification
Date: Fri, 1 Feb 2008 09:14:05 +0100
User-Agent: KMail/1.9.5
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Greg Kroah-Hartman <gregkh@suse.de>, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
References: <200801312210.30722.fseidel@suse.de> <200802010859.14583.fseidel@suse.de> <200802010909.11634.fseidel@suse.de>
In-Reply-To: <200802010909.11634.fseidel@suse.de>
Organization: SuSE Linux Products GmbH
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802010914.05840.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <fseidel@suse.de>

Even some more constifications

Signed-off-by: Frank Seidel <fseidel@suse.de>
---
 drivers/char/nozomi.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -395,7 +395,7 @@ struct buffer {
 } __attribute__ ((packed));
 
 /*    Global variables */
-static struct pci_device_id nozomi_pci_tbl[] __devinitdata = {
+static const struct pci_device_id nozomi_pci_tbl[] __devinitconst = {
 	{PCI_DEVICE(VENDOR1, DEVICE1)},
 	{},
 };
@@ -778,13 +778,13 @@ static void disable_transmit_dl(enum por
  * Return 1 - send buffer to card and ack.
  * Return 0 - don't ack, don't send buffer to card.
  */
-static int send_data(enum port_type index, struct nozomi *dc)
+static int send_data(enum port_type index, const struct nozomi *dc)
 {
 	u32 size = 0;
 	const struct port *port = &dc->port[index];
-	u8 toggle = port->toggle_ul;
+	const u8 toggle = port->toggle_ul;
 	void __iomem *addr = port->ul_addr[toggle];
-	u32 ul_size = port->ul_size[toggle];
+	const u32 ul_size = port->ul_size[toggle];
 	struct tty_struct *tty = port->tty;
 
 	/* Get data from tty and place in buf for now */
@@ -1732,7 +1732,7 @@ static int ntty_tiocmset(struct tty_stru
 static int ntty_cflags_changed(struct port *port, unsigned long flags,
 		struct async_icount *cprev)
 {
-	struct async_icount cnow = port->tty_icount;
+	const struct async_icount cnow = port->tty_icount;
 	int ret;
 
 	ret =	((flags & TIOCM_RNG) && (cnow.rng != cprev->rng)) ||
@@ -1747,7 +1747,7 @@ static int ntty_cflags_changed(struct po
 
 static int ntty_ioctl_tiocgicount(struct port *port, void __user *argp)
 {
-	struct async_icount cnow = port->tty_icount;
+	const struct async_icount cnow = port->tty_icount;
 	struct serial_icounter_struct icount;
 
 	icount.cts = cnow.cts;
@@ -1858,7 +1858,7 @@ exit_in_buffer:
 	return rval;
 }
 
-static struct tty_operations tty_ops = {
+static const struct tty_operations tty_ops = {
 	.ioctl = ntty_ioctl,
 	.open = ntty_open,
 	.close = ntty_close,
