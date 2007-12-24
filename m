Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbXLXHOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbXLXHOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 02:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbXLXHOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 02:14:10 -0500
Received: from colo.lackof.org ([198.49.126.79]:54119 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbXLXHOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 02:14:09 -0500
Date: Mon, 24 Dec 2007 00:13:01 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, jgarzik@pobox.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/4] pci: Remove users of pci_enable_device_bars()
Message-ID: <20071224071300.GC3758@colo.lackof.org>
References: <1197932473.576079.142524077033.qpush@grosgo> <20071217230126.26291DDE34@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071217230126.26291DDE34@ozlabs.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a style nit...

On Tue, Dec 18, 2007 at 10:01:14AM +1100, Benjamin Herrenschmidt wrote:
> This patch converts users of pci_enable_device_bars() to the new
> pci_enable_device_{io,mem} interface.
> 
> The new API fits nicely, except maybe for the QLA case where a bit of
> code re-organization might be a good idea but I prefer sticking to the
> simple patch as I don't have hardware to test on.
> 
> I'll also need some feedback on the cs5520 change.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
....
>  	/* We must not grab the entire device, it has 'ISA' space in its
> -	   BARS too and we will freak out other bits of the kernel */
> -	if (pci_enable_device_bars(dev, 1<<2)) {
> +	 * BARS too and we will freak out other bits of the kernel
> +	 *
> +	 * pci_enable_device_bars() is going away. I replaced it with
> +	 * IO only enable for now but I'll need confirmation this is
> +	 * allright for that device. If not, it will need some kind of
> +	 * quirk. --BenH.
> +	 */

This comment doesn't really belong in the code. It should be part of
the commit log or email RFC.

cheers,
grant
