Return-Path: <linux-kernel-owner+w=401wt.eu-S1761815AbYG3NRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761815AbYG3NRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 09:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbYG3NRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 09:17:16 -0400
Received: from sh.osrg.net ([192.16.179.4]:39703 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbYG3NRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:17:16 -0400
Date: Wed, 30 Jul 2008 22:16:05 +0900
To: joerg.roedel@amd.com
Cc: davem@davemloft.net, sfr@canb.auug.org.au, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, robert.richter@amd.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jbarnes@virtuousgeek.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] add iommu_num_pages helper function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080730121805.GM4851@amd.com>
References: <20080729095027.GA4851@amd.com>
	<20080729.031005.203132019.davem@davemloft.net>
	<20080730121805.GM4851@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080730221540S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 14:18:05 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Tue, Jul 29, 2008 at 03:10:05AM -0700, David Miller wrote:
> > From: Joerg Roedel <joerg.roedel@amd.com>
> > Date: Tue, 29 Jul 2008 11:50:27 +0200
> > 
> > > I think moving that function to x86-only code is the best solution for
> > > now. Before moving it back to generic code we need an architecture
> > > independent way to find out the IOMMU page size.
> > 
> > My suggestion (again) is to pass it in as a "const unsigned long
> > io_page_size" argument and update the callers.
> 
> Ok, after setting up cross compile environments for sparc64 and
> powerpc64 I wrote a patch which adds the io_page_size argument to the
> iommu_num pages function and moves the function back to
> lib/iommu-helper.c.

You need ia64, parisc, and alpha too. :) 

I have cross compile environments for them so I can take care of them
if you like.


> The patch touches all 3 architectures and can not be
> split in a bisectable way.

How about naming a new helper function iommu_nr_pages (or something)?

Then you can do the conversion independently. If we like, we use
iommu_num_pages name after the conversion.


> Who is the best person to send this patch to?

The -mm is an appropriate tree, I think.
