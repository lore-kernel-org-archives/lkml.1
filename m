Return-Path: <linux-kernel-owner+w=401wt.eu-S1761421AbXGLJNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421AbXGLJNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 05:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbXGLJNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 05:13:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33622 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbXGLJNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 05:13:39 -0400
Subject: Re: [PATCH 1/1] x86-64: introduce struct pci_sysdata to facilitate
	sharing of ->sysdata
From: Arjan van de Ven <arjan@infradead.org>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>, Jeff Garzik <jeff@garzik.org>,
       Yinghai Lu <Yinghai.Lu@Sun.COM>, Andrew Morton <akpm@osdl.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jon Mason <jdmason@gmail.com>
In-Reply-To: <20070712091029.GH4189@rhun.haifa.ibm.com>
References: <20070711134514.GA4789@rhun.haifa.ibm.com>
	 <1184203051.2693.3.camel@laptopd505.fenrus.org>
	 <20070712091029.GH4189@rhun.haifa.ibm.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 12 Jul 2007 17:13:05 +0800
Message-Id: <1184231585.2720.8.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 12:10 +0300, Muli Ben-Yehuda wrote:
> On Thu, Jul 12, 2007 at 09:17:31AM +0800, Arjan van de Ven wrote:
> > On Wed, 2007-07-11 at 16:45 +0300, Muli Ben-Yehuda wrote:
> > > Andi, please consider applying for 2.6.23. Applies on top of the
> > > Calgary update I just sent out ("Calgary: more updates for 2.6.23").
> > > 
> > > This patch introduces struct pci_sysdata to x86 and x86-64, and
> > > converts the existing two users (NUMA, Calgary) to use it.
> > > 
> > > This lays the groundwork for having other users of sysdata, such as
> > > the PCI domains work.
> > > 
> > > The Calgary bits are tested, the NUMA bits just look ok.
> > 
> > I very much start to dislike the untyped "sysdata"... I much rather
> > have separate fields for the different uses (like a IOMMU field)
> > that aren't going to share ever. Possibly even typed, but for IOMMU
> > that may be tricky....
> 
> Could you elaborate on what you mean here?
> 
> If you mean instead of hanging a pci_sysdata off of struct pci_bus,
> hang a 'void *iommu' and an 'int node' directly off of the pci_bus,

yes that is what I mean.

> that looks like a lot of churn (most architecture use sysdata as an
> opaque pointer to an arch specific structure) and bloat (you would

it's only a few bytes per pci device/bus. not all that bad for having
something which involves splitting a shared pointer into logical users.

(and heck, if you really really are worried we could make it a union for
some of them, although that defeats the "split is safer" benefit)

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

