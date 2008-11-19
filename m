Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYKSHFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYKSHFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 02:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYKSHF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 02:05:26 -0500
Received: from sh.osrg.net ([192.16.179.4]:35849 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbYKSHFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 02:05:25 -0500
Date: Wed, 19 Nov 2008 16:05:07 +0900
To: leon.woestenberg@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       James.Bottomley@hansenpartnership.com, tj@kernel.org
Subject: Re: pci_map_sg() does not coalesce adjacent physical memory? x86
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081119155847U.fujita.tomonori@lab.ntt.co.jp>
References: <20081119142016E.fujita.tomonori@lab.ntt.co.jp>
	<c384c5ea0811182222l7f0e3131tc1cc20ffba5175c@mail.gmail.com>
	<20081119155847U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081119160547G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, sorry about typos.

On Wed, 19 Nov 2008 15:58:12 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > Of course, I could write my own (tm) and map my pages into PCI using
> > pci_map_single, but I thought I was being the good kid by using what
> > was there.
> 
> I don't think it's not a good place. What pci_map_single should do is
> mapping a virtual address to a dma-capable address.
> 
> IOMMU dma operations maps a virtual address to an I/O address and
> non-IOMMU dma operations do nothing. As you said below, some IOMMU
> operations do coalescing but it's virtual mapping (probably their code
                                    virtual coalescing

> can handle physical coalescing too though but the block layer does
> physical coalescing before that though). And the virtual mapping is
                                                   virtual coalescing

> optional. Not all the IOMMU operations do. As I said, x86 IOMMUs
> (VT-d, AMD, and Calgary) except for GART does not do coalescing. Any
> non-IOMMU dma operations don't do something complicated.
