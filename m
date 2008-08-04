Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbYHDUpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbYHDUpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763589AbYHDUoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:44:44 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:14688 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbYHDUon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:44:43 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
Date: Mon, 4 Aug 2008 14:43:20 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <1217786532.4179.24.camel@localhost.localdomain>
In-Reply-To: <1217786532.4179.24.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808041443.20942.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 August 2008 12:02:12 pm James Bottomley wrote:
> +static void pci_note_irq_problem(struct pci_dev *pdev, const char *reason)
> +{
> +	struct pci_dev *parent = to_pci_dev(pdev->dev.parent);
> +
> +	dev_printk(KERN_ERR, &pdev->dev,
> +		   "Potentially misrouted IRQ (Bridge %s %04x:%04x)\n",
> +		   parent->dev.bus_id, parent->vendor, parent->device);

Do you prefer "dev_printk(KERN_ERR, ...)" over "dev_err(...)"?  Easier
to grep for the former, maybe?  If so, should we deprecate "dev_err()"
and friends?  When I converted most of the PCI core to use dev_printk(),
(80ccba1186d48f ...) I used dev_err(), but I don't really care one way
or the other.

Maybe use pci_name(parent)?

I tried to standardize the PCI core on "[%04x/%04x]" for vendor/device ID.

Bjorn

