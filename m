Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbZEHHpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbZEHHpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 03:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbZEHHpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 03:45:42 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:49618 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbZEHHpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 03:45:41 -0400
Message-Id: <4A03FF94.76EA.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 08 May 2009 08:47:00 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/9] xen: make sure swiotlb allocation
	 isphysically contigious
References: <1241741842-7966-1-git-send-email-jeremy@goop.org>
 <1241741842-7966-2-git-send-email-jeremy@goop.org>
In-Reply-To: <1241741842-7966-2-git-send-email-jeremy@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 08.05.09 02:17 >>>
>Impact: make swiotlb allocation suitable for Xen
>
>When allocating the swiotlb buffer under Xen, make sure the memory is
>physically contiguous so that its really suitable for DMA.
>
>Do this by allocating the memory as usual, but then call a Xen
>function to rearrange the underlying pages to be physically
>contiguous.

As pointed out before, you must not use alloc_bootmem_low...() here,
as on large systems you may otherwise get an allocation failure (i.e. a
panic - checking the return value is pointless). The alternative is to fix
the bootmem allocator to no longer allocate from bottom up.

Jan

