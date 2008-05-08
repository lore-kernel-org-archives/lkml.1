Return-Path: <linux-kernel-owner+w=401wt.eu-S1765018AbYEHXhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765018AbYEHXhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbYEHXha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:37:30 -0400
Received: from mjg.x.mythic-beasts.com ([93.93.128.6]:54399 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754204AbYEHXh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:37:28 -0400
Date: Fri, 9 May 2008 00:37:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20080508233713.GB15377@srcf.ucam.org>
References: <20080508161008.59361de5@appleyard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508161008.59361de5@appleyard>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] ata: ahci: power off unused ports
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 04:10:08PM -0700, Kristen Carlson Accardi wrote:

> +static int ahci_is_hotplug_capable(struct ata_port *ap)
> +{
> +	void __iomem *port_mmio = ahci_port_base(ap);
> +	u8 cmd;
> +
> +	if (!ahci_power_save)
> +		return 1;
> +
> +	cmd = readl(port_mmio + PORT_CMD);
> +	return ((cmd & PORT_CMD_HPCP) || (cmd & PORT_CMD_ESP));
> +}

Just out of interest, is this set on laptop bays? (Are any of those even 
native SATA yet?)
-- 
Matthew Garrett | mjg59@srcf.ucam.org
