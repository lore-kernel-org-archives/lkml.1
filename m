Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZFCPKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZFCPKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 11:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZFCPKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 11:10:03 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64692 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbZFCPKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 11:10:01 -0400
X-Greylist: delayed 1902 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Jun 2009 11:10:00 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=S1KItvE/rU8u0/Xb054zofyCaQqKNfpaKk9CYdTQ2U1yubz14SgQZ5uwEl4clIT30N
         ibj5XEF4mF8CwRFsfVx2pfiLk63Z8gurxPnXuwjpXePgUmDQfoCtSdAdlA0Jvy51+iwL
         dsDDIZ4je6ZRHmM1ok4nHiaXYLJwmDz6BEJlE=
MIME-Version: 1.0
In-Reply-To: <1243399356.2263.46.camel@brutus>
References: <1243399356.2263.46.camel@brutus>
Date: Wed, 3 Jun 2009 16:38:19 +0200
X-Google-Sender-Auth: 68dd681b863d2a61
Message-ID: <10f740e80906030738x3b42de18n189367b28a730c56@mail.gmail.com>
Subject: Re: [PATCH v3] MFD: PCAP driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Harald Welte <laforge@gnumonks.org>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 06:42, Daniel Ribeiro <drwyrm@gmail.com> wrote:
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -241,6 +241,13 @@ config PCF50633_GPIO
>         Say yes here if you want to include support GPIO for pins on
>         the PCF50633 chip.
>
> +config EZX_PCAP
> +       bool "PCAP Support"
> +       depends on SPI_MASTER

It also has to depend on GENERIC_HARDIRQS, as it needs set_irq_type():

> +       set_irq_type(spi->irq, IRQ_TYPE_EDGE_RISING);

Cfr. the m68k allmodconfig build failure on linux-next
http://kisskb.ellerman.id.au/kisskb/buildresult/595604/:

drivers/mfd/ezx-pcap.c:123: error: implicit declaration of function
'get_irq_chip_data'
drivers/mfd/ezx-pcap.c:179: error: implicit declaration of function
'note_interrupt'
drivers/mfd/ezx-pcap.c:189: error: implicit declaration of function
'get_irq_data'
drivers/mfd/ezx-pcap.c:370: error: implicit declaration of function
'set_irq_chip_and_handler'
drivers/mfd/ezx-pcap.c:426: error: 'handle_simple_irq' undeclared
(first use in this function)
drivers/mfd/ezx-pcap.c:426: error: (Each undeclared identifier is
reported only once
drivers/mfd/ezx-pcap.c:426: error: for each function it appears in.)
drivers/mfd/ezx-pcap.c:427: error: implicit declaration of function
'set_irq_chip_data'
drivers/mfd/ezx-pcap.c:431: error: implicit declaration of function
'set_irq_noprobe'
drivers/mfd/ezx-pcap.c:440: error: implicit declaration of function
'set_irq_type'
drivers/mfd/ezx-pcap.c:441: error: implicit declaration of function
'set_irq_data'
drivers/mfd/ezx-pcap.c:442: error: implicit declaration of function
'set_irq_chained_handler'
drivers/mfd/ezx-pcap.c:443: error: implicit declaration of function
'set_irq_wake'

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
