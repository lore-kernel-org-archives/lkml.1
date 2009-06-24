Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbZFXAEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbZFXAEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbZFXAEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:04:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:57407 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbZFXAEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:04:14 -0400
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
In-Reply-To: <4A415CDC.2090700@goop.org>
References: <20090622140807.25509.54448.stgit@bob.kio>
	 <20090622143431.GT19977@parisc-linux.org> <4A3FCB68.3030004@goop.org>
	 <20090622183056.GY19977@parisc-linux.org> <1245714008.4017.7.camel@pasglop>
	 <20090623190826.GJ19977@parisc-linux.org>  <4A413C66.5010306@goop.org>
	 <1245793758.10356.27.camel@pasglop>  <4A41562F.1040901@goop.org>
	 <1245796916.10356.40.camel@pasglop>  <4A415CDC.2090700@goop.org>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 10:02:29 +1000
Message-Id: <1245801749.10356.46.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 15:53 -0700, Jeremy Fitzhardinge wrote:
> On 06/23/09 15:41, Benjamin Herrenschmidt wrote:
> >> Do you have any other cases in mind where it would be helpful?
> >>     
> >
> > Well, it might be for virtual device discovery etc... but don't bother
> > now. We might talk about it at KS for those interested. It's more
> > something we see as useful for embedded archs at the moment but in the
> > long run it might make sense for hypervisors as well.
> >   
> 
> Perhaps.  We have Xenbus - which is  a little bit like OF in that it has
> data in a hierarchical namespace - and I guess it might be possible to
> find a mapping onto some generic OF-like interface.

Which is sort-of what we did. IE. We disconnected the device-tree itself
from the underlying firmware, using the device-tree and OF-style
bindings (in some case simplified) as a basis for representing devices
but without the need for an actual open firmware underneath.

> However, Xenbus is an active communication channel between virtual machines
> rather than a
> static representation of a machine configuration (for example, you can
> put a watch on a particular path to get a notification of when someone
> else changes it).

On ppc64 too, the HV can feed us with new tree nodes or remove some, it
doesn't have to be static. Though we mostly use it as a static tree on
embedded.

> But, yes, this is a good KS hallway track subject.

Cheers,
Ben.


