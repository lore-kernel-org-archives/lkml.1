Return-Path: <linux-kernel-owner+w=401wt.eu-S1760108AbXFSXee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbXFSXee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756950AbXFSXe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:34:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49054 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756919AbXFSXe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:34:26 -0400
Date: Tue, 19 Jun 2007 16:34:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Arjan van de Ven <arjan@linux.intel.com>
cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures in dma map
 api calls
In-Reply-To: <46786668.6050507@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0706191632380.15951@schroedinger.engr.sgi.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
 <20070619213808.798646000@askeshav-devel.jf.intel.com>
 <Pine.LNX.4.64.0706191624110.15951@schroedinger.engr.sgi.com>
 <46786668.6050507@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Arjan van de Ven wrote:

> > Otherwise you are locked into the use of GFP_ATOMIC.
> 
> all callers pretty much are either in irq context or with spinlocks held. Good
> luck..... it's also called primarily from the PCI DMA API which doesn't take a
> gfp_t argument in the first place...
> 
> so I'm not seeing the point.

Hmmm... From my superficial look at things it seems that one could avoid 
GFP_ATOMIC at times. I do not know too much about the driver though but it 
seems a bit restrictive to always do GFP_ATOMIC allocs.

