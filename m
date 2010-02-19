Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab0BSKvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 05:51:13 -0500
Received: from www.tglx.de ([62.245.132.106]:56062 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab0BSKvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 05:51:10 -0500
Date: Fri, 19 Feb 2010 11:50:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@linux.intel.com>
cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org,
       linux-tip-commits@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent
 on PCI
In-Reply-To: <4B7B1C40.8070208@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1002191031190.2811@localhost.localdomain>
References: <20100123113359.GA29555@one.firstfloor.org> <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org> <20100216204732.GA2301@elte.hu> <4B7B1C40.8070208@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Andi Kleen wrote:
> > 
> > Please work with Mauro on the Nehalem EDAC bits, they seem rather advanced
> > to
> > me for v2.6.34, and _far_ cleaner and more capable as well. See those Intel
> > support bits at:
> 
> Hi Ingo,
> 
> core_i7 and EDAC has nothing to do with this code and
> it has nothing to do with the problem this patch is
> solving.
> 
> This is for a different chip (xeon75xx)
> which has a completely different memory subsystem
> and reports memory errors in a completely different way
> than xeon75xx/core_i7.
> 
> For core_i7/xeon55xx there is no additional event interface needed;
> it's all supplied by the hardware on the existing interfaces.
> 
> The point of this code is to annotate the CE events on Xeon 75xx
> and to implement specific backend actions (page offlining, triggers)
> based on specific events. These backend actions are already implemented
> on 55xx without additional changes (no need for EDAC)
> 
> EDAC does not provide an event interface that can
> be polled, just counts, so this cannot be done with EDAC.
> It's simply a topology enumeration with error counts.
> mcelog is not a topology interface, it's a event
> notification mechanism.
> 
> EDAC and mcelog are orthogonal, they don't solve the same
> problem.
> 
> So your nack is based on incorrect assumptions and doesn't make
> sense. What you're asking for cannot be done with current
> EDAC as far as I know.

It does not matter at all that current EDAC cannot do that right
now. Fact is that you are stubbornly ignoring any request from the x86
maintainers to rework MCE, consolidate it with EDAC and integrate it
into perf as the suitable event logging mechanism.

MCE has no design at all, it's a specialized hack which is limited to
a specific subset of the overall machine health monitoring and
reporting facilities.

You refuse to even think about consolidating the handling of all
health monitoring and reporting facilities into a well designed and
integrated framework. 

Your sole argument is that mce can do it and EDAC or whatever can
not. That's not a technical argument at all. MCE does not become a
better design just because you hacked another feature into it.

Ingo's NAK is completely correct and he has my full support for it.

We do not want new crap in the already horrible MCE code. We simply
request a consolidation of machine health monitoring/reporting
facilities before adding new stuff.

You have been ignoring our technical requests for more than a
year. You are refusing to work with other people on a well designed
solution. You just follow your own agenda and try to squeeze more
stuff into MCE.

	tglx
