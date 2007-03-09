Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbXCITCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbXCITCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 14:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767492AbXCITCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 14:02:50 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36191 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbXCITCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 14:02:48 -0500
Date: Fri, 9 Mar 2007 11:00:40 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309190040.GQ10574@sequoia.sous-sol.org>
References: <20070309180230.GA17988@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309180230.GA17988@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> i claim that when the 'API cut' is done at the right level then no more 
> than say 100 hooks would be needed - with virtually zero kernel size 
> increase. We've got all the right highlevel abstractions: genirq, gtod, 
> clockevents. Whatever is missing at the moment from the framework (say 
> smp_send_reschedule()) we can abstract away. The bonus? It would be 
> almost directly applicable to other architectures as well. It would also 
> work with /any/ hypervisor.

Oddly enough, that's really what we are trying to acheive.  There is
definitely some tension between the VMI model which is modeled very
directly on hardware and something like the Xen model which prefers
higher level interfaces.

I don't really agree with your metrics w.r.t hooks.  My point is you
take callsites == hooks to arrive at 1463 hook, but then above say 100
hooks is sufficient.  But we have on the order of 100 hooks (I believe
it's ~75 in Linus' tree).  Put it another way.  Do you believe that
something like irq_{en,dis}able() is appropriate to hook (as that's >
1400 callsites already)?

> Firstly, i think this has been over-rushed. After years of being happy 
> with forks of the Linux kernel, all the hypervisors woke up at once and 
> want to have their stuff upstream /now/. This rush created a hodgepodge 
> of APIs/ABIs that we now in the end promise to support /all/. (if we 
> take CONFIG_VMI i can see little ethical reason to not take Xen's 
> paravirt_ops, lguest's paravirt_ops, KVM's paravirt_ops and i'm sure 
> Microsoft/Novell will have something nice and different for us too.)

It would be imminently helpful if you helped with some specific ideas
on where the paravirt_ops interface needs to be adjusted.

> Secondly, i'd like to see a paravirt approach that has /implicit/ 
> safeguards against the following type of crap:

How would you propose doing that?  Typically that's done with code
review and patches.

thanks,
-chris
