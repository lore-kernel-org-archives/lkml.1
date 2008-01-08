Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYAHSMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYAHSMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYAHSL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:11:58 -0500
Received: from relay2.sgi.com ([192.48.171.30]:46248 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752839AbYAHSL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:11:57 -0500
From: akepner@sgi.com
Date: Tue, 8 Jan 2008 10:10:29 -0800
To: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 1/3] dma: create linux/dma-direction.h
Message-ID: <20080108181029.GY23661@sgi.com>
References: <20080108023559.GQ23661@sgi.com> <20080108085831.GA27671@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108085831.GA27671@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 09:58:31AM +0100, Ingo Molnar wrote:
> 
> * akepner@sgi.com <akepner@sgi.com> wrote:
> 
> > +enum dma_data_attr {
> > +	DMA_ATTR_BARRIER = (1 << 0),
> > +	DMA_ATTR_FOO = (1 << 1),
> > +	DMA_ATTR_GOO = (1 << 2),
> > +	DMA_ATTR_MAX = (1 << 3),
> > +};
> 
> FOO/GOO we dont need i guess ...

Right. That's example GOO ;-)

> 
> > +#define DMA_FLAGS_ATTR_SHIFT	8
> > +#define DMA_FLAGS_DIR_MASK	((1 << DMA_FLAGS_ATTR_SHIFT) - 1)
> > +#define DMA_FLAGS_ATTR_MASK	~DMA_FLAGS_DIR_MASK
> > +
> > +static inline enum dma_data_direction dma_flags_get_dir(u32 fin)
> > +{
> > +	return (fin & DMA_FLAGS_DIR_MASK);
> > +}
> 
> the u32 looks a bit weird. Why not unsigned int ?
> 

unsigned int would be fine with me.

> also, are the new dma_map_*() API compatible with the old one? I.e. does 
> dma_map_*(...,0) and dma_map_*(...,1) map to the right thing? If yes 
> then perhaps dont change 'int direction' to 'u32 flags' at all but just 
> rename 'direction' to 'flags' and be done with it.
>

Yes, the callers don't necessarily need to be modified. Callers 
of dma_map_* would only need to be changed if they want to pass 
some additional attribute(s).
 
> also, this conversion:
> 
> +       enum dma_data_direction direction = dma_flags_get_dir(flags);
> 
> would be unnecessary if callers passed in the bitmap already, instead of 
> 'flags'. 0 and 1 would still map to the right thing i think.
> 

Right, but if the caller *had* passed some optional attribute, we 
probably want to strip it off (and either use it or ignore it, as 
appropriate.)

-- 
Arthur

