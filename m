Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbXFTBKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbXFTBKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 21:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbXFTBKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 21:10:42 -0400
Received: from c-71-193-194-8.hsd1.or.comcast.net ([71.193.194.8]:56316 "EHLO
	laptopd505.fenrus.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756855AbXFTBKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 21:10:41 -0400
X-Greylist: delayed 3882 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 21:10:40 EDT
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures in dma
	map api calls
From: Arjan van de Ven <arjan@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, suresh.b.siddha@intel.com,
       ashok.raj@intel.com, davem@davemloft.net
In-Reply-To: <Pine.LNX.4.64.0706191632380.15951@schroedinger.engr.sgi.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	 <20070619213808.798646000@askeshav-devel.jf.intel.com>
	 <Pine.LNX.4.64.0706191624110.15951@schroedinger.engr.sgi.com>
	 <46786668.6050507@linux.intel.com>
	 <Pine.LNX.4.64.0706191632380.15951@schroedinger.engr.sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 19 Jun 2007 17:02:34 -0700
Message-Id: <1182297754.2700.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 16:34 -0700, Christoph Lameter wrote:
> On Tue, 19 Jun 2007, Arjan van de Ven wrote:
> 
> > > Otherwise you are locked into the use of GFP_ATOMIC.
> > 
> > all callers pretty much are either in irq context or with spinlocks held. Good
> > luck..... it's also called primarily from the PCI DMA API which doesn't take a
> > gfp_t argument in the first place...
> > 
> > so I'm not seeing the point.
> 
> Hmmm... From my superficial look at things it seems that one could avoid 
> GFP_ATOMIC at times. 

by changing ALL drivers. And then you realize the common scenario is
that it's taken in irq context ;)

> I do not know too much about the driver though but it 
> seems a bit restrictive to always do GFP_ATOMIC allocs.

the only alternative to GFP_ATOMIC is GFP_NOIO which is... barely
better. And then add that it can be used only sporadic...
feel free to first change all the drivers.. once the callers of these
functions have a gfp_t then I'm sure Anil will be happy to take one of
those as well ;-)

