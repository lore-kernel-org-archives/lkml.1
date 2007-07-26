Return-Path: <linux-kernel-owner+w=401wt.eu-S1765333AbXGZHDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765333AbXGZHDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 03:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759605AbXGZHDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 03:03:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41010 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755523AbXGZHC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 03:02:59 -0400
Date: Thu, 26 Jul 2007 00:02:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.23-rc1
In-Reply-To: <200707251851.22777.lenb@kernel.org>
Message-ID: <alpine.LFD.0.999.0707252357420.3442@woody.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org>
 <alpine.LFD.0.999.0707251147130.3607@woody.linux-foundation.org>
 <200707251851.22777.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Jul 2007, Len Brown wrote:
> On Wednesday 25 July 2007 14:48, Linus Torvalds wrote:
> 
> > ... ACPI now seems to select CPU hotplug. Why? 
> 
> ACPI=y SMP=y systems require SUSPEND_SMP=y for system sleep support,
> and that requires HOTPLUG_CPU=y.

.. and why do you think I want system sleep support? That's the bug.

> Note that ACPI=y SMP=n systems do not need it,
> and thus will not select HOTPLUG_CPU=y

I want SMP, dammit. This machine has multi-core. And I want ACPI. I just 
don't want the system sleep thing.

I didn't have it before, I don't need it, I don't want it.

> My assumption is that if somebody selects CONFIG_ACPI,
> that 99% of the time, they intend that to include support for
> the ACPI hooks for system sleep states.

That wasn't true before, and it makes no sense what-so-ever as an 
assumption.

The system sleep states are mostly usable on laptops. Not always even 
then. They are seldom used on desktops or servers, but both of those are 
often SMP machines, and certainly want ACPI.

So your "99%" makes no sense.

> So today we have this:
> 
> menuconfig ACPI
> 	...
>         select HOTPLUG_CPU if X86 && SMP
>         select SUSPEND_SMP if X86 && SMP

But why the *hell* is this dependent on ACPI?

Why not just do ACPI_SLEEP, and have *that* do "select 
HOTPLUG_CPU/SUSPEND_CPU".

> Which I think leads to fewer surprises, and less complicated code.

That makes no sense. You're tying together things that have *nothing* to 
do with each other.

As mentioned (and as is *obvious*), pretty much everybody who has a 
multi-core CPU on x86 wants ACPI and SMP. But the set of people who want 
to sw-suspend such a machine is *much* smaller. There is no 99%.

			Linus
