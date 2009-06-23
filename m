Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbZFWU5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbZFWU5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbZFWU4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:56:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53761 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbZFWU4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:56:53 -0400
Date: Tue, 23 Jun 2009 14:56:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
       linux-arch@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       Tony Luck <tony.luck@intel.com>, Russell King <linux@arm.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Avi Kivity <avi@redhat.com>, Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
Message-ID: <20090623205653.GM19977@parisc-linux.org>
References: <20090622140807.25509.54448.stgit@bob.kio> <20090622143431.GT19977@parisc-linux.org> <4A3FCB68.3030004@goop.org> <20090622183056.GY19977@parisc-linux.org> <1245714008.4017.7.camel@pasglop> <20090623190826.GJ19977@parisc-linux.org> <4A413C66.5010306@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A413C66.5010306@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 01:34:46PM -0700, Jeremy Fitzhardinge wrote:
> On 06/23/09 12:08, Matthew Wilcox wrote:
> > I think simply materialising them, either the way the OF code does,
> > or the way the IOV code does is the best route forwards.
> >   
> 
> On reflection, I think this will work.  We have a Xen pci passthrough
> driver which gets told about the passed-through devices via xenbus, and
> does the appropriate setup.  At first glance, there doesn't seem to be
> any problem with that code just explicitly instantiate the devices at
> the PCI level in the same way pci_scan_device does (ie,
> alloc_pci_device, initalize the dev struct, pci_setup_device).

Even easier actually, pci_scan_single_device() should do everything you want.

> Is that what you mean?
> 
> IanC has looked at that code more closely, so perhaps he can confirm
> that this will work on our side.
> 
>     J
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
