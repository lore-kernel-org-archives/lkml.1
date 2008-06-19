Return-Path: <linux-kernel-owner+w=401wt.eu-S1755323AbYFSFVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbYFSFVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 01:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbYFSFVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 01:21:04 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:34212 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbYFSFVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 01:21:03 -0400
Date: Thu, 19 Jun 2008 01:20:56 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] x86: update mptable v7
In-reply-to: <86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>
X-X-Sender: lenb@localhost.localdomain
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0806190113290.3613@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200805041823.57198.yhlu.kernel@gmail.com>
 <200805191252.36814.yhlu.kernel@gmail.com>
 <200805251600.26325.yhlu.kernel@gmail.com>
 <200806011317.38622.yhlu.kernel@gmail.com>
 <alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>
 <86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>
 <alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>
 <86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> >> >> make mptable to be consistent to acpi routing, so we could
> >> >> 1. kexec kernel with acpi=off
> >> >> 2. workaround BIOS that acpi routing is working, but mptable is not right.
> >> >>    so can use kernel/kexec to start other os that doesn't have good acpi support
> >> >
> >> > Is this an effort to boot an ACPI-mode kernel,
> >> > and then kexec a non-ACPI kernel?
> >>
> >> Yes,
> >
> > Why is this feature needed?
> > There are a number of ways that the resulting kernel may fail,
> > all platform specific.
> 
> other os still doesn't have update acpi irq routing support. but has
> broken mptable.

I don't see how this can work.

What if the the platform doesn't suport MPS -- the
2nd OS will try to run in PIC mode and will see
only the legacy interrupts?

What if it does support MPS but ACPI has configured
its PCI Interrupt Link Devices to direct interrupts
to different IRQs that are described by MPS?

> >> > Doing so could confuse the heck out of the platform firmware,
> >> > which will think that an ACPI-mode kernel is still running.

There is state in the chip-set that the ACPI OS has set
that makes no sense in an non-ACPI context and can lead
to bizzare behaviour.  The Links above is just one example.

the ACPI SCI interrupt is configured in ACPI mode only.
What happens when the non-ACPI OS boots and GPE's
fire and result in SCI's?  They'll not get serviced
and will kill that IRQ and anything else on it.

Can somebody clue me into why this concept
is something other than totally insane?

-Len


