Return-Path: <linux-kernel-owner+w=401wt.eu-S1756667AbYAIVH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667AbYAIVH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYAIVHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:07:12 -0500
Received: from relay1.sgi.com ([192.48.171.29]:33375 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752755AbYAIVHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:07:10 -0500
From: akepner@sgi.com
Date: Wed, 9 Jan 2008 13:05:42 -0800
To: Roland Dreier <rdreier@cisco.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PARTIAL PATCH 0/3] dma: passing "attributes" to dma_map_* routines
Message-ID: <20080109210542.GP23661@sgi.com>
References: <20080108023222.GP23661@sgi.com> <1199809628.3534.34.camel@localhost.localdomain> <ada63y4kycs.fsf@cisco.com> <1199814853.3534.39.camel@localhost.localdomain> <adawsqkjipz.fsf@cisco.com> <1199816504.3534.59.camel@localhost.localdomain> <adaprwa7lzd.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaprwa7lzd.fsf@cisco.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 01:00:38PM -0800, Roland Dreier wrote:
> .....
> The reason this hasn't been an issue until now is that almost all
> drivers work correctly if the Altix code just sets the "flush" bit for
> memory allocated via the consistent/coherent allocators.  However, if
> we want the device to write to userspace memory, this doesn't work
> (and mapping coherent memory allocated in the kernel into userspace is
> a mess on other platforms, because it unnecessarily consumes lowmem
> and/or kernel address space).
> 

And the only way that user level CQs work on Altix now is 
that we apply our own patches to allocate them in the 
kernel (with dma_alloc_coherent()) them mmap() them back 
to user space. A bug in one of these patches recently led  
to considerable drama with several customers - I'd love 
to get a fix in mainline so we can drop our patches and 
avoid the possibility such theatrics in the future ;-)

-- 
Arthur

