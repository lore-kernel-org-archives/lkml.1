Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbYC1UYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbYC1UYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 16:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYC1UYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 16:24:34 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43644 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754788AbYC1UYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 16:24:33 -0400
Date: Fri, 28 Mar 2008 15:24:30 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] x86_64: Support for new UV apic
Message-ID: <20080328202430.GA13040@sgi.com>
References: <20080328191216.GA16455@sgi.com> <20080328201532.GB26555@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328201532.GB26555@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 09:15:32PM +0100, Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > Index: linux/arch/x86/kernel/apic_64.c
> > ===================================================================
> > --- linux.orig/arch/x86/kernel/apic_64.c	2008-03-28 13:00:22.000000000 -0500
> > +++ linux/arch/x86/kernel/apic_64.c	2008-03-28 13:06:12.000000000 -0500
> > @@ -738,6 +738,7 @@ void __cpuinit setup_local_APIC(void)
> >  	unsigned int value;
> >  	int i, j;
> >  
> > +	preempt_disable();
> >  	value = apic_read(APIC_LVR);
> >  
> >  	BUILD_BUG_ON((SPURIOUS_APIC_VECTOR & 0x0f) != 0x0f);
> > @@ -831,6 +832,7 @@ void __cpuinit setup_local_APIC(void)
> >  	else
> >  		value = APIC_DM_NMI | APIC_LVT_MASKED;
> >  	apic_write(APIC_LVT1, value);
> > +	preempt_enable();
> >  }
> 
> hm, this looks a bit weird - why are all the preempt-disable/enable 
> calls needed?

The first patch had a preempt disable/enable in the function
that reads apicid (see read_apic_id() in arch/x86/kernel/genapic_64.c).
This seemed necessary since large system generate an apicid by reading
the live id & concatenating it with extra bits.

One of the review comments suggested that I change the preempt to a WARN()
since reading apic_id really should be done with preemtion disabled. The
added code eliminates the warnings.


--- jack
