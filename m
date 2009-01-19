Return-Path: <linux-kernel-owner+w=401wt.eu-S1752359AbZASOT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbZASOT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756299AbZASOR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:17:27 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:52971 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755308AbZASORY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:17:24 -0500
Message-ID: <49748B95.9080105@ru.mvista.com>
Date: Mon, 19 Jan 2009 17:17:57 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ide: move SFF I/O code to ide-io-sff.c
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain> <20090119130322.24745.76137.sendpatchset@localhost.localdomain>
In-Reply-To: <20090119130322.24745.76137.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

    Gah, what in the world is that SFF I/O code?

> Index: b/drivers/ide/ide-io-sff.c
> ===================================================================
> --- /dev/null
> +++ b/drivers/ide/ide-io-sff.c
> @@ -0,0 +1,314 @@
> +
> +#include <linux/kernel.h>
> +#include <linux/ide.h>
> +
> +/*
> + *	Conventional PIO operations for ATA devices
> + */
> +
> +static u8 ide_inb(unsigned long port)
> +{
> +	return (u8) inb(port);
> +}
> +
> +static void ide_outb(u8 val, unsigned long port)
> +{
> +	outb(val, port);
> +}
> +
> +/*
> + *	MMIO operations, typically used for SATA controllers
> + */
> +
> +static u8 ide_mm_inb(unsigned long port)
> +{
> +	return (u8) readb((void __iomem *) port);
> +}
> +
> +static void ide_mm_outb(u8 value, unsigned long port)
> +{
> +	writeb(value, (void __iomem *) port);
> +}

    Ah, I see. Can we finally stop abusing the SFF name? Or are we bound to 
copy every mistake that libata has made? :-/

MBR, Sergei
