Return-Path: <linux-kernel-owner+w=401wt.eu-S965499AbXBFVRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965499AbXBFVRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965500AbXBFVRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:17:33 -0500
Received: from www.osadl.org ([213.239.205.134]:50971 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965499AbXBFVRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:17:32 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Thomas Gleixner <tglx@linutronix.de>
To: dwalker@mvista.com
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1170794437.3455.20.camel@dwalker1>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <1170777802.9781.353.camel@imap.mvista.com> <1170786992.3785.0.camel@chaos>
	 <1170787543.9781.362.camel@imap.mvista.com> <1170788870.3785.9.camel@chaos>
	 <1170791739.3455.3.camel@dwalker1>  <1170793206.3785.16.camel@chaos>
	 <1170794437.3455.20.camel@dwalker1>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 22:17:44 +0100
Message-Id: <1170796664.3785.26.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 12:40 -0800, Daniel Walker wrote:
> > Yes, it is different. Why are you insisting, that something is a problem
> > just because it is different ?
> 
> In this case "different" goes into userspace .. So different could mean
> userspace regression, which is something that we don't want. I have no
> idea if any apps use /proc/interrupts , but it's possible since it's
> been around for a long time.

It _IS_ statistics info about the number of interrupts and has no fixed
meaning at all. It does not cause any user space regression, as the
interface is still the same. It produces different numbers, like the
clock_getres() syscall returns different values on highres and !highres
systems.

> The reason that I'm bringing it up at all is because people have ask me
> "Why isn't my timer ticking??"

So it's a problem of user perception and not of a user space regression.
Please stop confusing things.

> Your saying we can't remove it tho, if /proc/interrupts is not related
> to timers why does the entry exist at all ? Your saying the LOC entry is
> the new "timer" entry, but we still have the old "timer" entry ..

Ok. Each irqaction struct which is used to request/setup an interrupt
contains a name field. This is the one which shows up
in /proc/interrupts. The one which is used to setup irq0 has .name =
"timer". 

> Getting confusing ..

Sigh.

> It might be nicer to list all the registered clock event sources
> in /proc/interrupts, with more descriptive names .. 

No. No. No. clockevents has nothing to do with /proc/interrupts.

/proc/interrupts is the statistics interface for the IRQ subsystem.

> Why is it that HRT doesn't use the "timer" as a valid timer?

Because local apic timer is better.

	tglx


