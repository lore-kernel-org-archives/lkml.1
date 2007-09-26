Return-Path: <linux-kernel-owner+w=401wt.eu-S1756341AbXIZQEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341AbXIZQEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 12:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbXIZQEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 12:04:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33881 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750698AbXIZQEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 12:04:31 -0400
Date: Wed, 26 Sep 2007 17:10:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Peer Chen <peerchen@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, linux-ide <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] ahci: enable GHC.AE bit before set GHC.HR
Message-ID: <20070926171030.6b07fa42@the-village.bc.nu>
In-Reply-To: <46FA6DB8.70508@garzik.org>
References: <200709211327569648280@gmail.com>
	<46F9DA07.4080201@garzik.org>
	<20070926122332.39351382@the-village.bc.nu>
	<46FA4587.4070105@garzik.org>
	<20070926153028.6fc5b2ce@the-village.bc.nu>
	<46FA6DB8.70508@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 10:33:28 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Alan Cox wrote:
> >>> NAK - mmio is an iomap so writel and readl are the wrong things to use
> >> The patch is consistent with the rest of the driver.
> >> You are welcome to submit a patch to convert ahci to using ioremap.
> > 
> > You could just flip the relevant function to use ioread while you are
> > tidying it up, instead of spreading new bugs into the code.
> 
> No, as I just noted above, the proper fix for this driver is to use 
> ioremap rather than pci_iomap.
> 
> Adding support to ahci for legacy PIO is completely pointless.

iomap isn't just for legacy PIO. It allows us to handle future weird
mappings in ways ioremap cannot.
