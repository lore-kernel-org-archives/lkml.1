Return-Path: <linux-kernel-owner+w=401wt.eu-S1762261AbYBHLfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762261AbYBHLfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 06:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbYBHLfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 06:35:07 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46493 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYBHLfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 06:35:05 -0500
Date: Fri, 8 Feb 2008 13:10:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andi Kleen <andi@firstfloor.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Richard Knutsson <ricknu-0@student.ltu.se>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/2] kmemcheck v3
Message-ID: <20080208121012.GF4745@one.firstfloor.org>
References: <47AB79D4.2070605@gmail.com> <20080208115542.GD4745@one.firstfloor.org> <84144f020802080331j5bc01bc6naf1fe0192aadf70b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020802080331j5bc01bc6naf1fe0192aadf70b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 01:31:44PM +0200, Pekka Enberg wrote:
> Hi Andi,
> 
> On Feb 8, 2008 1:55 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Impressive patch! On the other hand a lot of the interesting
> > data isn't it kmalloc anymore, but in slab. Does it really track
> > all that much?
> 
> It tracks all slab caches. What we're not tracking is pages from the

I see.

> page allocator that are directly used by callers. We had some
> discussion of this already and we definitely want to extend it to
> cover that too later on.

It's probably tricky; there are all kinds of hidden page faults
on x86 on data structures allocated as pages (e.g. GDT, LDT [which
is sometimes kmalloc too], stack etc.) 

-Andi
