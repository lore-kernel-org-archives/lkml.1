Return-Path: <linux-kernel-owner+w=401wt.eu-S1161808AbXDYSKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161808AbXDYSKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161864AbXDYSKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:10:19 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41407 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161808AbXDYSKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:10:17 -0400
Subject: Re: [3/3] 2.6.21-rc7: known regressions (v2)
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Guilherme Schroeder <guilherme@centralinf.com.br>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Mikael Pettersson <mikpe@it.uu.se>, ak@suse.de,
       linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>
In-Reply-To: <20070425040605.6d6b4a82.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
	 <20070423214909.GD3468@stusta.de>
	 <20070425040605.6d6b4a82.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 25 Apr 2007 11:08:52 -0700
Message-Id: <1177524532.6401.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 04:06 -0700, Andrew Morton wrote:
> On Mon, 23 Apr 2007 23:49:09 +0200 Adrian Bunk <bunk@stusta.de> wrote:
> 
> > This email lists some known regressions in Linus' tree compared to 2.6.20.
> > 
> > If you find your name in the Cc header, you are either submitter of one
> > of the bugs, maintainer of an affectected subsystem or driver, a patch
> > of you caused a breakage or I'm considering you in any other way
> > possibly involved with one or more of these issues.
> > 
> > Due to the huge amount of recipients, please trim the Cc when answering.
> > 
> > 
> > Subject    : HPET enabled freeze my machine at boot
> >              workaround: clocksource=acpi_pm
> > References : http://lkml.org/lkml/2007/4/19/370
> > Submitter  : Guilherme Schroeder <guilherme@centralinf.com.br>
> > Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> >              commit 5d8b34fdcb384161552d01ee8f34af5ff11f9684
> > Handled-By : John Stultz <johnstul@us.ibm.com>
> > Status     : problem is being debugged
> > 
> > 
> > Subject    : acpi_pm clocksource loses time on x86-64
> > References : http://lkml.org/lkml/2007/4/17/143
> > Submitter  : Mikael Pettersson <mikpe@it.uu.se>
> > Handled-By : John Stultz <johnstul@us.ibm.com>
> > Status     : problem is being debugged
> > 
> > 
> > Subject    : suspend to disk hangs  (CONFIG_NO_HZ)
> > References : http://lkml.org/lkml/2007/3/25/217
> > Submitter  : Jeff Chua <jeff.chua.linux@gmail.com>
> > Status     : unknown
> 
> That's still rather a lot of bustage from the timekeeping changes.  Is
> anything really happening here or have we all given up?


The ACPI PM one is *really* odd as its the same clocksource driver on
both arches. I had Mikael cut out the clocksource frequency adjustments,
and confirmed both i386 and x86_64 are using the same base freq
(confirmed via printks).

It almost seems like when booting x86_64 the ACPI PM counter is running
slowly! 

Len: Have you ever heard of such a thing? It seems quite unlikely...


WRT the HPET freeze issue, I'm still digging there. In that case it
appears the HPET isn't counting, so timekeeping just stops. I was
thinking it might be HRT messing w/ the wrong HPET registers, but so far
that hasn't shaken out.

I'll spend some more time on these today and see if we get any further.

thanks
-john


