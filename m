Return-Path: <linux-kernel-owner+w=401wt.eu-S1161280AbXBUPqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161280AbXBUPqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161297AbXBUPqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:46:55 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47357 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161280AbXBUPqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:46:54 -0500
Date: Wed, 21 Feb 2007 16:48:26 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       ralf@linux-mips.org
Subject: Re: [PATCH 2.6.21-rc1] serial: serial_txx9 driver update
Message-ID: <20070221164826.61d0b5ea@lxorguk.ukuu.org.uk>
In-Reply-To: <20070222.003142.106263613.anemo@mba.ocn.ne.jp>
References: <20070222.003142.106263613.anemo@mba.ocn.ne.jp>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +static void serial_txx9_initialize(struct uart_port *port)
> +{
> +	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
> +
> +	sio_out(up, TXX9_SIFCR, TXX9_SIFCR_SWRST);
> +#ifdef CONFIG_CPU_TX49XX
> +	/* TX4925 BUG WORKAROUND.  Accessing SIOC register
> +	 * immediately after soft reset causes bus error. */
> +	iob();
> +	udelay(1);
> +#endif

Given this costs 1uS in a path that is not performance critical is it
worth putting the #ifdef/#endif in instead of having one set of code that
works for all ?

> +	while (sio_in(up, TXX9_SIFCR) & TXX9_SIFCR_SWRST)
> +		;

Suppose it doesn't clear ? Should also use cpu_relax() in busy loops
so any processor variant with power management can do the right thing.

Neither of course are bugs you have added, just things you have moved that
seem worth asking about.

Acked-by: Alan Cox <alan@redhat.com>

