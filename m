Return-Path: <linux-kernel-owner+w=401wt.eu-S933344AbXCHVO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344AbXCHVO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXCHVO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:14:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44611 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933344AbXCHVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:14:57 -0500
Date: Thu, 8 Mar 2007 22:13:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: tglx@linutronix.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       john stultz <johnstul@us.ibm.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Daniel Hecht <dhecht@vmware.com>, Daniel Arai <arai@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: hardwired VMI crap
Message-ID: <20070308211306.GA20934@elte.hu>
References: <45EF0CF5.5090305@goop.org> <45EF175D.6030609@vmware.com> <1173302503.24738.795.camel@localhost.localdomain> <45EF372E.7030600@goop.org> <1173308717.24738.898.camel@localhost.localdomain> <45EF49E9.7040509@vmware.com> <20070308091019.GA19460@elte.hu> <45EFE010.7080108@vmware.com> <1173352154.24738.1023.camel@localhost.localdomain> <45F0761C.6060107@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F0761C.6060107@vmware.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zachary Amsden <zach@vmware.com> wrote:

> When we're about two weeks away from a product release and you are 
> threatening to unmerge or block our code because we didn't create an 
> abstract interrupt controller, we re-used the APIC and IO-APIC, this 
> is uber rocket science. [...]

see my mail to you below: you've been told about the clockevents problem 
months ago, that you shouldnt hardwire PIT details and that you should 
be registering a clockevents device. You cannot credibly claim that you 
didnt know about this.

> We've been doing things this way, with public patches for over a year, 
> and you've even been CC'd on some of the discussions. [...]

i've specifically objected, numerous times - the result of which was 
that when you submitted it to lkml you didnt Cc: me ;) The VMI crap went 
in 'under the radar' via the x86_64 tree.

> [...]  So it is a little late to tell us - "redesign your hypervisor, 
> or else.."

Also, it was /you/ who claimed that paravirt_ops can take care of 
whatever design change on the Linux side - that claim is apparently 
history now and you are now claiming "there's a product on the road, we 
cannot change the hypervisor ABI"? Should i cite that email of yours 
too?

	Ingo

----------------->
Date: Fri, 5 Jan 2007 06:45:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Subject: Re: Clockevent changes in -mm tree
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
        Rusty Russell <rusty@rustcorp.com.au>

* Zachary Amsden <zach@vmware.com> wrote:

> So I'm running into some issues integrating the VMI timer code with 
> the clockevent code in the -mm tree.  Basically, my question is - are 
> clockevents now required to get the timer infrastructure to work 
> properly, and can I have multiple clockevent sources (to allow 
> overriding the PIT) that are selected at boot time?

(I've Cc:-ed Rusty too, the author of the paravirtualization patches. 
Rusty, what's your take on the VMI timer patchset of Zach?)

in any case, i dont see any fundamental problem here. The right model 
for timer paravirtualization is to notify the guest during early bootup 
that this is a paravirtual bootup. Then the guest doesnt even register 
the PIT clocksource but registers the virtual clock-events driver.

	Ingo

