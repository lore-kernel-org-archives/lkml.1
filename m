Return-Path: <linux-kernel-owner+w=401wt.eu-S935665AbYBBX7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935665AbYBBX7v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934993AbYBBX6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:58:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934954AbYBBX6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:58:06 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Frank Seidel <fseidel@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/10] nozomi: finish constification
Date: Sat,  2 Feb 2008 15:56:00 -0800
Message-Id: <1201996564-21951-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080202234357.GA21721@suse.de>
References: <20080202234357.GA21721@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <fseidel@suse.de>

Even some more constifications

Signed-off-by: Frank Seidel <fseidel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/nozomi.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 7979eb1..dfaab23 100644
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
@@ -778,13 +778,13 @@ static void disable_transmit_dl(enum port_type port, struct nozomi *dc)
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
@@ -1732,7 +1732,7 @@ static int ntty_tiocmset(struct tty_struct *tty, struct file *file,
 static int ntty_cflags_changed(struct port *port, unsigned long flags,
 		struct async_icount *cprev)
 {
-	struct async_icount cnow = port->tty_icount;
+	const struct async_icount cnow = port->tty_icount;
 	int ret;
 
 	ret =	((flags & TIOCM_RNG) && (cnow.rng != cprev->rng)) ||
@@ -1747,7 +1747,7 @@ static int ntty_cflags_changed(struct port *port, unsigned long flags,
 
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
-- 
1.5.3.8

