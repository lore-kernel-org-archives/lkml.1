Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbXJCRwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbXJCRwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758429AbXJCRwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:52:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51888 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757098AbXJCRwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:52:12 -0400
From: akepner@sgi.com
Date: Wed, 3 Oct 2007 10:51:12 -0700
To: David Miller <davem@davemloft.net>
Cc: grundler@parisc-linux.org, jbarnes@virtuousgeek.org, jes@sgi.com,
       randy.dunlap@oracle.com, rdreier@cisco.com,
       James.Bottomley@steeleye.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] infiniband: add "dmabarrier" argument to ib_umem_get()
Message-ID: <20071003175112.GP26752@sgi.com>
References: <20071003024906.GI26752@sgi.com> <20071002.201023.85411373.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002.201023.85411373.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 08:10:23PM -0700, David Miller wrote:
> From: akepner@sgi.com
> Date: Tue, 2 Oct 2007 19:49:06 -0700
> 
> > 
> > Pass a "dmabarrier" argument to ib_umem_get() and use the new 
> > argument to control setting the DMA_BARRIER_ATTR attribute on 
> > the memory that ib_umem_get() maps for DMA.
> > 
> > Signed-off-by: Arthur Kepner <akepner@sgi.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> 
> However I'm a little unhappy with how IA64 achieves this.
> 
> The last argument for dma_map_foo() is an enum not an int,
> every platform other than IA64 properly defines the last
> argument as "enum dma_data_direction".  It can take one
> of several distinct values, it is not a mask.
> 
> This hijacking of the DMA direction argument is hokey at
> best, and at worst is type bypassing which is going to
> explode subtly for someone in the future and result in
> a long painful debugging session.
> ....

I don't dispute your point about abusing the enum here, it 
just seemed the least objectionable, and most expedient way 
to go.  But I'll add that ia64 isn't alone, x86_64 also uses 
an int for the final argument to its dma_map_* implementations.

-- 
Arthur

