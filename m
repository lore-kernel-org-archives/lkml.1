Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbYAHI73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbYAHI73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbYAHI7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:59:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38970 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbYAHI7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:59:20 -0500
Date: Tue, 8 Jan 2008 09:58:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: akepner@sgi.com
Cc: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 1/3] dma: create linux/dma-direction.h
Message-ID: <20080108085831.GA27671@elte.hu>
References: <20080108023559.GQ23661@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108023559.GQ23661@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* akepner@sgi.com <akepner@sgi.com> wrote:

> +enum dma_data_attr {
> +	DMA_ATTR_BARRIER = (1 << 0),
> +	DMA_ATTR_FOO = (1 << 1),
> +	DMA_ATTR_GOO = (1 << 2),
> +	DMA_ATTR_MAX = (1 << 3),
> +};

FOO/GOO we dont need i guess ...

> +#define DMA_FLAGS_ATTR_SHIFT	8
> +#define DMA_FLAGS_DIR_MASK	((1 << DMA_FLAGS_ATTR_SHIFT) - 1)
> +#define DMA_FLAGS_ATTR_MASK	~DMA_FLAGS_DIR_MASK
> +
> +static inline enum dma_data_direction dma_flags_get_dir(u32 fin)
> +{
> +	return (fin & DMA_FLAGS_DIR_MASK);
> +}

the u32 looks a bit weird. Why not unsigned int ?

also, are the new dma_map_*() API compatible with the old one? I.e. does 
dma_map_*(...,0) and dma_map_*(...,1) map to the right thing? If yes 
then perhaps dont change 'int direction' to 'u32 flags' at all but just 
rename 'direction' to 'flags' and be done with it.

also, this conversion:

+       enum dma_data_direction direction = dma_flags_get_dir(flags);

would be unnecessary if callers passed in the bitmap already, instead of 
'flags'. 0 and 1 would still map to the right thing i think.

	Ingo
