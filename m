Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbXLJLuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbXLJLuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbXLJLtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:49:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:7893 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbXLJLto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:49:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iIsPeIk19FXTR3eyYsJBBghqeKxkRfdPtyYzpWbojnRe/FX4DaLiVmpsB6ufjsO7cw8Zr2y+8pdNz3LP4mulSWxTjPChbhktoI7uDNYQVaWPh5qPs8WGmAfyt71D7BvQjYcnysp1L+dtYKXI15TV3Jg926J5n/0W1KC2GPB+tC4=
Message-ID: <c03d1bd00712100349i2c878d94g3085ed78f23c247e@mail.gmail.com>
Date: Mon, 10 Dec 2007 17:19:43 +0530
From: "Gautham R Shenoy" <ego.lkml@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: broken suspend (sched related) [Was: 2.6.24-rc4-mm1]
Cc: "Gautham R Shenoy" <ego@in.ibm.com>, "Jiri Slaby" <jirislaby@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       "Dipankar Sarma" <dipankar@in.ibm.com>
In-Reply-To: <20071210112832.GA20189@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <475A629C.7010408@gmail.com> <475B24F4.3090904@gmail.com>
	 <20071209074647.GE22981@elte.hu> <20071210081952.GA7215@in.ibm.com>
	 <475CFF01.2090502@gmail.com> <20071210091052.GA14487@elte.hu>
	 <20071210101500.GB12880@in.ibm.com> <20071210102157.GB31103@elte.hu>
	 <20071210110818.GC12880@in.ibm.com> <20071210112832.GA20189@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 10, 2007 4:58 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Gautham R Shenoy <ego@in.ibm.com> wrote:
>
> > > say we've got 100 CPUs, so we've got 100 watchdog tasks running -
> > > one for each CPU. Checking for hung tasks is a global operation not
> > > a per-CPU operation (we iterate over the global tasklist), hence
> > > only one CPU should really be calling this function. That
> > > online-cpus logic achieves this by picking a single CPU. Perhaps it
> > > would be better to keep a hung_task_checker_cpu variable that is
> > > driven from a CPU-hotplug-down notifier? That way if a CPU is
> > > brought down we can update hung_task_checker_cpu to another,
> > > still-online CPU. (this would also be faster, because event-driven)
> >
> > Do you mean something like this?
>
> yeah, thanks - queued it up.

Stupid me! I forgot to remove the local variable check_cpu in static
int watchdog(void * __bind_cpu). Could you please correct it before
applying?

>
> one question:
>
> > +static int check_cpu = -1;
>
> >       case CPU_ONLINE:
> >       case CPU_ONLINE_FROZEN:
> > +             check_cpu = any_online_cpu(cpu_online_map);
> >               wake_up_process(per_cpu(watchdog_task, hotcpu));
> >               break;
>
> do we bring the boot CPU online too - i.e. will check_cpu be properly
> initialized on UP too?

Yes, it does.
>
>         Ingo
>

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
