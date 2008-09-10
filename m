Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbYIJR0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbYIJR0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 13:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYIJRZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 13:25:53 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:43133 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYIJRZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 13:25:52 -0400
X-BigFish: VPS-24(zz1432R98dR1805M936fQ873fnzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K6ZPQG-04-NMP-01
Date: Wed, 10 Sep 2008 19:25:33 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] x86: avoid unnecessary low zone allocation in AMD IOMMU's alloc_coherent
Message-ID: <20080910172533.GB32286@amd.com>
References: <20080910152918.GD24392@amd.com> <20080911012932D.fujita.tomonori@lab.ntt.co.jp> <20080910170504.GA32286@amd.com> <20080911021457K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080911021457K.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Sep 2008 17:25:33.0104 (UTC) FILETIME=[3AD18300:01C9136A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 02:15:22AM +0900, FUJITA Tomonori wrote:
> On Wed, 10 Sep 2008 19:05:04 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Thu, Sep 11, 2008 at 01:29:54AM +0900, FUJITA Tomonori wrote:
> > > On Wed, 10 Sep 2008 17:29:18 +0200
> > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > > What hacks do you need with __get_free_pages? The memory it returns is
> > > > _always_ aligned at its size.
> > > 
> > > Is it guaranteed (documented somewhere) ?
> > 
> > I don't know if there is a formal definition for it. It is documented in
> > some books about the Linux kernel (I read this in some book the first
> > time). This alignment results from the buddy algorithm the page alloctor
> > uses. You can definitly rely on that.
> 
> I meant, if it's not documented as a guaranteed feature (not just the
> characteristic of the current code), it could change any time.

It will never change. I am sure about this. A lot of code relys on
this like the HugeTLBfs implementations for example. In fact, it may be
possible that the requirement to the dma_alloc_coherent function derive
from this behavior of the Linux page allocator (to not break anything
when the dma api was introduced).

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

