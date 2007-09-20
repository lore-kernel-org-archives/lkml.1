Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbXITOuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbXITOuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:50:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbXITOun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:50:43 -0400
Received: from www.osadl.org ([213.239.205.134]:59047 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755228AbXITOun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:50:43 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
In-Reply-To: <200709201647.33152.rjw@sisk.pl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <200709201612.37194.rjw@sisk.pl> <1190296432.3481.18.camel@chaos>
	 <200709201647.33152.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 16:50:40 +0200
Message-Id: <1190299841.3481.37.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 16:47 +0200, Rafael J. Wysocki wrote:
> On Thursday, 20 September 2007 15:53, Thomas Gleixner wrote:
> > On Thu, 2007-09-20 at 16:12 +0200, Rafael J. Wysocki wrote:
> > > > Vs. the suspend / resume wreckage of rc6-mm1 / rc6-hrt2: 
> > > 
> > > ie. the one on the Vaio (I assume).
> > > 
> > > > I'm still fishing in rather dark water. Depending on the added
> > > > instrumentation points the problem mutates up to the point where it
> > > > vanishes completely. The hang, which requires key strokes again, happens
> > > > consistently at the same place:
> > > > 
> > > > The notifier call in kernel/cpu.c::_cpu_up()
> > > > 
> > > >        ret = __raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE | mod, hcpu,
> > > >                                                         -1, &nr_calls);
> > > > 
> > > > does not return, but _all_ registered notifiers are called and reach
> > > > their return statement. This reminds me on:
> > > > 
> > > > http://lkml.org/lkml/2007/5/9/46
> > > > 
> > > > Sigh. I have no clue where to dig further.
> > > 
> > > Well, the above may affect SMP systems, but the Vaio is UP.  Hmm?
> > 
> > My jinxed VAIO variant is SMP, but it looks like the same mysterious
> > error.
> 
> Hm.  Have you tried
> 
> # echo test > /sys/power/disk
> # echo disk > /sys/power/state
> 
> (should suspend devices and disable the nonboot CPUs, wait for 5 sec. and
> restore everything)?

Works fine, but I need to reboot into a non debug kernel to verify.

	tglx



