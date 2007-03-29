Return-Path: <linux-kernel-owner+w=401wt.eu-S1030741AbXC2VWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030741AbXC2VWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030745AbXC2VWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:22:07 -0400
Received: from smtp.osdl.org ([65.172.181.24]:39685 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030741AbXC2VWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:22:04 -0400
Date: Thu, 29 Mar 2007 14:16:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: Mark Langsdorf <mark.langsdorf@amd.com>, Len Brown <lenb@kernel.org>,
       "Morrow, William" <William.Morrow@amd.com>,
       "Crouse, Jordan" <jordan.crouse@ldcmail.amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
In-Reply-To: <200703292249.37979.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0703291410480.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <p73d52s2dvi.fsf@bingen.suse.de> <460C1B5B.4090802@amd.com>
 <200703292249.37979.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Mar 2007, Andi Kleen wrote:
> 
> Here's a patch. I don't have a system with C1E, so i only tested that
> the apic timer still works on a older AMD box.

I think this looks better than what we have now, but it would look even 
better if the core CPUID stuff was in arch/i386/kernel/cpu/amd.c, and we 
simply had X86_FEATURE_BROKEN_C1_LAPIC etc..

And then the apic.c code would just check

	if (boot_cpu_has(X86_FEATURE_BROKEN_C1_LAPIC))
		return -1;

or similar.

Doing the same for C2 and C3 gives us a clean way to have all these 
per-vendor things in their relevant places, rather than having various 
vendor-specific checks sprinkled in random places..

That's *especially* true for something like this that can hit both on 
x86-64 and i386, where the cpuid logic is shared, but the APIC logic is 
*not* shared. If I read your patch correctly, this only fixes it on 32-bit 
platforms, and I don't think the problem is in any way 32-bit specific, is 
it?

		Linus
