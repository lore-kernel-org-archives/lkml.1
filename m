Return-Path: <linux-kernel-owner+w=401wt.eu-S933315AbYAaWjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbYAaWjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbYAaWjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:39:09 -0500
Received: from colo.lackof.org ([198.49.126.79]:44402 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176AbYAaWjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:39:07 -0500
Date: Thu, 31 Jan 2008 15:38:48 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dma: document dma_{un}map_{single|sg}_attrs()
	interface
Message-ID: <20080131223847.GA11872@colo.lackof.org>
References: <20080130055040.GS30022@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130055040.GS30022@sgi.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 09:50:40PM -0800, akepner@sgi.com wrote:
> 
> Document the new dma_{un}map_{single|sg}_attrs() functions. 

Thank you!

Looks good to me...so far I've only found one nit.

...
> +struct dma_attrs encapsulates a set of "dma attributes". For the 
> +definition of struct dma_attrs see linux/dma-attrs.h. 

Because all architectures will share the set of attrs definitions,
would it be reasonable to document the intent of each attr?

Two reasons for doing this:
1) people reading the driver code should understand WHY the dma attr was added.
2) other arch maintainers need to know in order to implement the same attr
   for their shiny new toys.


> +The interpretation of dma attributes is architecture-specific. 

This statement is really important....but:
Could we add a reference to arch documentation for each attr?

ie something public (doesn't have to be in linux source tree)
which explains the subtlies of how that DMA attr actually works.

Having worked on HP chipsets for 10+ years, I know releasing
original HW docs is often not possible. I'm not asking for the
impossible. Please don't flame me for that. But if the company
is willing to publish the existance of a feature, a paragraph or
two would be good marketing too. Maybe just include comments in
the arch/ code that implements the feature and reference those
comments in DMA-API.txt.


> +If struct dma_attrs* is NULL, the semantics of each of these 
> +functions is identical to those of the corresponding function 
> +without the _attrs suffix. As a result dma_map_single_attrs() 
> +can generally replace dma_map_single(), etc.
> +
> +As an example of the use of the *_attrs functions, here's how 
> +you could pass an attribute DMA_ATTR_FOO when mapping memory 
> +for DMA:
> +
> +#include <linux/dma-attrs.h>
> +/* DMA_ATTR_FOO should be defined in linux/dma-attrs.h */
> +...
> +
> +	DECLARE_DMA_ATTRS(attrs);
> +	dma_set_attr(&attrs, DMA_ATTR_FOO);
> +	....
> +	n = dma_map_sg_attrs(dev, sg, nents, DMA_TO_DEVICE, &attr);
> +	....
> +
> +Architectures that care about DMA_ATTR_FOO would check for its 
> +presence in their implementations of the mapping and unmapping 
> +routines, e.g.:
> +
> +void whizco_dma_map_sg_attrs(struct device *dev, dma_addr_t dma_addr, 
> +			     size_t size, enum dma_data_direction dir, 
> +			     struct dma_attrs* attrs)
> +{
> +	....
> +	int foo =  dma_get_attr(attrs, DMA_ATTR_FOO);
> +	....
> +	if (foo) 
> +		/* twizzle the frobnozzle */
> +	....
> +

Excellent example.

thanks again for remembering DMA-API.txt.

cheers,
grant
