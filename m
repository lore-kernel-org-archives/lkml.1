Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbYHLUAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbYHLUAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYHLT7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:59:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:38871 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYHLT7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:59:51 -0400
Date: Tue, 12 Aug 2008 12:59:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Adrian Bunk <bunk@kernel.org>, S K <nospamnoham@gmail.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080812125946.59a0669c@infradead.org>
In-Reply-To: <20080812190302.GA26751@isilmar.linta.de>
References: <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
	<200808092059.47863.trenn@suse.de>
	<514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
	<1218418431.6671.52.camel@yakui_zhao.sh.intel.com>
	<514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com>
	<20080811042244.469f8e1d@infradead.org>
	<20080811140206.GB3338@cs181140183.pp.htv.fi>
	<20080811071128.0165be50@infradead.org>
	<20080811193316.GA16631@isilmar.linta.de>
	<20080811165816.679cfdb9@infradead.org>
	<20080812190302.GA26751@isilmar.linta.de>
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

On Tue, 12 Aug 2008 21:03:02 +0200
Dominik Brodowski <linux@dominikbrodowski.net> wrote:

> Hi Arjan,
> 
> On Mon, Aug 11, 2008 at 04:58:16PM -0700, Arjan van de Ven wrote:
> > > Hi,
> > > 
> > > On Mon, Aug 11, 2008 at 07:11:28AM -0700, Arjan van de Ven wrote:
> > > > 1) when the cpu is idle (as in "idle loop C states/hlt";
> > > > p4_clockmod doesn't mean anything.. the clock is stopped not
> > > > just skipped. 2) when the cpu is executing code (eg non-idle),
> > > > it takes more power for a unit of time than it takes when it's
> > > > idle
> > > 
> > > This statement might be true, but might also be wrong:
> > > 	a) on systems where only C1 is exported, p4-clockmod most
> > > often equals the state the CPU is in when in C1[*], 
> > 
> > that's.. not entirely true btw.
> 
> well, the spec isn't really clear about this. It says (IA32 Intel
> Architecture Software Developer's Manual, Volume 3, section 13.14.3)
> that P6 family processors did this using STPCLK#. And STPCLK# was
> also used by the chipset to force the CPU to enter C2, IIRC.

not quite.. if it does for a certain cpu, then it's only for cpus that
support C2.


> Do P4s only do an C1-equivalent (or even less than that) now, as they
> do the thermal throttling internally instead of externally using
> STPCLK#?

it's basically always less (or really best case equal) than c1 just due
to the really short duration
> 

> If it's C2-equivalent vs. C1, it's a win. 

it's not. 

>So throttling would be a
> win from this perspective on a only C1-capable PIII, but not on a P4?
> Is that what you're trying to hint at here?

not even on PIII is it a win.. it's just too short a duration 
and your C2 theory.. not sure I believe it.


> 
> To summarize:
> 
> (1) p6 family processors use STPCLK# initiated by the chipset for
> thermal throttling.
> (2) STPCLK# is also used by the chipset to make the CPU enter C2.

well.... sometimes. It's more complex generally.

> (3) p4-clockmod uses the STPCLK#-equivalent in p4 CPUs.
> (4) Therefore, it is as effective as STPCLK#, and as effective as C2.

This is not correct. C2 is only effective if you stay in it "long
enough". Otherwise you pay the transition cost twice.


> (5) STPCLK#/C2 has higher energy savings than hlt/C1.

incorrect



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
