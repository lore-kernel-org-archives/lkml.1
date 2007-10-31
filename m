Return-Path: <linux-kernel-owner+w=401wt.eu-S1760348AbXJaQ2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760348AbXJaQ2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760207AbXJaQ2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:28:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53634 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760185AbXJaQ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:28:33 -0400
Date: Wed, 31 Oct 2007 16:29:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Daniel Drake <dsd@gentoo.org>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
Message-ID: <20071031162922.0f9f74f2@the-village.bc.nu>
In-Reply-To: <4728A7D4.8050008@garzik.org>
References: <47274A5F.6070409@gentoo.org>
	<20071030153417.59b9182c@the-village.bc.nu>
	<47276DCA.1000808@gentoo.org>
	<20071030190153.373c9347@the-village.bc.nu>
	<47278439.4030801@gentoo.org>
	<20071031114958.210bd7cc@the-village.bc.nu>
	<20071031115754.GK5059@kernel.dk>
	<472872F6.70802@garzik.org>
	<20071031122639.GN5059@kernel.dk>
	<4728A7D4.8050008@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If this is NOT a privileged app, we must update the command validation 
> to ensure that invalid commands are not transported to the hardware.

We allow only a subset of standard commands to be issued by unprivileged
applications. We don't strictly enforce transfer sizes and its arguable
on SCSI transports this doesn't matter one iota. On ATA it perhaps
matters a bit more.

Note btw - the reset sequence cased by excess data off these drives is
something we jump up and down and trigger. For PIO draining the bits is
fine, for DMA pretty much all controllers will clean up happily enough.

Its also nothing like the problem you might think as most drives told
"send me 150 bytes, oh and the transfer length is 40" will in fact send
40. 

Alan
