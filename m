Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbYFRWsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbYFRWsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 18:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYFRWsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 18:48:06 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:39240 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYFRWsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 18:48:05 -0400
Date: Wed, 18 Jun 2008 18:47:49 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [patch 0/6] AMD C1E aware idle support
In-reply-to: <20080610171639.551369443@linutronix.de>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Message-id: <alpine.LFD.1.10.0806181834110.3074@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080610171639.551369443@linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Jun 2008, Thomas Gleixner wrote:

> AMD CPUs with C1E support are currently excluded from high resolution
> timers and NOHZ support. The reason is that C1E is a BIOS controlled
> C3 power state which switches off TSC and the local APIC timer. The
> ACPI C-State control manages the TSC/local APIC timer wreckage, but
> this does not include the C1 based ("halt" instruction) C1E mode. The
> BIOS/SMM controlled C1E state works on most systems even without
> enabling ACPI C-State control.

What a mess.

What is the measured power savings that justifies this effort?

While I'm okay with platform specific idle states,
I'm not okay with the use of therm C1E here.

C1E has been shipped for many years on Intel processors
and it is completely transparent to the OS.

If AMD now has their own C1E and it breaks the OS,
please call is something like AMD_C1E to make it
totally clear in shared files like process.c
that consulting that variable or running that routine
on Intel hardware would be a Linux bug.

thanks
-Len

