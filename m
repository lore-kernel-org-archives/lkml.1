Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbYDUXJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbYDUXJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYDUXI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:08:59 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56069 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319AbYDUXI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:08:58 -0400
Subject: Re: Voyager phys_cpu_present_map compile error
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Adrian Bunk <bunk@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080421200330.GJ8770@elte.hu>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi>
	 <20080421085314.GI26897@cs181133002.pp.htv.fi>
	 <20080421120054.GA6788@elte.hu> <480C8FD6.3030700@zytor.com>
	 <1208792559.3640.20.camel@localhost.localdomain>
	 <20080421200330.GJ8770@elte.hu>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 18:08:52 -0500
Message-Id: <1208819332.3640.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-21 at 22:03 +0200, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > > > i ended up excluding Voyager configs from our test space some time 
> > > > ago (and VISWS as well - there's one more visws fix in x86.git), 
> > > > that's how this broke. These subarchitectures seem not to be used 
> > > > at all and the code wont boot on normal PCs. We could mark it 
> > > > BROKEN but the fix seems simple in any case.
> > 
> > I did actually try to avoid these problems by booting the -mc tree on 
> > voyager, but I note that none of these issues showed up in that tree 
> > the last time I did this (admittedly about 3 weeks ago because of 
> > various conferences etc).
> 
> btw., any chance to turn it into a quirk space thing? Voyagers are 
> almost-PCs, right? Most of the Voyager specialities appears to be 
> abstracted away already via smp_ops. I.e. we could have Voyager support 
> in a plain x86 kernel, if CONFIG_X86_VOYAGER is turned on.

Almost, but not quite.  Voyager needs some clickmap work on boot.
However, it should be possible to separate quite a bit of stuff out
using smp ops.

Voyager isn't at all like a PC, I'm afraid.  It's an old unix system
that can emulate a uniprocessor PC when necessary.  The voyager SMP
stuff is incredibly non-PC like, when you get into it.

The boot path for a combined architecture would be boot as PC (UP) and
then detect voyager do the clickmap setup and flip SMP ops before
bringing up the CPUs.  I can think about this for one or two kernel
release cycles down the road.

> quirks we can let survive almost forever - we've still got the math-emu 
> code for example. It's the subarch code we'd like to eliminate 
> eventually. (there are much better abstractions for achieving the same 
> thing: quirks and the genapic code)
> 
> OTOH, i just had a look at it, and it seems a rather special thing - it 
> tries to do like a PC but without actually being a PC. Almost as if it 
> had no or just a little bit of BIOS - the whole Voyager kernel seems to 
> run on the bare metal. Not much point in upsetting that code base i 
> suspect.

It has no bios ... it has something called SUS (Start Up System); it's
actually a RTOS running on a separate 386 processor on the motherboard
to configure things.  SUS can emulate some bios calls, but not very
many.  The BIOS it emulates is an old one, which is why it gets swept
out of the way to configure "advanced" things (like up to 4GB memory).

> let us know if you run into any difficulties with making it to boot 
> again ... nothing truly fundamental should have changed to break it, 
> other that this moving around of SMP code.

It's not actually booting at the moment.  It looks like some issue in
smp_cpus_done.

James


