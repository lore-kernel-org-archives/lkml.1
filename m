Return-Path: <linux-kernel-owner+w=401wt.eu-S1762485AbYEHXn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762485AbYEHXn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYEHXnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:43:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:64717 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbYEHXnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:43:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,456,1204531200"; 
   d="scan'208";a="279442542"
Date: Thu, 8 May 2008 16:35:55 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: ahci: power off unused ports
Message-ID: <20080508163555.51380949@appleyard>
In-Reply-To: <20080508233713.GB15377@srcf.ucam.org>
References: <20080508161008.59361de5@appleyard>
	<20080508233713.GB15377@srcf.ucam.org>
Reply-To: kristen.c.accardi@intel.com
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008 00:37:13 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, May 08, 2008 at 04:10:08PM -0700, Kristen Carlson Accardi wrote:
> 
> > +static int ahci_is_hotplug_capable(struct ata_port *ap)
> > +{
> > +	void __iomem *port_mmio = ahci_port_base(ap);
> > +	u8 cmd;
> > +
> > +	if (!ahci_power_save)
> > +		return 1;
> > +
> > +	cmd = readl(port_mmio + PORT_CMD);
> > +	return ((cmd & PORT_CMD_HPCP) || (cmd & PORT_CMD_ESP));
> > +}
> 
> Just out of interest, is this set on laptop bays? (Are any of those even 
> native SATA yet?)

I haven't seen any yet that are.  Most of them are PATA.  I expect
that will change in the future.

