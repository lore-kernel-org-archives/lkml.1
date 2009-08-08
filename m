Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbZHHSTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbZHHSTc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 14:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZHHSTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 14:19:31 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:43488 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbZHHSTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 14:19:31 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] OOPS in identify_cpu() on CPUs without CPUID
Date: Sat, 8 Aug 2009 20:19:20 +0200
User-Agent: KMail/1.9.10
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
References: <200908081908.12240.linux@rainbow-software.org> <20090808175344.GA8099@elte.hu>
In-Reply-To: <20090808175344.GA8099@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908082019.23574.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 August 2009 19:53:44 Ingo Molnar wrote:
> * Ondrej Zary <linux@rainbow-software.org> wrote:
> > Kernel is broken for x86 CPUs without CPUID since 2.6.28. It
> > crashes with NULL pointer dereference in identify_cpu():
> >
> > 766        generic_identify(c);
> > 767
> > 768-->     if (this_cpu->c_identify)
> > 769                this_cpu->c_identify(c);
> >
> > this_cpu is NULL. This is because it's only initialized in
> > get_cpu_vendor() function, which is not called if the CPU has no
> > CPUID instruction.
>
> indeed ...
>
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >
> > --- linux-2.6.30.4-orig/arch/x86/kernel/cpu/common.c	2009-06-10
> > 05:05:27.000000000 +0200 +++
> > linux-2.6.30.4-router/arch/x86/kernel/cpu/common.c	2009-08-08
> > 18:00:21.000000000 +0200 @@ -699,6 +699,7 @@
> >
> >  static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
> >  {
> > +	this_cpu = &default_cpu;
> >  	c->extended_cpuid_level = 0;
> >
> >  	if (!have_cpuid_p())
>
> How about initializing this_cpu instead, via:
>
> static const struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
>
> ?

That might be even better - looks cleaner. I can't test it right now as I 
don't have the hardware here. I'll test it tomorrow (unless someone will be 
faster).

-- 
Ondrej Zary
