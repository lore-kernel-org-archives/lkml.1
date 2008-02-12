Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbYBLAri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbYBLAri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 19:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760236AbYBLArY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 19:47:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49424 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761490AbYBLArW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 19:47:22 -0500
Date: Mon, 11 Feb 2008 16:45:12 -0800
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       michaelc@cs.wisc.edu, dwm@enoyolf.org, darnok@68k.org,
       pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com,
       randy.dunlap@oracle.com, hpa@zytor.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com, arjan@infradead.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: REPOST: [PATCH] Add iSCSI iBFT support (v0.4.7)
Message-ID: <20080212004512.GA23636@kroah.com>
References: <20080208194717.GA10712@andromeda.dapyr.net> <20080209031026.GA14878@andromeda.dapyr.net> <1202535132.3102.107.camel@localhost.localdomain> <200802111835.18172.konrad@darnok.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802111835.18172.konrad@darnok.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 06:35:16PM -0500, Konrad Rzeszutek wrote:
> > > +       if (hdr->id == id_nic) {
> > > +               pci_dev = pci_get_bus_and_slot((nic->pci_bdf & 0xff00) >>
> > > 8, +                                              (nic->pci_bdf & 0xff));
> > pci_get_bus_and_slot fails in the presence of PCI domains, which are
> > getting to be fairly common even in medium sized servers ... what
> > happens in that case?
> 
> The specification did not take that in to account. The Bus/Dev/Func 
> information is only present there - no domain information.

That's really broken then.  Common i386 boxes these days have multiple
PCI domains, it's not all that uncommon at all.

And almost all big 64 bit boxes have them.

> Do you think I should implement a search functionality for this so that is 
> searches through the domains for the bus/dev/func and picks the 
> first found match (which might be the wrong match)?

I'm guessing that bad things would happen if you picked the wrong pci
device, right?

> Or wait to get the spec updated so that the iBFT will have this data?

I think the spec needs to be fixed.  Or at least clarified (is it domain
0 only?)

thanks,

greg k-h
