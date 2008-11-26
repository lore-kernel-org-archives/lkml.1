Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbYKZRFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbYKZRFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYKZRFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:05:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40166 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbYKZRFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:05:02 -0500
Date: Wed, 26 Nov 2008 15:04:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 8250: fix boot hang with serial console when using with
 Serial Over Lan port
Message-ID: <20081126150413.7ceac766@pedra.chehab.org>
In-Reply-To: <20081126155551.2f05f456@lxorguk.ukuu.org.uk>
References: <20081126134812.573d3d9e@pedra.chehab.org>
	<20081126155551.2f05f456@lxorguk.ukuu.org.uk>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, 26 Nov 2008 15:55:51 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > +	/* Serial over Lan (SoL) hack:
> > +	   Intel 8257x Gigabit ethernet chips have a
> > +	   16550 emulation, to be used for Serial Over Lan.
> > +	   Those chips take a longer time than a normal
> > +	   serial device to signalize that a transmission
> > +	   data was queued. Due to that, the above test generally
> > +	   fails. One solution would be to delay the reading of
> > +	   iir. However, this is not reliable, since the timeout
> > +	   is variable. So, let's just don't test if we receive
> > +	   TX irq. This way, we'll never enable UART_BUG_TXEN.
> > +	 */
> > +	if (up->port.flags & UPF_SOL_UART)
> > +		goto dont_test_tx_irq;
> > +
> 
> In the interest of trying to keep the driver sane can that become
> "UPF_NO_TXEN_TEST" or similar so the same quirk can be applied to other
> devices with the problem (ditto the pci_intel_sol_setup name could be
> generalised and the message could give a pci id and "skipping TxEn test"
> as a debug level note)

Done. I'm submitting the resulting patch in the sequence.

> Otherwise looks fine to me
> 
> (please cc me on serial patches: I think you meant to cc me and Andrew as
> you cc'd the mysterious "Alan Morton").

Yes, that was the idea :)

Thanks,
Mauro
