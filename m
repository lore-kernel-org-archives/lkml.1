Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYHKOLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYHKOLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYHKOLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:11:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:42926 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYHKOLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:11:32 -0400
Date: Mon, 11 Aug 2008 07:11:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: S K <nospamnoham@gmail.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080811071128.0165be50@infradead.org>
In-Reply-To: <20080811140206.GB3338@cs181140183.pp.htv.fi>
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
	<200808081430.43012.trenn@suse.de>
	<aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
	<200808092059.47863.trenn@suse.de>
	<514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
	<1218418431.6671.52.camel@yakui_zhao.sh.intel.com>
	<514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com>
	<20080811042244.469f8e1d@infradead.org>
	<20080811140206.GB3338@cs181140183.pp.htv.fi>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 17:02:06 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Mon, Aug 11, 2008 at 04:22:44AM -0700, Arjan van de Ven wrote:
> > On Sun, 10 Aug 2008 21:44:50 -0700
> > "S K" <nospamnoham@gmail.com> wrote:
> > 
> > > > But it is very strange that cpufreq scaling can work on Windows
> > > > XP. Will you please try the P4 clock cpufreq driver and see
> > > > whether the scaling can work ? In fact P4 clock cpufreq driver
> > > > is already replaced by acpi_cpufreq driver for the latest cpu.
> > > > Anyway please try p4 clock cpufreq driver.
> > > 
> > > What is the name of the driver? I'm not able to find any such
> > > driver in Fedora 9 installed modules. There is only acpi-cpufreq
> > > and powernow-k8.
> > 
> > yeah don't bother with p4-clockmod, it's not something that saves
> > you energy... it only gives you a fake feeling that you would.
> 
> This statement is only true for HPC environments and when you measure 
> Watts per work done.
> 
> But if you have some desktop or server with a load that is determined
> by when it gets used, then p4-clockmod can actually save energy when
> the computer is not under high load or even idle.
> 
> Or do I miss anything?

yes you're missing quite a few things...
lets build this up

1) when the cpu is idle (as in "idle loop C states/hlt"; p4_clockmod
doesn't mean anything.. the clock is stopped not just skipped.
2) when the cpu is executing code (eg non-idle), it takes more power
for a unit of time than it takes when it's idle
3) when the cpu is in thermal throttle (p4_clockmod) and does a
throttle cycle, it'll take less power for that cycle than a full
execution (at least of the power intensive type of instruction), but
more than if it would have been in idle.

now lets take your "Light load" example (light could mean anything less
than 100% cpu use for all I care) and lets assume a 50% throttle (just
because it makes the explenation simpler, not fundamental)

in 50% thermal throttle, after every cycle a throttle cycle is
inserted, this means that code that gets executed will take 2x as long
basically.

take your lightly loaded case, and lets say you have 20% CPU
utilization in the unthrottled case (again, random number, works with
any number). Now with the thermal throttle, you suddenly take 40%.

so before you had for one second "20% expensive, 80% low power" 
now you have for one second "20% expensive, 20% throttle power, 60% low
power"

since throttle power is higher than low/idle power.. you lose.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
