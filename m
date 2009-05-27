Return-Path: <linux-kernel-owner+w=401wt.eu-S1760987AbZE0VNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760987AbZE0VNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 17:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbZE0VMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 17:12:53 -0400
Received: from www.tglx.de ([62.245.132.106]:40346 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbZE0VMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 17:12:52 -0400
Date: Wed, 27 May 2009 23:12:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alok Kataria <alokkataria1@gmail.com>
cc: Jon Hunter <jon-hunter@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       akataria@vmware.com
Subject: Re: [PATCH 1/2] Dynamic Tick: Prevent clocksource wrapping during
 idle
In-Reply-To: <35f686220905271354l5f372d39t28700b1cf29ce6b2@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0905272312000.3397@localhost.localdomain>
References: <4A1D52E3.3040204@ti.com> <35f686220905271354l5f372d39t28700b1cf29ce6b2@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Alok Kataria wrote:

> On Wed, May 27, 2009 at 7:49 AM, Jon Hunter <jon-hunter@ti.com> wrote:
> >
> > The dynamic tick allows the kernel to sleep for periods longer than a single
> > tick. This patch prevents that the kernel from sleeping for a period longer
> > than the maximum time that the current clocksource can count. This ensures
> > that the kernel will not lose track of time. This patch adds a new function
> > called "timekeeping_max_deferment()" that calculates the maximum time the
> > kernel can sleep for a given clocksource.
> >
> 
> >From the patch description I understand that this will avoid wrapping
> around for only the *current* clocksource. What happens if, say, TSC
> is the clocksource and ACPI_PM is being used as the
> watchdog_clocksource, in that case the timekeeping_max_deferement will
> give TSC' max allowed sleep value (which is greater than ACPI_PMs).
> i.e. We could still sleep beyond ACPI_PM's wrap around threshold which
> may result in us marking TSC as unsuable as a clocksource.
> That could still result in incorrect timekeeping right ?

No, because the watchdog timer takes care of that. It wakes up at time.

Thanks,

	tglx
