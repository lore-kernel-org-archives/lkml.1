Return-Path: <linux-kernel-owner+w=401wt.eu-S1759929AbZCSRMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbZCSRMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 13:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759907AbZCSRLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 13:11:45 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:31216 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759899AbZCSRLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 13:11:44 -0400
Date: Thu, 19 Mar 2009 11:11:42 -0600
From: Alex Chiang <achiang@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/12] PCI: Introduce pci_rescan_bus()
Message-ID: <20090319171142.GH8074@ldl.fc.hp.com>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318223956.887.57080.stgit@bob.kio> <20090319022956.25ae6a5a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319022956.25ae6a5a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org>:
> On Wed, 18 Mar 2009 16:39:56 -0600 Alex Chiang <achiang@hp.com> wrote:
> 
> > +/**
> > + * pci_rescan_bus - scan a PCI bus for devices.
> > + * @bus: PCI bus to scan
> > + *
> > + * Scan a PCI bus and child buses for new devices, adds them,
> > + * and enables them.
> > + *
> > + * Returns the max number of subordinate bus discovered.
> > + */
> > +unsigned int __devinit pci_rescan_bus(struct pci_bus *bus)
> > +{
> > +	unsigned int max;
> > +	struct pci_dev *dev;
> > +
> > +	max = pci_scan_child_bus(bus);
> > +	list_for_each_entry(dev, &bus->devices, bus_list)
> > +		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
> > +		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
> > +			if (dev->subordinate)
> > +				pci_bus_size_bridges(dev->subordinate);
> > +
> > +	pci_bus_assign_resources(bus);
> > +	pci_enable_bridges(bus);
> > +	pci_bus_add_devices(bus);
> > +
> > +	return max;
> > +}
> 
> The conspicuous lack of locking for the list walk requires either
> 
> a) documenting or
> b) fixing

Ok, will figure out (a) or (b).

Thanks.

/ac

