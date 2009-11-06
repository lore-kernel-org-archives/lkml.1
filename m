Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbZKFBvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbZKFBvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 20:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbZKFBvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 20:51:54 -0500
Received: from sh.osrg.net ([192.16.179.4]:56911 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbZKFBvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 20:51:54 -0500
Date: Fri, 6 Nov 2009 10:50:04 +0900
To: mingo@elte.hu
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, dwmw2@infradead.org, joerg.roedel@amd.com,
       akpm@linux-foundation.org, yinghai@kernel.org,
       torvalds@linux-foundation.org, tj@kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091028074832.GC19402@elte.hu>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20091028074832.GC19402@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091106104931W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 06 Nov 2009 10:50:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009 08:48:32 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > From: Chris Wright <chrisw@sous-sol.org>
> > 
> > Add a new function for freeing bootmem after the bootmem allocator has
> > been released and the unreserved pages given to the page allocator.
> > This allows us to reserve bootmem and then release it if we later
> > discover it was not needed.
> > 
> > Reviewed-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> > ---
> >  include/linux/bootmem.h |    1 +
> >  mm/bootmem.c            |   43 ++++++++++++++++++++++++++++++++++++++-----
> >  2 files changed, 39 insertions(+), 5 deletions(-)
> 
> Hm, we are now further complicating the bootmem model.

Yeah, agreed. But reorganizing the allocator during boot is not
easy. I'll investigate it later on but VT-d people want to fix this
IOMMU issue now. Can we accept this for now?
