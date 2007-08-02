Return-Path: <linux-kernel-owner+w=401wt.eu-S1760513AbXHBVyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760513AbXHBVyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756477AbXHBVyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:54:32 -0400
Received: from livid.absolutedigital.net ([66.92.46.173]:44377 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbXHBVyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:54:31 -0400
Date: Thu, 2 Aug 2007 17:53:28 -0400 (EDT)
From: Cal Peake <cp@absolutedigital.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Chuck Ebbert <cebbert@redhat.com>, Gabriel C <nix.or.die@googlemail.com>,
       Frank Hale <frankhale@gmail.com>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel ACPI Mailing List <linux-acpi@vger.kernel.org>,
       len.brown@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: ACPI on Averatec 2370
In-Reply-To: <alpine.LFD.0.999.0708021353320.8184@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0708021723160.28012@lancer.cnet.absolutedigital.net>
References: <5ebbd9b50707291105w316f98e5h3fa17204c9119a2f@mail.gmail.com>
 <46ACD8DB.2020108@googlemail.com> <Pine.LNX.4.64.0707301048460.5693@lancer.cnet.absolutedigital.net>
 <Pine.LNX.4.64.0708021335060.28012@lancer.cnet.absolutedigital.net>
 <46B22BDA.8090604@redhat.com> <Pine.LNX.4.64.0708021512530.28012@lancer.cnet.absolutedigital.net>
 <46B23E08.4070106@redhat.com> <Pine.LNX.4.64.0708021627590.28012@lancer.cnet.absolutedigital.net>
 <alpine.LFD.0.999.0708021353320.8184@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Linus Torvalds wrote:

> On Thu, 2 Aug 2007, Cal Peake wrote:
> > 
> > Figured I should have sent that right after I hit the send key...
> > 
> > processor	: 0
> > vendor_id	: AuthenticAMD
> > cpu family	: 15
> > model		: 72
> > model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-52
> 
> Sadly, this doesn't show the "extended family" stuff from cpuid.
> 
> So it doesn't show any of the bits we actually care about. Sad.
> 
> That said, the "AMD Turion(tm) 64 X2 Mobile Technology TL-52" _should_ be 
> a REV-F CPU afaik, and it should have thus fallen through to the 
> "ENABLE_C1E_MASK" logic. Afaik that's broken.
> 
> Cal - can you
>  (a) test that forcing a "return 1" from that amd_apic_timer_broken() 
>      function fixes it for you.

ACK

>  (b) make that function print out the values it uses for debugging (ie the 
>      xtended family and model numbers, and the MSR_K8_ENABLE_C1E MSR 
>      values)?

eax & CPUID_XFAM == 0x00000000
eax & CPUID_XMOD == 0x00040000
MSR_K8_ENABLE_C1E lo == 0x04c14015
MSR_K8_ENABLE_C1E hi == 0x00000000
lo & ENABLE_C1E_MASK == 0
amd_apic_timer_broken: forcing return value of 1

-- 
Cal Peake

