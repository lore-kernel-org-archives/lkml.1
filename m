Return-Path: <linux-kernel-owner+w=401wt.eu-S1765654AbYBAGZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765654AbYBAGZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 01:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYBAGZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 01:25:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:40913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbYBAGZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 01:25:08 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SuSE Linux Products GmbH
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] nozomi: constify driver
Date: Fri, 1 Feb 2008 07:25:05 +0100
User-Agent: KMail/1.9.5
Cc: Greg Kroah-Hartman <gregkh@suse.de>, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org
References: <200801312210.30722.fseidel@suse.de> <Pine.LNX.4.64.0801312238170.4864@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801312238170.4864@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802010725.05421.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 January 2008 22:39, Jan Engelhardt wrote:
> On Jan 31 2008 22:10, Frank Seidel wrote:
> >(Re: [PATCH 012/196 ver2] nozomi driver) and is a rework
> >of the nozomi constify patch from Jan Engelhardt.
> 
> It's hard to find what you actually reworked...

No, just use interdiff and its easy :-) .. and btw
I didn't say i did a full rewrite ;-)

> >-static struct pci_device_id nozomi_pci_tbl[] = {
> >+static const struct pci_device_id nozomi_pci_tbl[] __devinitdata = {
> 
> This is bogus.

In what way? First i tested this patch well (compiling and
usage doesn't break a single thing) and second this (static
const struct pci_device_id .. __devinitdata) can be found in many
drivers.
So, please explain why you think so.

Thanks,
Frank

P.S.: btw this is the interdiff. Yes, its not big, but even
then why not combine it with yours ;-)
---
diff -u b/drivers/char/nozomi.c b/drivers/char/nozomi.c
--- b/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -395,7 +395,7 @@
 } __attribute__ ((packed));
 
 /*    Global variables */
-static struct pci_device_id nozomi_pci_tbl[] __devinitdata = {
+static const struct pci_device_id nozomi_pci_tbl[] __devinitdata = {
 	{PCI_DEVICE(VENDOR1, DEVICE1)},
 	{},
 };
@@ -778,13 +778,13 @@
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
@@ -1732,7 +1732,7 @@
 static int ntty_cflags_changed(struct port *port, unsigned long flags,
 		struct async_icount *cprev)
 {
-	struct async_icount cnow = port->tty_icount;
+	const struct async_icount cnow = port->tty_icount;
 	int ret;
 
 	ret =	((flags & TIOCM_RNG) && (cnow.rng != cprev->rng)) ||
@@ -1747,7 +1747,7 @@
 
 static int ntty_ioctl_tiocgicount(struct port *port, void __user *argp)
 {
-	struct async_icount cnow = port->tty_icount;
+	const struct async_icount cnow = port->tty_icount;
 	struct serial_icounter_struct icount;
 
 	icount.cts = cnow.cts;
@@ -1858,7 +1858,7 @@
 	return rval;
 }
 
-static struct tty_operations tty_ops = {
+static const struct tty_operations tty_ops = {
 	.ioctl = ntty_ioctl,
 	.open = ntty_open,
 	.close = ntty_close,
