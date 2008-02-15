Return-Path: <linux-kernel-owner+w=401wt.eu-S1760647AbYBOM5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbYBOM5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYBOM4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:56:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37586 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbYBOM4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:56:53 -0500
Date: Fri, 15 Feb 2008 14:32:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>,
       Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [RFC][PATCH] modular kgdb-light (was: Re: [git pull] kgdb-light -v10)
Message-ID: <20080215133238.GA28942@one.firstfloor.org>
References: <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org> <20080212152846.GC3078@elte.hu> <20080212161152.GA3281@one.firstfloor.org> <alpine.LFD.1.00.0802120811010.2920@woody.linux-foundation.org> <20080212170711.GB4191@one.firstfloor.org> <47B58718.9020105@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B58718.9020105@siemens.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 01:35:36PM +0100, Jan Kiszka wrote:
> Andi Kleen wrote:
> >> This includes things like having "breakpoint reservations" (discussed 
> >> earlier) and just generally trying to add lots of infrastructure to make 
> >> kgdb "fit in" to the kernel.
> > 
> > I think that part is actually mostly ok now (old kgdb stubs were
> > much worse in this regard) 
> > 
> > I still think the ultimative proof for this would be working
> > "modprobe kgdb" though.
> 
> To pick up this idea again I did the experimental patch below. It
> applies against Jason's latest kgdb-light patch queue:

Very nice! If it's that simple then the kgdb integration is really
clean.

> 
> http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=for_ingo
> 
> The patch nicely demonstrates what deeper dependencies on kernel
> services currently exist in kgdb-light. The following symbols were
> unresolvable:
> 

Some comments on the specific patch:

>  o genapic - for send_IPI_allbutself, ie. CPU roundup

I would rather export some generic wrapper for that than the full genapic
structure.

>  o machine_emergency_restart - for implementing "R0" gdb packet

Hmm, might be a bit dangerous to call this directly -- there are various
quirks with e.g. not rebooting on CPU #0 and not resetting APIC 
state. But ok [this is not directly related to the fact that it's
exported now, just mentioning this in general]

-Andi

