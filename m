Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbZENMFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbZENMFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 08:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761141AbZENMFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 08:05:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54796 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760721AbZENMFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 08:05:08 -0400
Subject: Re: [PATCH] Physical Memory Management [0/1]
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mm@kvack.org
In-Reply-To: <op.utw4fdhz7p4s8u@amdc030>
References: <op.utu26hq77p4s8u@amdc030>
	 <20090513151142.5d166b92.akpm@linux-foundation.org>
	 <op.utwwmpsf7p4s8u@amdc030> <1242300002.6642.1091.camel@laptop>
	 <op.utw4fdhz7p4s8u@amdc030>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 May 2009 14:05:02 +0200
Message-Id: <1242302702.6642.1140.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 13:48 +0200, Michał Nazarewicz wrote:
> > On Thu, 2009-05-14 at 11:00 +0200, Michał Nazarewicz wrote:
> >>   PMM solves this problem since the buffers are allocated when they
> >>   are needed.
> 
> On Thu, 14 May 2009 13:20:02 +0200, Peter Zijlstra wrote:
> > Ha - only when you actually manage to allocate things. Physically
> > contiguous allocations are exceedingly hard once the machine has been
> > running for a while.
> 
> PMM reserves memory during boot time using alloc_bootmem_low_pages().
> After this is done, it can allocate buffers from reserved pool.
> 
> The idea here is that there are n hardware accelerators, each
> can operate on 1MiB blocks (to simplify assume that's the case).
> However, we know that at most m < n devices will be used at the same
> time so instead of reserving n MiBs of memory we reserve only m MiBs.

And who says your pre-allocated pool won't fragment with repeated PMM
use?



