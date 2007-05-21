Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbXEUHtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbXEUHtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbXEUHto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:49:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:36062 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754602AbXEUHto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:49:44 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1/VSVhfuH3VMYNfX5XBWQ7Mk/bK8WyN0JIFbZav2d
	EPEyRnDS3omdca
Date: Mon, 21 May 2007 09:49:38 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de, mingo@elte.hu, yi.zhu@intel.com,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       venkatesh.pallipadi@intel.com, trenn@suse.de
Subject: Re: Increased ipw2200 power usage with dynticks
Message-ID: <20070521074938.GA15678@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, mingo@elte.hu,
	yi.zhu@intel.com, linux-kernel@vger.kernel.org, arjan@infradead.org,
	venkatesh.pallipadi@intel.com, trenn@suse.de
References: <20070518154629.GA27105@atjola.homenet> <20070519171011.GA1995@atjola.homenet> <p733b1re34o.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <p733b1re34o.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.05.20 20:55:35 +0200, Andi Kleen wrote:
> Björn Steinbrink <B.Steinbrink@gmx.de> writes:
> > 
> > Ok, it seems that ipw2200 is just a trigger for the problem here. AFAICT
> > the cause of the worse C state usage is that after ipw2200 has woken the
> > cpu, acpi_processor_idle() chooses C2 (due to dma? bm? I have no
> > idea...) as the prefered sleep state. Now without NO_HZ or when I hold
> > down a key, there are interrupts that wake up the CPU and when
> > acpi_processor_idle() is called again the promotion to C3/C4 happens.
> > But with NO_HZ, there are no such interrupts, most wakeups are caused by
> > ipw2200 and so the processor doesn't go any deeper than C2 most of the
> > time and thus wastes lots of power.
> 
> The cpuidle governour code Venki is working on is supposed to address this.
> There have been also earlier prototype patches by Adam Belay and
> Thomas Renninger.

Venki (at least I think it was him) also told me about cpuidle and the
menu governor on #powertop. Unfortunately, cpuidle seems to be gone from
acpi-test (or I'm simply still too stupid for git/gitweb). I manually
added the cpuidle and menu governor patches on top of my 2.6.22-rc1-hrt8
kernel, but that broke C-state duration accounting.

On the bright side of things is power usage though, which is down to an
incredible 13.9W in idle+ipw2200 :)

Thanks,
Björn

