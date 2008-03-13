Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbYCMPaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbYCMPaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYCMPaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:30:09 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:34316 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbYCMPaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:30:07 -0400
Date: Thu, 13 Mar 2008 08:27:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: akepner@sgi.com, Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 v4] dma: dma_{un}map_{single|sg}_attrs() interface
Message-Id: <20080313082754.3da94420.randy.dunlap@oracle.com>
In-Reply-To: <20080313014106.782aa3c7.akpm@linux-foundation.org>
References: <20080313040022.GJ12370@sgi.com>
	<20080313014106.782aa3c7.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 01:41:06 -0700 Andrew Morton wrote:

> > +#ifdef ARCH_USES_DMA_ATTRS
> 
> There is no precedent for ARCH_USES_*.
> 
> There is a little bit of precedent for ARCH_HAVE_*
> 
> There is lots of precendence for ARCH_HAS_*.
> 
> We don't like ARCH_HAS_* anyway ;) What can we do to get rid of this? 
> Ideally, make it available on all architectures at zero cost to those which
> don't need it.  If that is impractical (why?) then it is preferable to do
> this in Kconfig.

Sam has been pushing HAVE_* and even added that to
Documentation/kbuild/kconfig-language.txt.

> > +/*
> > + * dma_set_attr - set a specific attribute
> > + * may be called with a null attrs
> > + */

Use kernel-doc notation?

> > +static inline int dma_set_attr(struct dma_attrs *attrs, enum dma_attr attr)
> > +{
> > +	if (!attrs)
> > +		return 0;
> > +	if (attr < DMA_ATTR_MAX) {
> > +		attrs->flags |= (1 << attr);
> > +		return 0;
> > +	}
> > +	return -EINVAL;
> > +}
> 
> Is there any non-buggy reason why code would pass an out-of-range attribute
> into this function?  If not, BUG_ON() would be appropriate treatment.
> 
> This function might already be too large to inline, and a BUG_ON() might
> make it larger.
> 
> > +/*
> > + * dma_get_attr - check for a specific attribute
> > + * may be called with a null attrs
> > + */

Ditto.

> > +static inline int dma_get_attr(struct dma_attrs *attrs, enum dma_attr attr)
> > +{
> > +	if (!attrs)
> > +		return 0;
> > +	if (attr < DMA_ATTR_MAX) {
> > +		int ret = attrs->flags & (1 << attr);
> > +		return !!ret;
> > +	}
> > +	return -EINVAL;
> > +}


---
~Randy
