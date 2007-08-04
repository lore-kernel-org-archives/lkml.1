Return-Path: <linux-kernel-owner+w=401wt.eu-S1764193AbXHDJas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764193AbXHDJas (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 05:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761185AbXHDJaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 05:30:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55216 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760454AbXHDJai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 05:30:38 -0400
Date: Sat, 4 Aug 2007 11:30:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Cal Peake <cp@absolutedigital.net>, Chuck Ebbert <cebbert@redhat.com>,
       Gabriel C <nix.or.die@googlemail.com>, Frank Hale <frankhale@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel ACPI Mailing List <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: ACPI on Averatec 2370
Message-ID: <20070804093035.GA25389@one.firstfloor.org>
References: <46ACD8DB.2020108@googlemail.com> <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net> <Pine.LNX.4.64.0708021335060.28012@lancer.cnet.absolutedigital.net> <46B22BDA.8090604@redhat.com> <Pine.LNX.4.64.0708021512530.28012@lancer.cnet.absolutedigital.net> <46B23E08.4070106@redhat.com> <Pine.LNX.4.64.0708021627590.28012@lancer.cnet.absolutedigital.net> <alpine.LFD.0.999.0708021353320.8184@woody.linux-foundation.org> <Pine.LNX.4.64.0708021723160.28012@lancer.cnet.absolutedigital.net> <alpine.LFD.0.999.0708031447420.8184@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708031447420.8184@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > amd_apic_timer_broken: forcing return value of 1
> 
> since this makes it all work for you, it does appear that the AMD local 
> timer stops in C1 even when that isn't true, and as such is not useful.

Probably messed up SMM code. Might not apply to all AMD CPUs.

> Sad. It probably means that we have to disable the local timer for *all* 
> modern AMD CPU's.

I saw an APIC timer problem on a older AMD laptop too (long before RevF).
Back then I asked and it was apparently some SMM bug of that specific
BIOS.

What exact type of machine is it?
 

> 
> Thomas/Ingo - did something change in the local apic programming? Or why 
> did this work before? Was it just that we didn't use the local timer apic 

We used to always use the interrupt 0 too, which woke up the CPU and
then piggy backed the APIC interrupt too which works once the CPU
is woken.

Thomas changed that then when he redid the code for clock sources
because interrupt 0/PIT isn't good for frequent reprogramming. 

I did similar experiments some time ago but found it caused a lot of
problems and wasn't as brave as Thomas in working through them, so
i never pushed these patches.

-Andi
