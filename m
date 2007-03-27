Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXC0Vpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXC0Vpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932778AbXC0Vpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:45:40 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44191 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664AbXC0Vpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:45:39 -0400
Date: Tue, 27 Mar 2007 14:34:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
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
In-Reply-To: <200703271719.25795.lenb@kernel.org>
Message-ID: <Pine.LNX.4.64.0703271430310.6730@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
 <20070326123141.GA11288@ucw.cz> <1174917142.4182.39.camel@chaos>
 <200703271719.25795.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Mar 2007, Len Brown wrote:
> 
> I think the only fool-proof way to do this automatically is to

Why not just take the known-good CPUID signature?

Screw firmware or ACPI tables. They're going to be occasionally wrong.

If we know that "Core 2, version X" has a good local APIC timer, we use 
it. Otherwise we don't.

That's generally how we handle other APIC bugs too (the read-after-write 
thing, for example, or the differences between integrated and off-chip 
APIC's). Sometimes we check the APIC version itself, sometimes we check 
the CPUID information, and sometimes we check both ("modern_apic()").

			Linus
