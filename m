Return-Path: <linux-kernel-owner+w=401wt.eu-S1764275AbXFESk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764275AbXFESk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:40:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbXFESkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:40:17 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:50250 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757549AbXFESkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:40:15 -0400
Date: Tue, 5 Jun 2007 14:40:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/9] Conditional Calls - Architecture Independent Code
Message-ID: <20070605184011.GA11996@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.070136408@polymtl.ca> <p73wsypcdfj.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <p73wsypcdfj.fsf@bingen.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:33:03 up 8 days,  3:11,  6 users,  load average: 3.51, 2.32, 1.18
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> 
> > +struct __cond_call_struct {
> 
> Calling structs *_struct is severly deprecated and will cause some people
> to make fun of your code.
> 

ok

> 
> > +	const char *name;
> > +	void *enable;
> > +	int flags;
> > +} __attribute__((packed));
> 
> The packed doesn't seem to be needed. There will be padding at 
> the end anyways because the next one needs to be aligned.
> 
ok

> > +
> > +
> > +/* Cond call flags : selects the mechanism used to enable the conditional calls
> > + * and prescribe what can be executed within their function. This is primarily
> > + * used at reentrancy-unfriendly sites. */
> > +#define CF_OPTIMIZED		(1 << 0) /* Use optimized cond_call */
> > +#define CF_LOCKDEP		(1 << 1) /* Can call lockdep */
> > +#define CF_PRINTK		(1 << 2) /* Probe can call vprintk */
> > +#define CF_STATIC_ENABLE	(1 << 3) /* Enable cond_call statically */
> 
> Why is that all needed?  Condcall shouldn't really need to know anything
> about all this. They're just a fancy conditional anyways -- and you don't
> tell if() that it may need to printk.
> 
> Please consider eliminating.
> 

I will remove the STATIC_ENABLE and the PRINTK, but I will leave the
CF_LOCKDEP and CF_OPTIMIZED there: they are required to let the generic
version be selected in contexts where a breakpoint cannot be used on
x86 (especially when placing a cond_call within lockdep.c code or any
code that could not afford to fall into a breakpoint handler).

> 
> 
> > +#define _CF_NR			4
> 
> 
> > +
> > +#ifdef CONFIG_COND_CALL
> > +
> > +/* Generic cond_call flavor always available.
> > + * Note : the empty asm volatile with read constraint is used here instead of a
> > + * "used" attribute to fix a gcc 4.1.x bug. */
> 
> What gcc 4.1 bug? 
> 

Please see

http://www.ecos.sourceware.org/ml/systemtap/2006-q4/msg00146.html

for Jeremy Fitzhardinge's comment on the issue. I will add some comments
in the code.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
