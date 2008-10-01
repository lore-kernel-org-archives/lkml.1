Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYJANH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYJANH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 09:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYJANHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 09:07:19 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:45936 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYJANHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 09:07:18 -0400
Date: Wed, 1 Oct 2008 09:07:17 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Arjan van de Ven <arjan@infradead.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Message-ID: <20081001130717.GE10632@phobos.i.cabal.ca>
References: <20080926163641.288bf868@infradead.org> <20080926163718.32f0867e@infradead.org> <20080929072643.GA28871@colo.lackof.org> <20080929064220.374c68a4@infradead.org> <20080929171049.GA14409@colo.lackof.org> <20080929102325.0ca5c0c9@infradead.org> <20081001052450.GB7348@colo.lackof.org> <20080930153001.1107c0de@infradead.org> <20081001124254.GD10632@phobos.i.cabal.ca> <20081001125711.GG13822@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001125711.GG13822@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 06:57:11AM -0600, Matthew Wilcox wrote:
> > If they use the iomap interface they shouldn't be using readl at all,
> > they should be using ioread*... It would be a bug otherwise.
> 
> That's a viewpoint I've heard several people espouse over the last few
> days, but it's not (entirely) true.  Addresses returned from calling
> iomap() on a memory location must be compatible with addresses returned
> from calling ioremap(), so you can use readl() on an iomap address, as
> long as you know that it was a memory address that was iomapped.
> 
>         if (flags & IORESOURCE_MEM) {
>                 if (flags & IORESOURCE_CACHEABLE)
>                         return ioremap(start, len);
>                 return ioremap_nocache(start, len);
>         }
> 
> OK, not all architectures use the generic code, but I've been through
> and they all do more or less the above (mn10300 and frv just return the
> address, but their readl() and inl() are identical)
> 

I don't recall anyone ever promising that the iomap interfaces would be
usable with legacy accessors. I'd certainly prefer it if we didn't, as
well, as it makes for more explicitly written drivers...

Just because you can use them, doesn't mean you should.

regards, Kyle
