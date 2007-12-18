Return-Path: <linux-kernel-owner+w=401wt.eu-S935092AbXLRAPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935092AbXLRAPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbXLRAPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:15:34 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43821 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754181AbXLRAPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:15:33 -0500
Date: Tue, 18 Dec 2007 00:07:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, <jgarzik@pobox.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, <wingel@nano-system.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       <james.smart@emulex.com>, <linux-driver@qlogic.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 2/4] pci: Remove users of pci_enable_device_bars()
Message-ID: <20071218000740.446a6adf@the-village.bc.nu>
In-Reply-To: <20071217230126.26291DDE34@ozlabs.org>
References: <1197932473.576079.142524077033.qpush@grosgo>
	<20071217230126.26291DDE34@ozlabs.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 10:01:14 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> This patch converts users of pci_enable_device_bars() to the new
> pci_enable_device_{io,mem} interface.
> 
> The new API fits nicely, except maybe for the QLA case where a bit of
> code re-organization might be a good idea but I prefer sticking to the
> simple patch as I don't have hardware to test on.
> 
> I'll also need some feedback on the cs5520 change

5520 in fact is always enabled as it is the host bridge.
pci_enable_device_io will do just fine. The 5520 fun is if you disable it
the system hangs.
