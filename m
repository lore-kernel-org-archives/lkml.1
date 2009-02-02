Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbZBBVTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbZBBVTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZBBVTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:19:36 -0500
Received: from gate.crashing.org ([63.228.1.57]:44586 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbZBBVTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:19:35 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andreas Schwab <schwab@suse.de>
In-Reply-To: <alpine.LFD.2.00.0902021251130.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <1233568479.18767.86.camel@pasglop>
	 <alpine.LFD.2.00.0902020902320.4704@localhost.localdomain>
	 <1233606805.18767.97.camel@pasglop>
	 <alpine.LFD.2.00.0902021241430.3247@localhost.localdomain>
	 <alpine.LFD.2.00.0902021251130.3247@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 08:19:16 +1100
Message-Id: <1233609556.18767.117.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I suspect that late-suspend/early-resume is just exactly the same. It's a 
> boot, after all. 

I agree. We know we have turned off all other CPUs, we can't race,
etc...

> Just let ACPI do its odd things, despite the fact that 
> interrupts are disabled. The fact that doing them while the system is 
> _running_ is invalid doesn't necessarily mean that it is invalid under 
> bootup or suspend/resume.
> 
> We might even make it possible to have timers going, if we end up saying 
> "we'll mask all hardware interrupts _except_ for the timer". I'm not sure 
> that is necessarily something we can do portably, though..

Dunno. I can do it for powerpc easily enough but it's hard to tell for
others. The problem with timers running is that it means a slight change
of semantics for drivers in the sense that suspend_late now -might- be
interrupted by some request hitting the driver from interrupt time ...
ie, we had the property that suspend_late was not going to bother with
any exclusion vs. normal processing code path, but with timers on,
that's no longer the case... 

I prefer the hack to get ACPI working early. Sounds saner to me in a
wicked way :-) And being able to restore the device via ACPI before
touching its config space -at-all- in the kernel side might end up
making things more robust for us .. who knows what those AML do tho...

BTW. Somebody happens to know what Windows does in that area ? Does it
restore config space ?

Cheers,
Ben.


