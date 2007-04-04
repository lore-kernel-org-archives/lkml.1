Return-Path: <linux-kernel-owner+w=401wt.eu-S966228AbXDDBXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966228AbXDDBXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966237AbXDDBXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:23:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52713 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966228AbXDDBXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:23:05 -0400
Date: Wed, 4 Apr 2007 02:25:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Brad Boyer <flar@allandria.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404022544.59b022a6@the-village.bc.nu>
In-Reply-To: <20070403212928.GA12951@cynthia.pants.nu>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	<17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	<1175642916.10567.24.camel@shinybook.infradead.org>
	<20070403212928.GA12951@cynthia.pants.nu>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The TTY_MAJOR should have never belonged to 8250.c in the first place.
> I know it's just my opinion, but I think this major device should be
> owned by the serial core, and it shouldn't matter what chip drives each
> individual port. Each hardware driver should just register with the
> core how many ports it has and should be allocated from the same range.

That would be completely unmanagable on many systems with multiport
controllers and interfaces where the naming tells you things like which
cable port off which socket off which multiplexor is the one you are
talking about.

You can't dynamically identify serial ports, you can't generally speaking
probe the device the other end and get persistant identifiers.

> This situation is purely a side-effect of the fact that all the
> original Linux supported hardware used the 8250 driver and everyone
> who didn't use 8250 was marginalized enough that they got ignored.

Nope. The original design used different numbers of each type of port
quite intentionally. Having handy names for the onboard ports is useful
as well but not related. One or two people cheated and its finally come
back to haunt them.

Alan
