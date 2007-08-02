Return-Path: <linux-kernel-owner+w=401wt.eu-S1761430AbXHBVIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761430AbXHBVIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761911AbXHBVI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:08:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54726 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761815AbXHBVI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:08:26 -0400
Date: Thu, 2 Aug 2007 14:07:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Cal Peake <cp@absolutedigital.net>
cc: Chuck Ebbert <cebbert@redhat.com>, Gabriel C <nix.or.die@googlemail.com>,
       Frank Hale <frankhale@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel ACPI Mailing List <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: ACPI on Averatec 2370
In-Reply-To: <Pine.LNX.4.64.0708021627590.28012@lancer.cnet.absolutedigital.net>
Message-ID: <alpine.LFD.0.999.0708021353320.8184@woody.linux-foundation.org>
References: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com>
 <46ACD8DB.2020108@googlemail.com> <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net>
 <Pine.LNX.4.64.0708021335060.28012@lancer.cnet.absolutedigital.net>
 <46B22BDA.8090604@redhat.com> <Pine.LNX.4.64.0708021512530.28012@lancer.cnet.absolutedigital.net>
 <46B23E08.4070106@redhat.com>
 <Pine.LNX.4.64.0708021627590.28012@lancer.cnet.absolutedigital.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Aug 2007, Cal Peake wrote:
> 
> Figured I should have sent that right after I hit the send key...
> 
> processor	: 0
> vendor_id	: AuthenticAMD
> cpu family	: 15
> model		: 72
> model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-52

Sadly, this doesn't show the "extended family" stuff from cpuid.

So it doesn't show any of the bits we actually care about. Sad.

That said, the "AMD Turion(tm) 64 X2 Mobile Technology TL-52" _should_ be 
a REV-F CPU afaik, and it should have thus fallen through to the 
"ENABLE_C1E_MASK" logic. Afaik that's broken.

Cal - can you
 (a) test that forcing a "return 1" from that amd_apic_timer_broken() 
     function fixes it for you.
 (b) make that function print out the values it uses for debugging (ie the 
     xtended family and model numbers, and the MSR_K8_ENABLE_C1E MSR 
     values)?

Andi, can you check with your AMD contacts that those bits are correct.. 
Maybe the "Mobile Technology" things *always* have the broken "Enhanced 
Halt State", regardless of any MSR settings? That would perhaps be what 
makes them "Mobile".

		Linus
