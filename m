Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbXJVP2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbXJVP2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 11:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbXJVP23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 11:28:29 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:45793 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXJVP22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 11:28:28 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: PCMCIA driver resource allocation
Date: Mon, 22 Oct 2007 09:27:48 -0600
User-Agent: KMail/1.9.6
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <200710191051.51686.bjorn.helgaas@hp.com> <20071019224022.GA29738@flint.arm.linux.org.uk>
In-Reply-To: <20071019224022.GA29738@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710220927.49162.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2007 04:40:22 pm Russell King wrote:
> On Fri, Oct 19, 2007 at 10:51:51AM -0600, Bjorn Helgaas wrote:

> > +	priv->io_resource = request_region(link->io.BasePort1,
> > +					   link->io.NumPorts1, DRIVER_NAME);
> > +	if (!priv->io_resource)
> > +		goto cs_failed;
> >  	mem = ioport_map(link->io.BasePort1, link->io.NumPorts1);
> >  	if (!mem)
> >  		goto cs_failed;
> > @@ -366,6 +370,10 @@
> >  	pcmcia_disable_device(link);
> >  	if (priv->hw.iobase)
> >  		ioport_unmap(priv->hw.iobase);
> > +	if (priv->io_resource) {
> > +		release_resource(priv->io_resource);
> > +		priv->io_resource = NULL;
> 
> Wrong function.  release_resource() doesn't pair with request_region().
> request_region() allocates memory for the struct resource.
> release_resource() merely removes the struct resource from the tree.
> release_region() on the other hand removes the struct resource and
> frees it.

Oh, thanks!  I didn't notice that difference between release_region()
and release_resource().  I'll fix the patch.

Bjorn


