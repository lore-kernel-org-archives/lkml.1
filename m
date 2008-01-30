Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbYA3TrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbYA3TrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYA3Tq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:46:56 -0500
Received: from relay2.sgi.com ([192.48.171.30]:53163 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756100AbYA3Tqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:46:55 -0500
From: akepner@sgi.com
Date: Wed, 30 Jan 2008 11:45:28 -0800
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       Muli Ben-Yehuda <muli@il.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] dma/ia64: update ia64 machvecs
Message-ID: <20080130194528.GX30022@sgi.com>
References: <20080130055212.GT30022@sgi.com> <1201713958.3292.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201713958.3292.27.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 11:25:58AM -0600, James Bottomley wrote:
> In general, the patches look reasonable to me.  Just an observation:
> 
> On Tue, 2008-01-29 at 21:52 -0800, akepner@sgi.com wrote:
> > diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
> > index e69de29..31af292 100644
> > --- a/include/linux/dma-attrs.h
> > +++ b/include/linux/dma-attrs.h
> > @@ -0,0 +1,48 @@
> > +#ifndef _DMA_ATTR_H
> > +#define _DMA_ATTR_H
> > +#ifdef ARCH_USES_DMA_ATTRS
> > +
> > +enum dma_attr {
> > +       DMA_ATTR_BARRIER,
> > +       DMA_ATTR_FOO,
> > +       DMA_ATTR_GOO,
> > +       DMA_ATTR_MAX,
> > +};
> > +
> 
> 
> The attribute names (DMA_ATTR_...) are going to have to live somewhere
> outside of the #ifdef ARCH_USES_DMA_ATTRS otherwise we'll get compile
> failures of drivers using attributes on architectures that don't support
> them.

Right. Thanks for catching that.

> 
> Secondly, DMA_ATTR_BARRIER doesn't quite sound right.  What you're
> actually doing is trying to prescribe strict ordering, so shouldn't this
> be something like DMA_ATTR_STRICT_ORDERING (and perhaps with a
> corresponding DMA_ATTR_RELAXED_ORDERING for the PCIe case).  

OK, I'll reconsider the names here.

> ... also,
> strike the DMA_ATTR_FOO and DMA_ATTR_GOO since they have no plausible
> meaning.
> 

Yeah, I realized only after sending that I'd forgotten to 
remove these. 

-- 
Arthur

