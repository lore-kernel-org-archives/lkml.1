Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907Ab0AMQXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab0AMQXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 11:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949Ab0AMQXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 11:23:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab0AMQXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 11:23:16 -0500
Date: Wed, 13 Jan 2010 11:23:03 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: introduce NMI_AUTO as nmi_watchdog option
Message-ID: <20100113162303.GW24885@redhat.com>
References: <20100111191633.GT24885@redhat.com>
 <20100111202729.GI4923@lenovo>
 <20100111203356.GU24885@redhat.com>
 <20100113093240.GC6739@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113093240.GC6739@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 10:32:40AM +0100, Ingo Molnar wrote:
> > After looking through the code I just had some questions, perhaps you have 
> > thought about this longer than me, what to do with the reservation code 
> > (just remove it I assume and let perf_events _be_ the only code that
> >  handles perf events) and what to do with some of the cpu quirks as noted in 
> > perfctr-watchdog.c (notable some of the Intel errata for the Core chipsets).
> 
> Given the amount of quirks in the perctr code it might make sense to shape 
> this as a new feature initially: introduce a new NMI watchdog that is perf 
> based and has a different codebase.
> 
> Then, once it's capable enough and has been in circulation long enough we can 
> simply drop the old NMI watchdog. (without users noticing anything [modulo 
> bugs])
> 
> v1 should concentrate on x86 CPUs that are supported by perf currently. Note, 
> it _might_ make sense to do it via a new kernel/nmi_watchdog.c file - other 
> architectures have NMI concepts as well, such as Sparc64. A further idea would 
> be to maybe even merge it with the softlockup code in kernel/softlockup.c - so 
> that we dont have two sets of apis like touch_nmi_watchdog and 
> touch_softlockup_watchdog.

Ok, interesting.  Right now I am working on making sure I know how to
register something with the perf event framework (from kernel space).
Once I can do that, I'll expand it outward and see where it goes. :-)

> 
> So there's a wide spectrum of possibilities - the important thing is to start 
> small :-)

I see. Thanks.

Cheers,
Don
