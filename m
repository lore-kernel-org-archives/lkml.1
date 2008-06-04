Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbYFDNWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbYFDNWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758229AbYFDNWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:22:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38581 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180AbYFDNWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:22:15 -0400
Date: Wed, 4 Jun 2008 06:16:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Alok kataria" <alokkataria1@gmail.com>
Cc: akataria@vmware.com, "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Dan Hecht" <dhecht@vmware.com>, "Tim Mann" <mann@vmware.com>,
       "Zachary Amsden" <zach@vmware.com>, "Sahil Rihan" <srihan@vmware.com>
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
Message-ID: <20080604061637.6bab3f67@infradead.org>
In-Reply-To: <35f686220806032101h103152dat841818982aaa5052@mail.gmail.com>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com>
	<20080603182014.79a38d03@infradead.org>
	<35f686220806032101h103152dat841818982aaa5052@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2008 21:01:54 -0700
"Alok kataria" <alokkataria1@gmail.com> wrote:

> On Tue, Jun 3, 2008 at 6:20 PM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > On Tue, 03 Jun 2008 17:41:09 -0700
> > Alok Kataria <akataria@vmware.com> wrote:
> >
> >> On X86 platform we can use the value of cpu_khz computed during tsc
> >> calibration to calculate the loops_per_jiffy value. Its very
> >> important to keep the error in lpj values to minimum as any error
> >> in that may result in kernel panic in check_timer.
> >> In virtualization environment on a highly overloaded host, the
> >> guest delay calibration may sometimes result in errors beyond the
> >> ~50% that timer_irq_works can handle, resulting in the guest
> >> panicking.
> > \
> >
> > can you guarantee that the rate tsc ticks at is the same as the
> > current CPU frequency? Answer: You can't....
> >
> 
> I think at the boot time atleast we can assume that, no ?

Nope, absolutely not.
1) The rate TSC ticks may or may not be the maximum frequency (usually
is, but no guarantee)
2) The BIOS might not boot your system at the maximum frequency (think
"laptop on battery")... that's really up to the BIOS.

> 
> > sadly we do need to calibrate this...
> >
> > In addition, clearly you can have different cpus in a system run at
> > a different rate (both in terms of cpu_khz and, independently, in
> > terms of tsc rate)
> >
> 
> Again yes at run time frequency's may change but they shouldn't at
> boottime. AFAIK, i don't think there are X86 MP systems with
> asymmetric cpus i.e. systems with different
> base frequencies. If thats not true then there sure is a problem.

there's nothing that guarantees this. (Well maybe Dell's website does
because they want to sell you 2 expensive cpus rather than 1 cheap 1
expensive one ;-)

> 
> Thanks,
> Alok
> 
> >
> > --
> > If you want to reach me at my work email, use arjan@linux.intel.com
> > For development, discussion and tips for power savings,
> > visit http://www.lesswatts.org
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
