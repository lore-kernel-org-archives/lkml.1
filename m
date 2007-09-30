Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbXI3PDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbXI3PDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbXI3PDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:03:37 -0400
Received: from ns.suse.de ([195.135.220.2]:60809 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbXI3PDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:03:36 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [REGRESSION from 2.6.23-rc8] (was: Re: 2.6.23-rc4-mm1 and -rc6-mm1: boot failure on HP nx6325, related to clockevents)
Date: Sun, 30 Sep 2007 17:03:32 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200709231257.12213.rjw@sisk.pl> <200709301158.17823.ak@suse.de> <alpine.LFD.0.9999.0709301542410.3142@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0709301542410.3142@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709301703.32388.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 September 2007 16:06:59 Thomas Gleixner wrote:
> On Sun, 30 Sep 2007, Andi Kleen wrote:
> 
> >>> OK, this explains 2) and 3). I just looked into the code and the logic
> >>> vs. noapictimer on SMP is completely broken.
> >
> > noapictimer really doesn't make any sense on non SMP imho with the old
> > timer architecture. That is why I never bothered to implement it.
> > It's purely a UP hack.
> 
> It does not matter whether it makes sense to you or not. It is a command 
> line option which bricks systems. 

A lot of command line options do that -- if not they would be usually
default or automatically used by the kernel.

> There is neither an explanation in  
> Dokumentation/kernel-parameters.txt nor a check in the code, which 
> disables this completely.

Fair enough. I can add a warning in the Documentation.
 
> It makes a lot of sense even with the existing architecture. Trouble 
> shooting a box, where the local apic timer does not work correctly is not 
> an UP only requirement.

It should not be needed with current systems as far as I know
(see my previous mail) 

> I understand the code quite well. I'm just surprised from time to time by 
> interesting hacks in the so clean x8664 tree.

No hack in this area as far as I know.
 
> > [1]  Or let's call it "I trust all my time to the CPU" and no more southrbridge
> > aka put all eggs in one basket. Given the trends in CPU power saving that
> > is a quite dangerous strategy.
> 
> No, it's not dangerous. 

It definitely caused a lot of problems in the single socket multi core world;
but yes you probably worked around all of them that I'm aware of currently.
What I just objected to was that you complained that the current x86-64
time code -- which works much more conservatively and thus needs less workarounds --
doesn't have all of them. You basically tried to apply the special debugging strategies
for clockevents to the old code and then complained that they don't work.

> We spent quite some time to make the clock events  
> layer flexible enough to handle the current problems and the design allows 
> to add more infrastructure when necessary.

Grand words for relatively simple changes. Anyways as far as I know
even for hypothetical future C2+ capable multi socket systems the current
x86-64 time code should work -- it should automatically select broadcasting.
The only thing it relies on that if there are no multi socket C1E systems
with broken APIC timers. Since that could be only future CPUs anyways
and I haven't seen any indication that of the upcomming CPUs will have
such broken C1.

> The maybe new (mis)features of  
> upcoming CPUs need to be addressed with or without clock events and they 
> need to be done careful and not by random hacks.

Not sure what random hacks you refer to.

-Andi
