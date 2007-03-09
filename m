Return-Path: <linux-kernel-owner+w=401wt.eu-S1767569AbXCIW2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767569AbXCIW2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767570AbXCIW2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:28:46 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51549 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767569AbXCIW2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:28:45 -0500
Date: Fri, 9 Mar 2007 14:27:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
In-Reply-To: <20070309213607.GA16796@elte.hu>
Message-ID: <Pine.LNX.4.64.0703091423570.10832@woody.linux-foundation.org>
References: <20070309180230.GA17988@elte.hu>
 <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org>
 <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org>
 <20070309201257.GA5761@elte.hu> <Pine.LNX.4.64.0703091305090.10832@woody.linux-foundation.org>
 <20070309213607.GA16796@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Mar 2007, Ingo Molnar wrote:
> 
> hm. So your point is that VMI is in essence a Turing machine (a 
> near-complete one)? No matter what redesign we do on the Linux side, the 
> VMI paravirt_ops will always be able to adopt to it?

No, I don't think it's turing-complete ;)

But since it tries to basically come fairly close to emulating the 
hardware we already use, any higher-level abstraction we do (which 
obviously has to work on real hardware too!) is likely to be translatable 
into the "pseudo-hardware" thing that is the VMI interfaces.

> but ... maybe because VMI is so lowlevel and covers /all/ of x86 today, 
> it will always be able to emulate whatever different concept we can come 
> up with? Do we really know this absolutely sure?

"For sure"? Absolutely not. But since any new interfaces we come up with 
for doing timers etc had better work perfectly fine on an old hardware 
platform too, we can't exactly require any interfaces that do things that 
a bog-standard old dual-PPro didn't do 10 years ago, can we?

So assumign that the VMI interface is roughly as powerful (by virtue of 
basically emulating it) as the old single-ioapic/single-lapic systems we 
used to use, I don't think it should ever be a real problem. Hmm?

		Linus
