Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYEJOgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYEJOgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 10:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYEJOgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 10:36:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:25294 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYEJOgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 10:36:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=gf2ju6pheWMHTCbYxiv3khgDFuUeMaWSBoZ3xuohg1XAnNpt6IzM7jcSaSeBUSCPoks+2QKhCi1x+0TVgI7oL286jRvG9ja1LyxkOefL8FICv4UMaF52F5oJRv1vjn3ssBIertF10YR3kJs7zCka3S+AJxLLTAjumrEc1JAHMec=
Date: Sat, 10 May 2008 22:34:33 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, WANG Cong <xiyou.wangcong@gmail.com>,
       toralf.foerster@gmx.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Travis <travis@sgi.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
	multiple definition of `phys_cpu_present_map'
Message-ID: <20080510143433.GD3148@hacking>
References: <200805091114.00244.toralf.foerster@gmx.de> <20080509095244.GJ2543@hacking> <20080509095837.GB19617@elte.hu> <1210342946.3069.4.camel@localhost.localdomain> <20080509144722.GA20566@elte.hu> <20080510131752.GA888@elte.hu> <1210428108.4002.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210428108.4002.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 09:01:48AM -0500, James Bottomley wrote:
>
>OK, so these symbols are required on visws as well.  So that makes the
>gating config symbol X86_LOCAL_APIC.
>
>Could you run this through the same config to verify; thanks!
>
>James
>
>---
>
>From: James Bottomley <James.Bottomley@HansenPartnership.com>
>Subject: [VOYAGER] fix duplicate phys_cpu_present_map symbol
>
>The phys_cpu_present_map is an expected symbol in the SMP harness.
>Unfortunately, x86 recently moved this and a few others to
>kernel/setup.c where it doesn't quite work because voyager has to
>define its own.  Use CONFIG_X86_LOCAL_APIC to isolate these
>definitions and fix up another area in setup.c where CONFIG_X86_SMP
>should be used instead of CONFIG_SMP.
>

Hmmm, I rechecked the files used 'phys_cpu_present_map'.

$ grep -nr "mpspec.h" arch/x86/ | cut -d: -f 1 | xargs grep "phys_cpu_present_map" | cut -d: -f 1 | uniq
arch/x86/kernel/setup.c
arch/x86/kernel/apic_64.c
arch/x86/kernel/apic_32.c

And in Makefile:

obj-$(CONFIG_X86_LOCAL_APIC)    += apic_$(BITS).o nmi_$(BITS).o

So your patch looks correct!

Thanks.

 Cong
