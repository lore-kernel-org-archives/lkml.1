Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYAGTmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYAGTmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbYAGTmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:42:32 -0500
Received: from avexch1.qlogic.com ([198.70.193.115]:27715 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbYAGTmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:42:31 -0500
Date: Mon, 7 Jan 2008 11:42:25 -0800
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       James Bottomley <james.bottomley@steeleye.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, ink@jurassic.park.msu.ru,
       Alan Cox <alan@redhat.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 2/3] pci: Remove users of pci_enable_device_bars()
Message-ID: <20080107194225.GE13518@plap3.qlogic.org>
References: <20071220042811.D312DDDEE6@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220042811.D312DDDEE6@ozlabs.org>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 07 Jan 2008 19:40:48.0966 (UTC) FILETIME=[34378660:01C85165]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007, Benjamin Herrenschmidt wrote:

> This patch converts users of pci_enable_device_bars() to the new
> pci_enable_device_{io,mem} interface.
> 
> The new API fits nicely, except maybe for the QLA case where a bit of
> code re-organization might be a good idea but I prefer sticking to the
> simple patch as I don't have hardware to test on.

That's fine.  I take it these patches will be funneled via
gregkh/pci-2.6.git.  There's some qla2xxx updates which are queued for
post-2.6.24 consumption in jejb/scsi-misc-2.6.git which don't appear
to have any conflicts.

I do though have a series of patches which I'll hold off on submitting
to linux-scsi until these PCI changes are merged, as there's some
minor conflicts merging the three branches.  James B, will that be
fine?

The patches themselves appear to be working fine within several of our
test rings.  I hold off on some of the cleanup post-merge time...

Thanks,
Andrew Vasquez

> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
>  drivers/ata/pata_cs5520.c       |    2 +-
>  drivers/i2c/busses/scx200_acb.c |    2 +-
>  drivers/ide/pci/cs5520.c        |   10 ++++++++--
>  drivers/ide/setup-pci.c         |    6 ++++--
>  drivers/scsi/lpfc/lpfc_init.c   |    3 +--
>  drivers/scsi/qla2xxx/qla_os.c   |   12 +++++++++---

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
