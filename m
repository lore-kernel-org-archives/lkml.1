Return-Path: <linux-kernel-owner+w=401wt.eu-S1752711AbXCISbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbXCISbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 13:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbXCISbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 13:31:34 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43713 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbXCISbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 13:31:33 -0500
Date: Fri, 9 Mar 2007 10:30:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
In-Reply-To: <20070309180230.GA17988@elte.hu>
Message-ID: <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org>
References: <20070309180230.GA17988@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Mar 2007, Ingo Molnar wrote:
> 
> yes - but we already support the raw hardware ABI, in the native kernel.

Why do you continue to call paravirt an ABI?

We got over that. It's not. It's an API.

VMI is an ABI.

As long as you try to confuse the two, there's no point to the discussion.

Yeah, paravirt is ugly. Yeah, the calls should be moved higher in the 
stack. But you don't help by confusing the issue by mixing the different 
parts up and calling something an ABI that simply *isn't*.

Paravirt already acts on a higher level than the ioapic. It does do the 
"irq_disable()" kind of "highlevel" callbacks. Yeah, the "apic_write()" 
ones should go away, and they're just hacky, but there's nothing there 
that is an ABI.

So just *fix* it or tell others to fix it, instead of just confusing the 
issue.

And trust me, if "apic_write" causes bugs because it interacts with real 
APIC usage, we don't care ONE WHIT. That paravirt_ops entry goes out the 
window so fast you can't say "Whaa?!??". 

		Linus
