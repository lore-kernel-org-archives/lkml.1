Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYGaCPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYGaCPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYGaCPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:15:32 -0400
Received: from sh.osrg.net ([192.16.179.4]:57241 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbYGaCPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:15:31 -0400
Date: Thu, 31 Jul 2008 11:07:49 +0900
To: benh@kernel.crashing.org
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au,
       davem@davemloft.net, mingo@elte.hu, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       robert.richter@amd.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1217457854.11188.348.camel@pasglop>
References: <20080729185838W.fujita.tomonori@lab.ntt.co.jp>
	<20080729100233.GB4851@amd.com>
	<1217457854.11188.348.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080731110649G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008 08:44:14 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2008-07-29 at 12:02 +0200, Joerg Roedel wrote:
> > On Tue, Jul 29, 2008 at 06:58:08PM +0900, FUJITA Tomonori wrote:
> > > On Tue, 29 Jul 2008 11:50:27 +0200
> > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > > do you want to work on that or should I try to do this and send it to
> > > > you for review?
> > > 
> > > I've already sent a patch that fixes the breakages in such way:
> > > 
> > > http://marc.info/?l=linux-kernel&m=121730644704448&w=2
> > 
> > Yes I have seen this patch. I meant the patches that introduce something
> > like IOMMU_PAGE_SIZE for all architectures so that we can make this
> > function generic and move it back to lib/.
> 
> That will not work in the light of some new stuff coming on powerpc in
> the future. The iommu page size may/will be dynamic per instance of
> iommu. IE, it will be mostly decided at runtime, I don't expect machines
> to have multiple iommus of different page sizes off hand but it -can-
> happen.

You could do something like this:

#define IOMMU_PAGE_SIZE	power_iommu_page_size

But I prefer the current proposal to have the size as an argument.
