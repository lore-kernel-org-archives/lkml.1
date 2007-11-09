Return-Path: <linux-kernel-owner+w=401wt.eu-S1762962AbXKIOZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762962AbXKIOZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 09:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760068AbXKIOZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 09:25:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52520 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760067AbXKIOZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 09:25:18 -0500
Date: Fri, 9 Nov 2007 14:25:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Frank Seidel <fseidel@suse.de>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, p.hardwick@option.com,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: nozomi version 2.1c for review
Message-ID: <20071109142500.0201fe4a@the-village.bc.nu>
In-Reply-To: <200711091449.24648.fseidel@suse.de>
References: <200711091449.24648.fseidel@suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> and already in Gregs git repository) i resolved and removed all those
> GET_* and SET_* macros.

Oh good, that was long overdue.

> +	switch (port) {
> +	case PORT_MDM:
> +		dc->last_ier = (dc->last_ier & ~MDM_UL) | MDM_UL;
> +		break;

	The & ~xxx is unneeded if you then set it again always

Could also clean up to be

	u8 mask[NR_PORTS] = { DIAG_UGL, APP1_UL, ... }
	dc->last_ier |= mask[port];

instead of the switch - ditto disable transmit_ul etc

> +	case PORT_DIAG:
> +		dc->last_ier = (dc->last_ier & ~DIAG_UL) | DIAG_UL;
> +		break;
> +	case PORT_APP1:
> +		dc->last_ier = (dc->last_ier & ~APP1_UL) | APP1_UL;


Looking a lot better than before and with plenty of scope for more
improvement now it can be read.

Alan
