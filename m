Return-Path: <linux-kernel-owner+w=401wt.eu-S932404AbYECRkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbYECRkz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYECRkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:40:43 -0400
Received: from www.tglx.de ([62.245.132.106]:46766 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbYECRkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:40:42 -0400
Date: Sat, 3 May 2008 19:39:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: jamal <hadi@cyberus.ca>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
In-Reply-To: <20080503173402.GA5292@elte.hu>
Message-ID: <alpine.LFD.1.10.0805031936510.6003@apollo.tec.linutronix.de>
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <1209834123.6972.48.camel@localhost> <20080503173402.GA5292@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, Ingo Molnar wrote:
> * jamal <hadi@cyberus.ca> wrote:
> 
> > > we have:
> > > #define P6_NOP3 ".byte 0x0f,0x1f,0x00\n"
> > 
> > Dang - I feel i should have saved myself all that git bisecting
> > and just posted the oops ;->
> 
> your bisection was still very useful - it pinpointed the NOPs - the 
> assembly code around the NOP changed so a different length NOP was 
> patched in => which did not work on your CPU. So thanks for that! The 
> fix is already in x86.git (we'll update the commit log).
> 
> > > So the alternatives code applies the wrong nop padding for your CPU. 
> > > This was probably introduced with commit 
> > > 32c464f5d9701db45bc1673288594e664065388e.
> > > 
> > > Jan, are you sure that P3 knows the P6 NOPs ? AFAICT its P4, but I 
> > > have to dig up the manuals.
> > > 
> > > Jamal, does the following patch solve your problem ?
> > 
> > Indeed it does - thanks.
> 
> great. So this NOP is indeed not generally known to all "P6 and later" 
> CPUs. (the PII)

Looks like. My analysis was wrong, as I got the P6 vs. PII/PIII
confused :) Damn unintutive numbering, I thought ARM is worse but I'm
not so sure anymore.

But the oops clearly identified that instruction sequence. So for now
we remove the X86_FEATURE_P3 -> P6_NOPS to be on the safe side.

Thanks,
	tglx
