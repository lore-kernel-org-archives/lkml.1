Return-Path: <linux-kernel-owner+w=401wt.eu-S1758218AbYLLCt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbYLLCt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 21:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757632AbYLLCtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 21:49:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757624AbYLLCtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 21:49:17 -0500
Date: Thu, 11 Dec 2008 18:47:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>, yur@emcraft.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Geert.Uytterhoeven@sonycom.com, dhowells@redhat.com, miltonm@bga.com,
       wd@denx.de, dzu@denx.de, yanok@emcraft.com
Subject: Re: [PATCH][v2] fork_init: fix division by zero
Message-Id: <20081211184753.97d0db7a.akpm@linux-foundation.org>
In-Reply-To: <200812121331.34602.nickpiggin@yahoo.com.au>
References: <200812101950.51958.yur@emcraft.com>
	<20081211202800.GQ28946@ZenIV.linux.org.uk>
	<20081211124330.ff9b7483.akpm@linux-foundation.org>
	<200812121331.34602.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 12:31:33 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Friday 12 December 2008 07:43, Andrew Morton wrote:
> > On Thu, 11 Dec 2008 20:28:00 +0000
> 
> > >  Do they actually cross the page boundaries?
> >
> > Some flavours of slab have at times done an order-1 allocation for
> > objects which would fit into an order-0 page (etc) if it looks like
> > that will be beneficial from a packing POV.  I'm unsure whether that
> > still happens - I tried to get it stamped out for reliability reasons.
> 
> Hmph, SLUB uses order-3 allocations for 832 byte sized objects
> by default here (mm struct).

That sucks, but at least it's <= PAGE_ALLOC_COSTLY_ORDER.

It's fortunate that everyone has more than 128GB of memory.
