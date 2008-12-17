Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757918AbYLQQ4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbYLQQ4i (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYLQQ41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:56:27 -0500
Received: from sh.osrg.net ([192.16.179.4]:40156 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbYLQQ40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:56:26 -0500
Date: Thu, 18 Dec 2008 01:56:01 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
        jbeulich@novell.com, joerg.roedel@amd.com
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
 of swiotlb
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4949296F.7000701@goop.org>
References: <20081216203513.GA14787@elte.hu>
	<20081217142637V.fujita.tomonori@lab.ntt.co.jp>
	<4949296F.7000701@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081218015705Z.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008 08:31:43 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > I think that the whole patchset is against the swiotlb design. swiotlb
> > is designed to be used as a library. Each architecture implements the
> > own swiotlb by using swiotlb library
> > (e.g. arch/x86/kernel/pci-swiotlb_64.c).
> >   
> 
> The whole patchset?  The bulk of the changes to lib/swiotlb.c are 
> relatively minor to remove the unwarranted assumptions it is making in 
> the face of a new user.  They will have no effect on other existing 
> users, including non-Xen x86 builds.
> 
> If you have specific objections we can discuss those, but I don't think 
> there's anything fundamentally wrong with making lib/swiotlb.c a bit 
> more generically useful.

Sorry, but the highmem support is not generically useful.

I'm especially against the highmem support. As you said, the rest
looks fine but if you go with pci-swiotlb_32.c, I think that you don't
need the most of them.


> > For example, adding the following code (9/14) for just Xen that the
> > majority of swiotbl users (x86_64 and IA64) don't need to the library
> > is against the design.
> >   
> 
> If the architecture doesn't support highmem then this code will compile 
> to nothing - PageHighMem() will always evaluate to 0.  It will therefore 

I'm not talking about it will be complied or not. As I wrote in
another mail, I'm talking about the maintainability and readability of
the common library.


> have zero effect on the code generated for IA64 or x86-64.  This is not 
> really a Xen-specific change, but a result of adding swiotlb support for 
> i386.  Other architectures which support a notion of highmem would also 
> need this code if they wanted to use swiotlb.

Can you be more specific? What architecture is plan to use highmem
support in swiotlb?
