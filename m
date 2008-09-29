Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbYI2NmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbYI2NmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 09:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYI2NmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 09:42:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:53435 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYI2NmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 09:42:07 -0400
Date: Mon, 29 Sep 2008 06:42:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Message-ID: <20080929064220.374c68a4@infradead.org>
In-Reply-To: <20080929072643.GA28871@colo.lackof.org>
References: <20080926163641.288bf868@infradead.org>
	<20080926163718.32f0867e@infradead.org>
	<20080929072643.GA28871@colo.lackof.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008 01:26:43 -0600
Grant Grundler <grundler@parisc-linux.org> wrote:
> 
> Alternatively, the ioremap_pcibar() code needs to check for
> cacheable attribute and DTRT.

we should make it "if prefetchable, UC-, if not, hard UC", yes.

> > -	core->lmmio = ioremap(pci_resource_start(pci, 0),
> > -			      pci_resource_len(pci, 0));
> > +	core->lmmio = ioremap_pcibar(pci, 0);
> 
> Is there any easy way to tell if the device driver should be using
> uncached mappings vs cacheable mappings?
> (Just from looking at the source code)
> 
> This patch changes that behavior of the device driver so it uses
> uncacheable instead of cacheable mappings.  This is the only thing
> I'm uncertain about for this patch.

ioremap() also is uncachable today.


> 
> And I have a second issue less important issue.
> What is the result of ioremap_pcibar(pci, 1) when BAR0 is a 64-bit
> bar? Given the name, I expect to call "ioremap_pcibar(pci,2)" to get
> the desired result.  Maybe just document how to handle this correctly
> in Documentation/pci.txt would be sufficient.

we should detect this and DTRT inside the implementation, not in the
drivers.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
