Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYKZP4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYKZP4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYKZP43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:56:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46583 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751676AbYKZP42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:56:28 -0500
Date: Wed, 26 Nov 2008 15:55:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Alan Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 8250: fix boot hang with serial console when using with
 Serial Over Lan port
Message-ID: <20081126155551.2f05f456@lxorguk.ukuu.org.uk>
In-Reply-To: <20081126134812.573d3d9e@pedra.chehab.org>
References: <20081126134812.573d3d9e@pedra.chehab.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/* Serial over Lan (SoL) hack:
> +	   Intel 8257x Gigabit ethernet chips have a
> +	   16550 emulation, to be used for Serial Over Lan.
> +	   Those chips take a longer time than a normal
> +	   serial device to signalize that a transmission
> +	   data was queued. Due to that, the above test generally
> +	   fails. One solution would be to delay the reading of
> +	   iir. However, this is not reliable, since the timeout
> +	   is variable. So, let's just don't test if we receive
> +	   TX irq. This way, we'll never enable UART_BUG_TXEN.
> +	 */
> +	if (up->port.flags & UPF_SOL_UART)
> +		goto dont_test_tx_irq;
> +

In the interest of trying to keep the driver sane can that become
"UPF_NO_TXEN_TEST" or similar so the same quirk can be applied to other
devices with the problem (ditto the pci_intel_sol_setup name could be
generalised and the message could give a pci id and "skipping TxEn test"
as a debug level note)

Otherwise looks fine to me

(please cc me on serial patches: I think you meant to cc me and Andrew as
you cc'd the mysterious "Alan Morton").

