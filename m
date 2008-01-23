Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbYAWK6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbYAWK6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 05:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbYAWK6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 05:58:01 -0500
Received: from gir.skynet.ie ([193.1.99.77]:51237 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYAWK6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:58:00 -0500
Date: Wed, 23 Jan 2008 10:57:57 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       apw@shadowen.org
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Message-ID: <20080123105757.GE21455@csn.ul.ie>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <200801221433.29771.andi@firstfloor.org> <20080123102834.GC21455@csn.ul.ie> <200801231145.14915.andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200801231145.14915.andi@firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (23/01/08 11:45), Andi Kleen didst pronounce:
> 
> > > i386 already has srat parsing code (just written in a horrible hackish
> > > way); but it exists arch/x86/kernel/srat_32.c
> >
> > Yes, I spotted that. Enabling it required a Kconfig change 
> 
> does it?

hmm, just a removal of (X86_SUMMIT || X86_GENERICARCH). When I was testing
this I was probably using a PC-compatible configuration as that is what I
was enabling at the time. It's a similar restriction for BOOT_IOREMAP.

> I was pretty sure that a !NUMAQ i386 CONFIG_NUMA build
> already used that.

Presumably a GENERICARCH configuration

> At least that was the case when I last looked. If that
> has changed it must have bitrotted recently.
> 

I don't think it has bit-rotted. I was just not using a GENERICARCH
configuration.

> > or two and 
> > enabling BOOT_IOREMAP. It then crashes early in boot on a call to strlen()
> > so I went with the stubs and SRAT disabled for the moment.
> 
> Crashed on a Opteron box? That was always the case
> 

Yeah, elm3b6 from test.kernel.org is an Opteron-based NUMA machine. Oddly
it's good to know that the nature of the crash has not changed.

> If it crashed on a (older) Summit then it likely bitrotted, because that 
> worked at some point. The code was originally written by Pat G. for Summit1
> and I believe was at least used by some people (no distributions) for S2,
> possible 3 too.
> 

Unfortunately, I don't have access to a Summit box so I cannot verify.

> > Ok, understood. When I next revisit this, I'll look at making ACPI_SRAT
> > and BOOT_IOREMAP work on normal machines and see what happens. Thanks.
> 
> Again the problem shouldn't be normal machines, but non Summit NUMA systems.
> 

Grand. I'll get back to this soon and see what can be done.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
