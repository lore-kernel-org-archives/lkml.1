Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbYLAP7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbYLAP7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 10:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYLAP7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 10:59:24 -0500
Received: from sh.osrg.net ([192.16.179.4]:60726 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbYLAP7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 10:59:23 -0500
Date: Tue, 2 Dec 2008 00:58:29 +0900
To: avi@redhat.com
Cc: joro@8bytes.org, fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com,
       kvm@vger.kernel.org, weidong.han@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, amit.shah@redhat.com
Subject: Re: [PATCH 3/9] add frontend implementation for the IOMMU API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4933F5A7.8020408@redhat.com>
References: <20081201231852P.fujita.tomonori@lab.ntt.co.jp>
	<20081201142727.GL29705@8bytes.org>
	<4933F5A7.8020408@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081202005830P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2008 16:33:11 +0200
Avi Kivity <avi@redhat.com> wrote:

> Joerg Roedel wrote:
> > Hmm, is there any hardware IOMMU with which we can't emulate domains by
> > partitioning the IO address space? This concept works for GART and
> > Calgary.
> >
> >   
> 
> Is partitioning secure?  Domain X's user could program its hardware to 
> dma to domain Y's addresses, zapping away Domain Y's user's memory.

It can't be secure. So what's the point to emulate the domain
partitioning in many traditional hardware IOMMUs that doesn't support
it.

The emulated domain support with the DMA mapping debugging feature
might be useful to debug drivers but it doesn't mean that we need to
add the emulated domain support to every hardware IOMMU. If you add it
to swiotlb, everyone can enjoy the debugging.
