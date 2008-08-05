Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYHEHQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYHEHQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYHEHP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 03:15:56 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57186 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753940AbYHEHPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 03:15:55 -0400
Subject: Re: [PATCH 1/2] pci: add misrouted interrupt error handling
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
In-Reply-To: <200808041443.20942.bjorn.helgaas@hp.com>
References: <1217786532.4179.24.camel@localhost.localdomain>
	 <200808041443.20942.bjorn.helgaas@hp.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 17:02:27 -0700
Message-Id: <1217894547.3318.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 14:43 -0600, Bjorn Helgaas wrote:
> On Sunday 03 August 2008 12:02:12 pm James Bottomley wrote:
> > +static void pci_note_irq_problem(struct pci_dev *pdev, const char *reason)
> > +{
> > +	struct pci_dev *parent = to_pci_dev(pdev->dev.parent);
> > +
> > +	dev_printk(KERN_ERR, &pdev->dev,
> > +		   "Potentially misrouted IRQ (Bridge %s %04x:%04x)\n",
> > +		   parent->dev.bus_id, parent->vendor, parent->device);
> 
> Do you prefer "dev_printk(KERN_ERR, ...)" over "dev_err(...)"?  Easier
> to grep for the former, maybe?  If so, should we deprecate "dev_err()"
> and friends?  When I converted most of the PCI core to use dev_printk(),
> (80ccba1186d48f ...) I used dev_err(), but I don't really care one way
> or the other.
> 
> Maybe use pci_name(parent)?
> 
> I tried to standardize the PCI core on "[%04x/%04x]" for vendor/device ID.

To be honest I'm not really interested too much in the various API
preferences ... they can be fixed up later by the people who care.

What I am interested in is whether we can get this interface to give
sufficient information to blacklist the offending motherboard if we can
identify it as the source of the problem.  Since the usual culprit is
the bridge, that's why I'm doing parent vendor/device pairs.  However,
better suggestions for the information that should be displayed would be
gratefully received.

James


