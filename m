Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYAYMpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYAYMpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 07:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbYAYMoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 07:44:38 -0500
Received: from ns2.suse.de ([195.135.220.15]:51076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbYAYMoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 07:44:34 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 012/196] nozomi driver
Date: Fri, 25 Jan 2008 13:44:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
References: <20080125071127.GA4860@kroah.com> <1201245134-4876-12-git-send-email-gregkh@suse.de> <Pine.LNX.4.64.0801250910230.12676@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801250910230.12676@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801251344.30427.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for your feedback.

On Freitag 25 Januar 2008 09:31:25, you (Jan Engelhardt) wrote:
> On Jan 24 2008 23:09, Greg Kroah-Hartman wrote:
> >+/*
> >+ * nozomi.c  -- HSDPA driver Broadband Wireless Data Card - Globe Trotter
> >+ *
> >+ * Written by: Ulf Jakobsson,
> >+ *             Jan �erfeldt,
>                      ^
> Neither in ISO-8859-1 nor UTF-8 this position contains something meaningful.
> Mind to update to UTF-8?

fixed

> >+/*
> >+ * CHANGELOG
> 
> Changelogs go into git, not files, at least that is what was mentioned
> time and again.

i removed them

> >+#ifdef __BIG_ENDIAN
> >+/* Big endian */
> >+
> >+struct toggles {
> >+	unsigned enabled:5;	/*
> >+				 * Toggle fields are valid if enabled is 0,
> >+				 * else A-channels must always be used.
> >+				 */
> >+	unsigned diag_dl:1;
> >+	unsigned mdm_dl:1;
> >+	unsigned mdm_ul:1;
> >+} __attribute__ ((packed));
> 
> Probably just me, unsigned int is a good bit more explicit.
> The driver may also use a combined struct with
> BIG_ENDIAN_BITFIELD/LITTLE_ENDIAN_BIGFIELD (see e.g. linux/ip.h).

Here i agree with Stefan, especially as this also would only
make a difference for one (struct config_table) of those four structs
and there it would vastly decrease readability.

> >+/*    Global variables */
> >+static struct pci_device_id nozomi_pci_tbl[] = {
> >+	{PCI_DEVICE(VENDOR1, DEVICE1)},
> >+	{},
> >+};
> 
> The macros are only used once, could just as well substitute them
> by their real values.

Yes, but on the other hand now all those driver specific numbers
are grouped together in the beginning of nozomi.c and it also
could happen there once will appear other cards or models of it
that this nozomi driver could handle.

> >+/*
> >+ * Handle donlink data, ports that are handled are modem and diagnostics
>             ^
> downlink

corrected

> >+static DEVICE_ATTR(card_type, 0444, card_type_show, NULL);
> 
> While 0444 is probably never going to change its meaning, S_IRUGO comes 
> into mind.

changed it to S_IRUGO

> >+/* just to discard single character writes */
> >+static void ntty_put_char(struct tty_struct *tty, unsigned char c)
> >+{
> >+	/* FIXME !!! */
> >+	DBG2("PUT CHAR Function: %c", c);
> >+}

Its just a misleading comment, but i changed it.

Besides that i also removed an error and a warning the current
checkpatch.pl now showed up ("trailing statments should be on next
line" and a "inline preferred over __inline-__").

Thanks,
Frank
