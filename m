Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYKZTYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYKZTYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbYKZTYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:24:09 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58066 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYKZTYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:24:08 -0500
Date: Wed, 26 Nov 2008 20:34:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [patch 23/24] perfmon: kernel documentation
Message-ID: <20081126193429.GC6703@one.firstfloor.org>
References: <492d0c14.02225e0a.15ab.6f8e@mx.google.com> <20081126122107.GV6703@one.firstfloor.org> <7c86c4470811261021t5a7da650w95c30a71838172c4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811261021t5a7da650w95c30a71838172c4@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 07:21:56PM +0100, stephane eranian wrote:
> Andi,
> 
> On Wed, Nov 26, 2008 at 1:21 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > On Wed, Nov 26, 2008 at 12:43:00AM -0800, eranian@googlemail.com wrote:
> >
> > I assume you'll be also submitting manpages with the same information?
> >
> This is on my TODO list. Provide a man page for each new syscall.

There should be a overview manpage as well.

> I have never played with that myself, even with regular file
> descriptors. But I can only
> assume passing a file descriptor increments its refcount. Thus you
> simply get another
> controlling process. There is enough context locking in place in the
> kernel to make this
> work.

Ok as long as it isn't a root hole or similar.

> > ...
> >
> > Some simple syscall examples would be nice. e.g. how to set up a counter
> > that it can be accessed using RDPMC on x86.
> 
> I can add this. But why go straight to RDPMC. Most people would want to use
> the syscall instead?

On recent Intel x86 a common simple useful case is to just use RDPMC
with one of the fixed counters, especially the unscaled cycle counter.
The only change needed here is to set the CR bit.

> > to let a driver patch for that adjust it.
> >
> It depends on the number of registers available. It is expected that most tools
> will want to use one call to program the config registers and one to program
> the data registers. Pfmon is able to split vectors according to arg_mem_max.
> 
> It is anticipated that newer processors will increase the number of available
> PMU registers. That was the case with Barcelona with the addition of IBS.
> On Intel X86, I am planning on exposing the LBR as part of the PMU registers.
> 
>  On Itanium, you already have 35 data and 27 config registers.

That is still far less than a 4K page. Also 4K worth of registers would
be a lot. I doubt that will be hit anytime soon.

> 
> But I think your suggestion is interesting. When we "register" the new PMU
> mapping table, we can provide a minimal size to fit all PMC or all PMD registers
> in one call. That would remove a control point for the sysadmin, though.

I don't think the sysadmin wants to really know about that.

-Andi
> 

-- 
ak@linux.intel.com
