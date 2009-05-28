Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbZE1GsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbZE1GsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 02:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZE1GsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 02:48:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:39687 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbZE1GsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 02:48:06 -0400
Subject: Re: [RFC PATCH] pccard: configure CLS on attach
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tejun Heo <tj@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, towerlexa@gmx.de,
       Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <4A1DC8B4.9060003@kernel.org>
References: <4A1BE904.8080302@kernel.org>
	 <20090526142300.73d466d0@lxorguk.ukuu.org.uk> <4A1C7EF9.2030000@gmail.com>
	 <4A1C8091.4050909@kernel.org> <4A1C86F5.1020603@jp.fujitsu.com>
	 <4A1D40FD.5050102@kernel.org> <20090527140328.GG5816@parisc-linux.org>
	 <4A1DC8B4.9060003@kernel.org>
Content-Type: text/plain
Date: Thu, 28 May 2009 16:46:24 +1000
Message-Id: <1243493184.3171.120.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-28 at 08:11 +0900, Tejun Heo wrote:
> Hello,
> 
> Matthew Wilcox wrote:
> > On Wed, May 27, 2009 at 10:32:45PM +0900, Tejun Heo wrote:
> >> THIS IS A RFC PATCH, SO NO SOB.  PLEASE DON'T APPLY YET.
> > 
> > This breaks CONFIG_PPC64, fwiw.  We'll want to stub out
> > pci_set_cacheline_size() for the PCI_DISABLE_MWI case too.
> 
> Right, thanks for spotting it.
> 
> > I don't know what PPC machines have Cardbus slots, presumably some
> > Macs do.  I don't know whether firmware takes care of configuring the
> > Cacheline Size register for Cardbus hotplug or not.  So we may want to
> > include pci_set_cacheline_size() in the !MWI build, or not.  Ben, Paul?

Right, 32-bit Mac laptops mostly, maybe embedded stuff too. On these we
definitely want to configure stuff properly from the kernel.

> ppc64 is also missing PCI_CACHE_LINE_SIZE so pci_set_cacheline_size()
> can't be built as-is.

Well, the PCI cache line size would be a runtime thing. There are some
"issues" though on some HT platforms that I don't completely remember,
it really all depends on what the machine actually is.

So I'll need to have a look at the actual patch set to figure out
how we want to deal with it.

>   BTW, on x86, pci_cache_line_size isn't
> configured like other pci devices on many machines, which doesn't harm
> correctness but still...  CLS being the same for all devices coming
> down from the same root bridge, maybe we can do away with the current
> logic and just take it from the upstream pci bridge?

Cheers,
Ben.


