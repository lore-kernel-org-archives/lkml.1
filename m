Return-Path: <linux-kernel-owner+w=401wt.eu-S1761948AbYAYIrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761948AbYAYIrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932670AbYAYIb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:31:27 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:35532 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704AbYAYIb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:31:26 -0500
Date: Fri, 25 Jan 2008 09:31:25 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: linux-kernel@vger.kernel.org, Frank Seidel <fseidel@suse.de>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 012/196] nozomi driver
In-Reply-To: <1201245134-4876-12-git-send-email-gregkh@suse.de>
Message-ID: <Pine.LNX.4.64.0801250910230.12676@fbirervta.pbzchgretzou.qr>
References: <20080125071127.GA4860@kroah.com> <1201245134-4876-12-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24 2008 23:09, Greg Kroah-Hartman wrote:
>+/*
>+ * nozomi.c  -- HSDPA driver Broadband Wireless Data Card - Globe Trotter
>+ *
>+ * Written by: Ulf Jakobsson,
>+ *             Jan �erfeldt,
                     ^

Neither in ISO-8859-1 nor UTF-8 this position contains something meaningful.
Mind to update to UTF-8?

>+/*
>+ * CHANGELOG

Changelogs go into git, not files, at least that is what was mentioned
time and again.

>+#ifdef __BIG_ENDIAN
>+/* Big endian */
>+
>+struct toggles {
>+	unsigned enabled:5;	/*
>+				 * Toggle fields are valid if enabled is 0,
>+				 * else A-channels must always be used.
>+				 */
>+	unsigned diag_dl:1;
>+	unsigned mdm_dl:1;
>+	unsigned mdm_ul:1;
>+} __attribute__ ((packed));

Probably just me, unsigned int is a good bit more explicit.
The driver may also use a combined struct with
BIG_ENDIAN_BITFIELD/LITTLE_ENDIAN_BIGFIELD (see e.g. linux/ip.h).

>+/*    Global variables */
>+static struct pci_device_id nozomi_pci_tbl[] = {
>+	{PCI_DEVICE(VENDOR1, DEVICE1)},
>+	{},
>+};

The macros are only used once, could just as well substitute them
by their real values.

>+/*
>+ * TODO:
>+ * -Optimize
>+ * -Rewrite cleaner
>+ */

>+/*
>+ * Handle donlink data, ports that are handled are modem and diagnostics
            ^

downlink

>+static DEVICE_ATTR(card_type, 0444, card_type_show, NULL);

While 0444 is probably never going to change its meaning, S_IRUGO comes 
into mind.

>+/* just to discard single character writes */
>+static void ntty_put_char(struct tty_struct *tty, unsigned char c)
>+{
>+	/* FIXME !!! */
>+	DBG2("PUT CHAR Function: %c", c);
>+}

fix it?
