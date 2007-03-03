Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbXCCMFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbXCCMFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 07:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXCCMFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 07:05:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35045 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbXCCMFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 07:05:18 -0500
Date: Sat, 3 Mar 2007 03:57:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>, Len Brown <lenb@kernel.org>,
       git@vger.kernel.org
Subject: Re: [patch] KVM: T60 resume fix
Message-Id: <20070303035742.72eed3df.akpm@linux-foundation.org>
In-Reply-To: <45E93012.4000100@qumranet.com>
References: <20070227103407.GA17819@elte.hu>
	<20070227105922.GD2250@kernel.dk>
	<20070227111515.GA4271@kernel.dk>
	<20070301093450.GA8508@elte.hu>
	<20070301104117.GA22788@elte.hu>
	<20070301145204.GA25304@elte.hu>
	<Pine.LNX.4.64.0703011536450.12485@woody.linux-foundation.org>
	<20070302072100.GB30634@elte.hu>
	<20070302080441.GA12785@elte.hu>
	<20070302102018.GA11549@elte.hu>
	<20070302102216.GA13575@elte.hu>
	<45E93012.4000100@qumranet.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 10:21:38 +0200 Avi Kivity <avi@qumranet.com> wrote:

> Ingo Molnar wrote:
> > Subject: [patch] KVM: T60 resume fix
> > From: Ingo Molnar <mingo@elte.hu>
> >
> > my T60 laptop does not resume correctly due to KVM attempting to send an 
> > IPI to a CPU that might be down (or not up yet). (Doing so also triggers 
> > the send_IPI_mask_bitmask() warning in arch/i386/kernel/smp.c, line 
> > 732.)
> >
> > with this fix applied my laptop does not hang during resume.
> >
> > [ KVM will have to disable/enable virtualization on the CPU itself that
> >   goes down / comes up, not via an IPI sent from the requesting CPU. ]
> >
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  drivers/kvm/kvm_main.c |    6 ------
> >  1 file changed, 6 deletions(-)
> >
> > Index: linux/drivers/kvm/kvm_main.c
> > ===================================================================
> > --- linux.orig/drivers/kvm/kvm_main.c
> > +++ linux/drivers/kvm/kvm_main.c
> > @@ -2083,12 +2083,6 @@ static int kvm_cpu_hotplug(struct notifi
> >  	case CPU_DEAD:
> >  	case CPU_UP_CANCELED:
> >  		decache_vcpus_on_cpu(cpu);
> > -		smp_call_function_single(cpu, kvm_arch_ops->hardware_disable,
> > -					 NULL, 0, 1);
> > -		break;
> > -	case CPU_UP_PREPARE:
> > -		smp_call_function_single(cpu, kvm_arch_ops->hardware_enable,
> > -					 NULL, 0, 1);
> >  		break;
> >  	}
> >  	return NOTIFY_OK;
> >   
> 
> That is already CPU_ONLINE in my tree

I noticed ;)

So this mean that Ingo's bug should already be fixed there.  And in rc2-mm1.

> (and in the pull request sent to 
> Linus a couple of days ago).

Resend, please.
