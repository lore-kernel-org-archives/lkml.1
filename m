Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbXESEaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbXESEaa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 00:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbXESEaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 00:30:23 -0400
Received: from d06184cf.dreamhost.com ([208.97.132.207]:35624 "EHLO
	spaceymail-a1.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755143AbXESEaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 00:30:22 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] local_softirq_pending storm
Date: Sat, 19 May 2007 10:00:00 +0530
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>
References: <200705091942.22920.kernel@prachanda.hub> <200705171211.23350.kernel@prachanda.hub> <1179493277.12981.69.camel@chaos>
In-Reply-To: <1179493277.12981.69.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705191000.01208.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 May 2007 18:31:17 Thomas Gleixner wrote:
> On Thu, 2007-05-17 at 12:11 +0530, Anant Nitya wrote:
> > On Friday 11 May 2007 03:28:46 Thomas Gleixner wrote:
> > > Ok, that's consistent with earlier reports. The problem surfaces when
> > > one of the SMT-"cpus" goes idle. The problem goes away when you disable
> > > hyperthreading.
> >
> > Yes with HT disabled in BIOS there is no local_softirq_pending messages.
> > BTW why does this problem persist only with X ?
>
> No idea. I uploaded a debug patch against 2.6.22-rc1 to
>
> http://www.tglx.de/private/tglx/2.6.22-rc1-hrt-debug.patch
>
> Can you give it a try and report the output ?

I am compiling kernel with above patch applied and will post the results.

> > > When you apply the ratelimit patch, does the softlockup problem
> > > persist ?
> >
> > Yes, though softlockup is rare and mostly hit when system is under high
> > load. Apart of that I am also getting following messages consistently
> > across multiple boot cycles with NOHZ=y and ratelimit patch applied.
> >
> > May 15 11:51:22 rudra kernel: [ 2594.341068] Clocksource tsc unstable
> > (delta = 28111260302 ns)
> > May 15 11:51:22 rudra kernel: [ 2594.343194] Time: acpi_pm clocksource
> > has been installed.
>
> That's informal. The TSC is detected to be unstable and replaced by the
> pm timer. Nothing to worry about. It happens with NOHZ=n as well,
> right ?
Nope it don't appear with nohz=no till now across so many boot cycles, it 
always appears with nohz!=no.

Regards
Ananitya


