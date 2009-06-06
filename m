Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZFFMzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZFFMzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 08:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZFFMy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 08:54:57 -0400
Received: from www.tglx.de ([62.245.132.106]:48066 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbZFFMy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 08:54:57 -0400
Date: Sat, 6 Jun 2009 14:54:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tick: add check for the existence of broadcast clock
 event device
In-Reply-To: <20090606204736.00700bd0@feng-desktop>
Message-ID: <alpine.LFD.2.00.0906061450220.3419@localhost.localdomain>
References: <20090605112711.67e7d5cb@feng-desktop> <alpine.LFD.2.00.0906061121330.3419@localhost.localdomain> <20090606204736.00700bd0@feng-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feng,

On Sat, 6 Jun 2009, Feng Tang wrote:
> > If your percpu devices are always on (not affected by C3 stop) then
> > you never dereference bc. So why do we need an extra check for !bc ?
> 
> Hi tglx,

> Thanks for the explanation. But we really ran into the NULL pointer
> case, in our platform, there are 2 X86 CPUs which have lapic, also
> it has 2 external timers which are pretty similar with HPET timers,
> those 2 external timers will be used as per-cpu timers (higher
> rating than lapic timer). In system's power cycle of suspend and
> resume, disable_nontboot_cpus will be called before goto suspend
> state,and enable_nonboot_cpus will be called for the resume process,
> so lapic timer of cpu1 will be first registered as per-cpu timer,
> and our external timer will be registered later after get a
> CPU_ONLINE notifier (similar with HPET), right in this time slot
> that lapic is the per-cpu timer, when system get the
> CLOCK_EVT_BROADCAST_ENTER/EXIT msg, tick_do_broadcast_on_off() is
> called and hit the NULL pointer case.

Ok, I can understand now why we need it. I'll apply your patch and add
some more info into the commit msg so we do not look at it in a year
and scratch our heads. :)

> Our external timer driver is very similar with HPET dirver, why HPET
> doesn't see such an issue? becuase HPET has enough number of timers,
> and it use "hpet0" as the bc device, while our platform doesn't have
> a extra one to act as bc.

Correct.

Thanks,

	tglx
