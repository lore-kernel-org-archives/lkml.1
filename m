Return-Path: <linux-kernel-owner+w=401wt.eu-S934345AbXC2VpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345AbXC2VpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 17:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934347AbXC2VpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 17:45:23 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:43965 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934345AbXC2VpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 17:45:22 -0400
Date: Thu, 29 Mar 2007 23:45:21 +0200
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Mark Langsdorf <mark.langsdorf@amd.com>,
       Len Brown <lenb@kernel.org>, "Morrow, William" <William.Morrow@amd.com>,
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
Message-ID: <20070329214520.GA3185@rhlx01.hs-esslingen.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <p73d52s2dvi.fsf@bingen.suse.de> <460C1B5B.4090802@amd.com> <200703292249.37979.ak@suse.de> <Pine.LNX.4.64.0703291410480.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703291410480.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 29, 2007 at 02:16:54PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 29 Mar 2007, Andi Kleen wrote:
> > 
> > Here's a patch. I don't have a system with C1E, so i only tested that
> > the apic timer still works on a older AMD box.
> 
> I think this looks better than what we have now, but it would look even 
> better if the core CPUID stuff was in arch/i386/kernel/cpu/amd.c, and we 
> simply had X86_FEATURE_BROKEN_C1_LAPIC etc..

Please don't, this would break the interface logically.
X86_FEATURE_xxx usually denotes a *feature*, not a "feature"
(Micro$oft speak for "bug" ;).
IOW most flags express a positive attribute, not a negative one.
An exception to this probably is X86_FEATURE_FXSAVE_LEAK and
X86_FEATURE_CMP_LEGACY, but all others seem to be positive, so we might
want to enforce this rule.

Thus, how about e.g. X86_FEATURE_LAPIC_C1_OK?
Or is this less precise from a "C1 working ok" detection point of view?
(i.e. we'd just assume by default that most machines are ok except the ones
where we have issue detection code for, which might be too fuzzy)

Andreas Mohr
