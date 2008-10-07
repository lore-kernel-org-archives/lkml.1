Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbYJGK3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbYJGK3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYJGK3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:29:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59483 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751081AbYJGK3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:29:36 -0400
Date: Tue, 7 Oct 2008 11:29:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org,
       "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
Subject: Re: [PATCH] serial: Add Cavium OCTEON UART definitions.
Message-ID: <20081007112932.165fce27@lxorguk.ukuu.org.uk>
In-Reply-To: <48EAAF97.8050307@caviumnetworks.com>
References: <48EAAF97.8050307@caviumnetworks.com>
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

> +#ifdef CONFIG_CPU_CAVIUM_OCTEON
> +	/* UPF_FIXED_PORT indicates an internal UART.  */
> +	if (up->port.flags & UPF_FIXED_PORT)
> +		up->port.type = PORT_OCTEON;
> +	else
> +#endif

Not nice. Please keep CPU specific ifdefs out of the 8250 core code. Can
you not set a port flag for UPF_BROKEN_OCTEON or similar to clean that up
and also make the other tests that need things doing (eg the always
calling IRQ code use port flags of a more generic nature ?)
