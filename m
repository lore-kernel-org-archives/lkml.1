Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbYIVSkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbYIVSkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYIVSkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:40:10 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:65261 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYIVSkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:40:07 -0400
X-BigFish: VPS-34(zz1432R98dR1805M179dR936fQ873fnzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K7M163-03-4FD-01
Date: Mon, 22 Sep 2008 20:39:44 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Amit Shah <amit.shah@qumranet.com>,
       Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/9][RFC] stackable dma_ops for x86
Message-ID: <20080922183944.GJ24392@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <20080922113619.5075e7e4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080922113619.5075e7e4@infradead.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Sep 2008 18:39:45.0029 (UTC) FILETIME=[95545B50:01C91CE2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 11:36:19AM -0700, Arjan van de Ven wrote:
> On Mon, 22 Sep 2008 20:21:12 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Hi,
> > 
> > this patch series implements stackable dma_ops on x86. This is useful
> > to be able to fall back to a different dma_ops implementation if one
> > can not handle a particular device (as necessary for example with
> > paravirtualized device passthrough or if a hardware IOMMU only
> > handles a subset of available devices).
> 
> isn't the right answer here to have a per device DMA ops instead ?

Its implemented using the per-device dma-ops already there. With this
patches there is a list of available dma_ops implementations which are
asked in a particular order if they can handle the device. The first
implementation which returns true is assigned to the device as the
per-device dma_ops structure.

(Hmm, maybe the name stackable is misleading, is "dma_ops multiplexing"
 better?)

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

