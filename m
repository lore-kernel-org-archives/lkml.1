Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYGHF3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYGHF3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 01:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYGHF3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 01:29:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20680 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYGHF33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 01:29:29 -0400
Date: Mon, 7 Jul 2008 22:28:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Message-Id: <20080707222829.d79b6e2f.randy.dunlap@oracle.com>
In-Reply-To: <86802c440807071724i1a186879h479460ada28e1b26@mail.gmail.com>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik>
	<uBi7uNfg81L.A.XLC.s0LcIB@albercik>
	<20080706111750.a6d77e81.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0807061133230.3016@woody.linux-foundation.org>
	<20080707063218.GC23583@elte.hu>
	<20080707113917.6fda3f7d.randy.dunlap@oracle.com>
	<20080707154042.04bb492e.randy.dunlap@oracle.com>
	<86802c440807071724i1a186879h479460ada28e1b26@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008 17:24:16 -0700 Yinghai Lu wrote:

> On Mon, Jul 7, 2008 at 3:40 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Mon, 7 Jul 2008 11:39:17 -0700 Randy Dunlap wrote:
> >
> >> On Mon, 7 Jul 2008 08:32:18 +0200 Ingo Molnar wrote:
> >>
> >> >
> >> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >> >
> >> > > > This still happens with 2.6.26-rc9.  Using CONFIG_NUMA=y boots OK.
> >> > >
> >> > > Ok, then it wasn't the nr_zones thing.
> >> > >
> >> > > Since it seems to be repeatable for you, can you bisect it?
> >> >
> >> > one guess would be:
> >> >
> >> > | commit e8ee6f0ae5cd860e8e6c02807edfa3c1fa01bcb5
> >> > | Author: Yinghai Lu <yhlu.kernel@gmail.com>
> >> > | Date:   Sun Apr 13 01:41:58 2008 -0700
> >> > |
> >> > |     x86: work around io allocation overlap of HT links
> >> >
> >> > but ... since CONFIG_NUMA makes it work, i'm not sure about that.
> >> >
> >> > Randy, could you post the full CONFIG_NUMA bootlog as well, does it show
> >> > any difference in resource allocations?
> >>
> >> Good and bad boot logs are attached.  There are several differences, but I don't
> >> see any that are significant.
> >>
> >> I've started bisecting with:
> >>
> >> $ git bisect start
> >> $ git bisect bad v2.6.26-rc1
> >> $ git bisect good v2.6.25
> >>
> >> That's only about 1.29M lines of changes.
> >
> > git bisect and normal rebooting did not find a problem.
> >
> > I'll repeat this using kexec to boot the new kernel and see if that
> > locates any issues... since I normally use kexec to load/test new kernels
> > and that was how the failure occurred (occurs).
> >
> 
> same NON-NUMA kernel kexec NON-NUMA kernel?
> 
> or other kernel kexex it?

Ah.  Good question.  I hadn't noticed that.
NUMA kernel kexec-ing a non-NUMA kernel now fails, but it worked in 2.6.25.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
