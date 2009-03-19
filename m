Return-Path: <linux-kernel-owner+w=401wt.eu-S1760656AbZCSUq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760656AbZCSUq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 16:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZCSUqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 16:46:49 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29483 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbZCSUqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 16:46:48 -0400
Date: Thu, 19 Mar 2009 14:46:46 -0600
From: Alex Chiang <achiang@hp.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 08/12] PCI: Introduce /sys/bus/pci/devices/.../remove
Message-ID: <20090319204646.GB8790@ldl.fc.hp.com>
References: <20090318222426.887.1008.stgit@bob.kio> <20090318224006.887.91805.stgit@bob.kio> <49C2540E.70207@jp.fujitsu.com> <20090319164119.GC8074@ldl.fc.hp.com> <Pine.LNX.4.58.0903191342120.28292@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0903191342120.28292@shell2.speakeasy.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Trent Piepho <xyzzy@speakeasy.org>:
> On Thu, 19 Mar 2009, Alex Chiang wrote:
> > * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> > >> +	pci_remove_bus_device(pdev);
> > >> +	if (bridge && list_empty(&pdev->bus->devices))
> > >> +		pci_remove_bus(pdev->bus);
> > >
> > > I cannot understand the above two lines. Could you explain
> > > what it intend?
> >
> > If the user says:
> >
> > 	echo 1 > /sys/bus/pci/devices/.../remove
> >
> > And that device is a bridge, then we need to specifically call
> > pci_remove_bus as well, to actually remove the bus itself.
> > Without it, pci_bus_remove_device() will remove all of its
> > children (and subordinate buses) in a depth-first manner, but we
> > will never actually remove the bus that the user specified.
> 
> Did this end up being the source of the pci resource assignment warnings
> that were produced when re-adding a bridge that was removed?

I think that was one reason. I found that it was necessary during
multiple remove/rescan cycles; after the 2nd rescan, we had a
stale pci_bus hanging around that was manifesting itself as a
sysfs issue.

The other thing that Kenji found was in pci_setup_bridge(), where
we don't want to initialize the BARs if the bridge has already
been added.

Thanks.

/ac

