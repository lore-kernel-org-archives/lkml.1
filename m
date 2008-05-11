Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbYEKOi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbYEKOi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 10:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbYEKOiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 10:38:20 -0400
Received: from www.tglx.de ([62.245.132.106]:49512 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYEKOiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 10:38:20 -0400
Date: Sun, 11 May 2008 16:35:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Simek <monstr@seznam.cz>
cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 08/56] microblaze_v2: Interrupt handling, timer support,
 supported function
In-Reply-To: <4826FAC8.4010604@seznam.cz>
Message-ID: <alpine.LFD.1.10.0805111630001.3197@apollo.tec.linutronix.de>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu> <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu> <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu> <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu> <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu> <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu> <alpine.LFD.1.10.0805070813160.3318@apollo.tec.linutronix.de> <4826FAC8.4010604@seznam.cz>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

On Sun, 11 May 2008, Michal Simek wrote:
> > 
> > Please split this modification code out into a separate function. The
> > same code is used below.
> 
> Add Macro.

Please use a (inline) function whenever possible. Macros are harder to
read and not type safe.

> > Can you please move a new architecture to clockevents / clocksource
> > right from the beginning ? No need to invent another incompatible set
> > of time(r) related functions.
> 
> I move whole code to GENERIC_TIME. Did you meant any others changes?

GENERIC_TIME and GENERIC_CLOCKEVENTS. You get high resolution timers
and dynamic ticks for free when your timer hardware allows it.

> >> +#define NO_IRQ (-1)
> >> +
> >> +static inline int irq_canonicalize(int irq)
> >> +{
> >> +	return (irq);
> >> +}
> > 
> > Why is this needed ? Any users ?
> 
> is used in serial_core.c
>  684         new_serial.irq = irq_canonicalize(new_serial.irq);

Doh, forgot about that one.

Thanks,
	tglx
