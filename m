Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbYBHMpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbYBHMpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 07:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbYBHMpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 07:45:25 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50422 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbYBHMpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 07:45:25 -0500
Date: Fri, 8 Feb 2008 14:20:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1/2] kmemcheck v3
Message-ID: <20080208132032.GA6115@one.firstfloor.org>
References: <47AB79D4.2070605@gmail.com> <20080208115542.GD4745@one.firstfloor.org> <19f34abd0802080418o75969480v3286da7a83ebc178@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0802080418o75969480v3286da7a83ebc178@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 01:18:37PM +0100, Vegard Nossum wrote:
> On 2/8/08, Andi Kleen <andi@firstfloor.org> wrote:
> > Your assumption that only the string instructions can take
> > multiple page faults seems a little dangerous too.
> 
> Yes, this is true. I cannot guarantee that there are no other
> instructions that could access more than one memory location but only
> take one page fault. However, since the kernel does boot, we at least
> know that these instructions are not very frequently used. (If you
> know of any other instructions we might be missing, I'll be happy to
> know about it!)

Pretty much all in the right circumstances.

e.g. consider a segment reload in tracked memory.

Also there are various instructions which do all kinds of complicated
things internally; like IRET or INT: often with many memory accesses.
Just page through a instruction manual and look at the pseudo code
describing what the various instructions do.

> 
> There is also the point that if kmemcheck doesn't handle all the
> faulting addresses, it will simply fault again and again, without
> making any progress. I mean, it won't go unnoticed for very long :-)
> 
> This is also why we depend on M386 and !X86_GENERIC, to avoid those
> MMX, etc. instructions, as we have no support for those currently

I would not expect problems from MMX/SSE here (except for the generic
ones all instructions have) 

-Andi

