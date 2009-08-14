Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZHNI22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZHNI22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 04:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbZHNI22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 04:28:28 -0400
Received: from www.tglx.de ([62.245.132.106]:53814 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbZHNI21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 04:28:27 -0400
Date: Fri, 14 Aug 2009 10:28:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [patch] clockevents_notify() need to be called with irq's
 enabled
In-Reply-To: <1250234778.2965.8.camel@sbs-t61>
Message-ID: <alpine.LFD.2.00.0908141025290.1283@localhost.localdomain>
References: <1250203681.27006.10842.camel@localhost.localdomain>  <alpine.LFD.2.00.0908140753370.1283@localhost.localdomain> <1250234778.2965.8.camel@sbs-t61>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009, Suresh Siddha wrote:

> On Thu, 2009-08-13 at 23:05 -0700, Thomas Gleixner wrote:
> > On Thu, 13 Aug 2009, Suresh Siddha wrote:
> > 
> > > From: Suresh Siddha <suresh.b.siddha@intel.com>
> > > Subject: clockevents_notify() need to be called with irq's enabled
> > > 
> > > Currently clockevents_notify() is called with interrupts enabled at some
> > > places and interrupts disabled at some other places.
> > 
> > The only place I can see which calls clockevents_notify with
> > interrupts enabled is the hrtimer cpu hotplug code.
> > 
> > I'm a bit wary to enable interrupts all over the place in sensitive
> > corners like ACPI idle code ...
> > 
> > Why don't we just do the obvious and take clockevents_lock irqsave ?
> 
> We didn't go that route because of the smp_call_function() in the cpu
> hotplug code. So we can't disable interrupts in that path.

Hmm, that's the tick_broadcast_on_off() stuff, right ?

Thanks,

	tglx
