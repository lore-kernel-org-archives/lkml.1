Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYHLTDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYHLTDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 15:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYHLTDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 15:03:07 -0400
Received: from isilmar.linta.de ([213.133.102.198]:57253 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751791AbYHLTDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 15:03:06 -0400
Date: Tue, 12 Aug 2008 21:03:02 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, S K <nospamnoham@gmail.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080812190302.GA26751@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Arjan van de Ven <arjan@infradead.org>,
	Adrian Bunk <bunk@kernel.org>, S K <nospamnoham@gmail.com>,
	Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com> <200808092059.47863.trenn@suse.de> <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com> <1218418431.6671.52.camel@yakui_zhao.sh.intel.com> <514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com> <20080811042244.469f8e1d@infradead.org> <20080811140206.GB3338@cs181140183.pp.htv.fi> <20080811071128.0165be50@infradead.org> <20080811193316.GA16631@isilmar.linta.de> <20080811165816.679cfdb9@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811165816.679cfdb9@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Mon, Aug 11, 2008 at 04:58:16PM -0700, Arjan van de Ven wrote:
> > Hi,
> > 
> > On Mon, Aug 11, 2008 at 07:11:28AM -0700, Arjan van de Ven wrote:
> > > 1) when the cpu is idle (as in "idle loop C states/hlt"; p4_clockmod
> > > doesn't mean anything.. the clock is stopped not just skipped.
> > > 2) when the cpu is executing code (eg non-idle), it takes more power
> > > for a unit of time than it takes when it's idle
> > 
> > This statement might be true, but might also be wrong:
> > 	a) on systems where only C1 is exported, p4-clockmod most
> > often equals the state the CPU is in when in C1[*], 
> 
> that's.. not entirely true btw.

well, the spec isn't really clear about this. It says (IA32 Intel
Architecture Software Developer's Manual, Volume 3, section 13.14.3) that
P6 family processors did this using STPCLK#. And STPCLK# was also used by the
chipset to force the CPU to enter C2, IIRC.
Do P4s only do an C1-equivalent (or even less than that) now, as they do the
thermal throttling internally instead of externally using STPCLK#?

> >so we're in a 
> > 	   win-win, or lose-lose situation.
> 
> even if it were EXACTLY identical (which it isn't).. you would be at
> BEST a tie... not a savings. so it's lose-lose or tie-tie, but never win

If it's C2-equivalent vs. C1, it's a win. So throttling would be a win from
this perspective on a only C1-capable PIII, but not on a P4? Is that what
you're trying to hint at here?

To summarize:

(1) p6 family processors use STPCLK# initiated by the chipset for thermal
    throttling.
(2) STPCLK# is also used by the chipset to make the CPU enter C2.
(3) p4-clockmod uses the STPCLK#-equivalent in p4 CPUs.
(4) Therefore, it is as effective as STPCLK#, and as effective as C2.
(5) STPCLK#/C2 has higher energy savings than hlt/C1.
(6) therefore, p4-clockmod might make sense on systems which only export C1
    as an idle state.

Where's my mistake?

Thanks,
	Dominik
