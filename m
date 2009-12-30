Return-Path: <linux-kernel-owner+w=401wt.eu-S1751842AbZL3PgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbZL3PgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 10:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbZL3PgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 10:36:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:49013 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZL3PgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 10:36:11 -0500
Subject: Re: ACPI warning from alloc_pages_nodemask on boot (2.6.33 
 regression)
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Len Brown <lenb@kernel.org>, Stephen Hemminger <shemminger@vyatta.com>,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <2f11576a0912292221r7ba59e9dw431c7b43b578a04@mail.gmail.com>
References: <20091229094202.25818e9b@nehalam>
	 <alpine.LFD.2.00.0912291435070.14938@localhost.localdomain>
	 <2f11576a0912292221r7ba59e9dw431c7b43b578a04@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Dec 2009 16:35:44 +0100
Message-ID: <1262187344.7135.230.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-30 at 15:21 +0900, KOSAKI Motohiro wrote:
> >> [    1.630020] ------------[ cut here ]------------
> >> [    1.630026] WARNING: at mm/page_alloc.c:1812 __alloc_pages_nodemask+0x617/0x730()
> >
> >        if (order >= MAX_ORDER) {
> >                WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
> >                return NULL;
> >        }
> >
> > I don't know what the mm alloc code is complaining about here.

> >> [    1.630028] Hardware name: System Product Name
> >> [    1.630029] Modules linked in:
> >> [    1.630032] Pid: 1, comm: swapper Not tainted 2.6.33-rc2 #4
> >> [    1.630034] Call Trace:

> >> [    1.630064]  [<ffffffff812cae3e>] acpi_os_allocate+0x25/0x27 

Right, so ACPI is trying to allocate something larger than 2^MAX_ORDER
pages, which on x86 computes to 4K * 2^11 = 8M.

That's not going to work.

Did this machine properly boot before? I seem to remember people working
on moving away from bootmem and getting th page/slab stuff up and
running sooner, it might be fallout from that...

