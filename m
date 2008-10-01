Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbYJAFZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbYJAFZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 01:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbYJAFZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 01:25:05 -0400
Received: from colo.lackof.org ([198.49.126.79]:47057 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbYJAFZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 01:25:03 -0400
Date: Tue, 30 Sep 2008 23:24:50 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Message-ID: <20081001052450.GB7348@colo.lackof.org>
References: <20080926163641.288bf868@infradead.org> <20080926163718.32f0867e@infradead.org> <20080929072643.GA28871@colo.lackof.org> <20080929064220.374c68a4@infradead.org> <20080929171049.GA14409@colo.lackof.org> <20080929102325.0ca5c0c9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080929102325.0ca5c0c9@infradead.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 10:23:25AM -0700, Arjan van de Ven wrote:
> On Mon, 29 Sep 2008 11:10:49 -0600
> Grant Grundler <grundler@parisc-linux.org> wrote:
> 
> > And I have to agree with willy/alan, pci_iomap() is already doing
> > this.
> 
> pci_iomap() does "stuff" but it assumes you're using the iomap APIs
> across the driver. MANY don't.

pci_iomap() returns a "void __iomem *".
readl/writel take "void __iomem *" as an argument.
See build_mmio_read() in include/asm-x86/io.h

I think the assumption is the other way around: use of ioread/iowrite
assumes use of io_remap(). pci_iomap is the PCI wrapper around io_remap().
You just want a simpler wrapper (and I agree, it really could without
the extra arg).

But in any case, we can document pci_iomap() to be whatever you think
we should be exporting.  pci_iomap() is not currently documented in
Documentation/. Or at least grep isn't seeing it.


> And pci_iomap() takes more parameters than most driver writers want or
> need. Most of the time it's "I want the whole bar"; even if my patch
> wraps around that, making the API simpler is still worth it imo

You are right about that.
Would calling the API "pci_iomap_bar()" to keep the naming consistent help
make it more acceptable?

(And adding documentation for both would be good too...I can do
that if the new API gets accepted.)

hth,
grant
