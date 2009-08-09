Return-Path: <linux-kernel-owner+w=401wt.eu-S1752924AbZHIVMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbZHIVMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 17:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZHIVMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 17:12:46 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:39035 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbZHIVMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 17:12:46 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] OOPS in identify_cpu() on CPUs without CPUID
Date: Sun, 9 Aug 2009 23:12:33 +0200
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, mingo@redhat.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
References: <200908081908.12240.linux@rainbow-software.org> <20090808175344.GA8099@elte.hu> <4A7E262A.9020606@zytor.com>
In-Reply-To: <4A7E262A.9020606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908092312.36578.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 August 2009 03:28:10 H. Peter Anvin wrote:
> On 08/08/2009 10:53 AM, Ingo Molnar wrote:
> > indeed ...
> >
> >> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >>
> >> --- linux-2.6.30.4-orig/arch/x86/kernel/cpu/common.c	2009-06-10
> >> 05:05:27.000000000 +0200 +++
> >> linux-2.6.30.4-router/arch/x86/kernel/cpu/common.c	2009-08-08
> >> 18:00:21.000000000 +0200 @@ -699,6 +699,7 @@
> >>
> >>  static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
> >>  {
> >> +	this_cpu = &default_cpu;
> >>  	c->extended_cpuid_level = 0;
> >>
> >>  	if (!have_cpuid_p())
> >
> > How about initializing this_cpu instead, via:
> >
> > static const struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
>
> The whole this_cpu hack is scary as all hell... although it's probably
> OK on a technicality, it takes what is properly a per-cpu attribute and
> turns it into a static global.
>
> We *should* be able to initialize the APs (at least) in parallel, and
> although there probably aren't any systems in the field which don't have
> duplicate vendors, it is at least theoretically possible to have
> combinations of CPUID and non-CPUID processors in the same systems.
>
> As such, it really would be better if this_cpu was changed to be passed
> as return values and on the stack (as appropriate).  However, that is
> not 2.6.31 material, and as such doing the static initialization would
> be okay.
>
> Ondrej, would you be interested in doing a "fullblown" patch for this?

That would be too much for me. I know basically nothing about this 
initialization code.

> 	-hpa



-- 
Ondrej Zary
