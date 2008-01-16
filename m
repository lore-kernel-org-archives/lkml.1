Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYAPSy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYAPSy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYAPSyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:54:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYAPSyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:54:46 -0500
Message-ID: <478E5095.2020803@zytor.com>
Date: Wed, 16 Jan 2008 13:44:37 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org,
       Russell King <rmk+serial@arm.linux.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] 8250_pnp: register x86 COM ports at the conventional
 ttyS names
References: <20080116170541.511233227@ldl.fc.hp.com> <20080116170914.959390017@ldl.fc.hp.com>
In-Reply-To: <20080116170914.959390017@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> x86 users expect COM1-COM4 ports at the conventional ioport addresses
> to be named ttyS0-ttyS3.  For PNP devices, the BIOS determines the
> order we discover them, so we might discover COM2 before COM1.
> 
> We currently always get the correct names, even without this patch.
> But that's only because serial8250_isa_init_ports() first registers
> the hard-coded list of COM port addresses from SERIAL_PORT_DFNS.  When
> PNP rediscovers one of those ports, it gets the already-established
> line.
> 
> This patch removes the implicit dependency on SERIAL_PORT_DFNS by
> requesting the names we desire.
>  
>  static int __devinit
> +serial_pnp_line(struct uart_port *port)
> +{
> +#ifdef CONFIG_X86
> +	switch (port->iobase) {
> +	case 0x3f8:	return 0;	/* COM1 -> ttyS0 */
> +	case 0x2f8:	return 1;	/* COM2 -> ttyS1 */
> +	case 0x3e8:	return 2;	/* COM3 -> ttyS2 */
> +	case 0x2e8:	return 3;	/* COM4 -> ttyS3 */
> +	}
> +#endif
> +

Arguably, the right thing is to use the addresses present in the array 
at address 0x400.  In particular, COM3 and COM4 aren't always at those 
addresses.

	-hpa
