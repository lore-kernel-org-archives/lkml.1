Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbYLSWPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbYLSWPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYLSWPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:15:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbYLSWPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:15:01 -0500
Date: Fri, 19 Dec 2008 14:14:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: penberg@cs.helsinki.fi, catalin.marinas@arm.com,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 01/14] kmemleak: Add the base support
Message-Id: <20081219141400.314023db.akpm@linux-foundation.org>
In-Reply-To: <20081219220255.GJ2351@elte.hu>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	<20081219181302.7778.15966.stgit@pc1117.cambridge.arm.com>
	<84144f020812191208x66f26bc9tf087b35b6c90662a@mail.gmail.com>
	<20081219220255.GJ2351@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 23:02:55 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
> > On Fri, Dec 19, 2008 at 8:13 PM, Catalin Marinas
> > <catalin.marinas@arm.com> wrote:
> > > This patch adds the base support for the kernel memory leak
> > > detector. It traces the memory allocation/freeing in a way similar to
> > > the Boehm's conservative garbage collector, the difference being that
> > > the unreferenced objects are not freed but only shown in
> > > /sys/kernel/debug/kmemleak. Enabling this feature introduces an
> > > overhead to memory allocations.
> > >
> > > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Looks good to me. I have only reviewed this lightly but all my major 
> > concerns have been addressed so feel free to add my:
> > 
> > Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Andrew, do you have any principial objections against having this in 

Nope.

> v2.6.29?

That might be a bit harder.  I'll take a look.

> This dragged on for a long time, and i think the debug output is useful 
> and it tells us something that we have no other tool for at the moment to 
> figure out. We can tell stuck tasks, stuck files and other stuck resources 
> easily - we can even see fast slab leaks, but we cannot really tell slow, 
> long-term slab leaks apart from regular slab prints, and we cannot 
> identify the source of them. The false positive rate of kmemleak has 
> decreased substantially as well, over the earlier design.

Sounds good, thanks.
