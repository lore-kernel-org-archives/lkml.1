Return-Path: <linux-kernel-owner+w=401wt.eu-S1767570AbXCIWag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767570AbXCIWag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767571AbXCIWag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:30:36 -0500
Received: from gw.goop.org ([64.81.55.164]:57059 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767570AbXCIWaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:30:35 -0500
Message-ID: <45F1E008.5000000@goop.org>
Date: Fri, 09 Mar 2007 14:30:32 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309210430.GA14905@elte.hu> <20070309212714.GU10574@sequoia.sous-sol.org> <20070309214704.GA20988@elte.hu> <45F1D8D7.9040207@goop.org> <20070309221233.GA24341@elte.hu>
In-Reply-To: <20070309221233.GA24341@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> yep. That's precisely my worry. And it doesnt have to be a 'great' thing 
> - just any random small change in the kernel that makes sense: what is 
> the likelyhood that it cannot be implemented, no matter what amount of 
> insight, paravirt_ops + hyper-ABI emulation hackery, for FoobieVisor, 
> because FoobieVisor messed up its ABI.
>
> that likelyhood is a pure function of how FoobieVisor's hypercall ABI is 
> shaped. Wow! So can you guess where my fixation about not having too 
> many ABIs could possibly originate from? ;-)
>   

OK, so its a problem that's happened before.  "It's a great idea, it's
so nice, but it breaks X."  Your options are:

   1. Well, nobody is really using X.  We can stop supporting it.
   2. X makes up 50% of the users, we'll just have to do without your
      great idea.
   3. Maybe we can get X updated so this idea works.

If X is a piece of hardware, then you're probably stuck with options 1
and 2.  If its something like firmware or a hypervisor, you might have a
chance with option 3.

The hypervisor interface is not at all special in this regard; you may
as well be arguing "We can't allow a port of Linux to the FoobieTron2000
CPU, because it might constrain some future development"; that's true,
it might.  But I don't think I've ever seen anyone make that argument
for not accepting a new architecture port.

I don't really understand what your overall argument is though.  Sure, I
guess its that if there's one ABI for all hypervisors, then you've only
got one hypervisor-related constraint to consider when evaluating a new
kernel change.  But that ABI is going to be as constraining as the its
most constraining hypervisor, so you're not really in a better position
than if you have N hypervisor ABIs.  In fact you're worse off, because
you have no flexibility to drop/adapt/whatever the real blocker.

> _Now_ at least i've got this minimal 
> admission that FoobieVisor _might_ break. Quite a breakthrough =B-)

If you went to all that typing to get that much of a concession, then
you have way too much time ;)

    J

