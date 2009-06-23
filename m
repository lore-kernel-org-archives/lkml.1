Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbZFWWCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbZFWWCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZFWWB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:01:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:46121 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbZFWWB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:01:57 -0400
Subject: Re: [PATCH] PCI: remove pcibios_scan_all_fns()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Alex Chiang <achiang@hp.com>,
       jbarnes@virtuousgeek.org, linux-arch@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>, Tony Luck <tony.luck@intel.com>,
       Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>,
       Avi Kivity <avi@redhat.com>, Ian Campbell <Ian.Campbell@eu.citrix.com>
In-Reply-To: <4A413C66.5010306@goop.org>
References: <20090622140807.25509.54448.stgit@bob.kio>
	 <20090622143431.GT19977@parisc-linux.org> <4A3FCB68.3030004@goop.org>
	 <20090622183056.GY19977@parisc-linux.org> <1245714008.4017.7.camel@pasglop>
	 <20090623190826.GJ19977@parisc-linux.org>  <4A413C66.5010306@goop.org>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 07:49:18 +1000
Message-Id: <1245793758.10356.27.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 13:34 -0700, Jeremy Fitzhardinge wrote:
> On reflection, I think this will work.  We have a Xen pci passthrough
> driver which gets told about the passed-through devices via xenbus,
> and
> does the appropriate setup.  At first glance, there doesn't seem to be
> any problem with that code just explicitly instantiate the devices at
> the PCI level in the same way pci_scan_device does (ie,
> alloc_pci_device, initalize the dev struct, pci_setup_device).
> 
> Is that what you mean?
> 
> IanC has looked at that code more closely, so perhaps he can confirm
> that this will work on our side.
> 
Yes, we do that in arch/powerpc/kernel/pci_64.c (and somewhere in
arch/sparc too). I'll merge those 2 implementations one of these days
and move them to drivers/of.

I think Willy was actually suggesting that you start using our
OF/device-tree stuff though which is a slightly more invasive deal but
might end up useful for other things in the long run :-)

Cheers,
Ben.


