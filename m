Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZI3HvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZI3HvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 03:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZI3HvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 03:51:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbZI3HvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 03:51:12 -0400
Date: Wed, 30 Sep 2009 09:50:43 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, gregkh@suse.de
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 
 hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 
 __sysdev_resume+0xc3/0xe0()
Message-ID: <20090930095043.48e7081f@hammerfall>
In-Reply-To: <2674af740909290231m5af0fbc6t5fba0b127c63bd9f@mail.gmail.com>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
	<2674af740909270127s464a3cb2xef5e7f4cd61b0eb7@mail.gmail.com>
	<20090929072454.GA11414@elte.hu>
	<2674af740909290231m5af0fbc6t5fba0b127c63bd9f@mail.gmail.com>
Organization: Red Hat Czech
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Tue, 29 Sep 2009 17:31:43 +0800
Yong Zhang <yong.zhang0@gmail.com> napsal(a):

> On Tue, Sep 29, 2009 at 3:24 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > Could you try this with .32-rc1? This commit should have fixed the
> > message above:
> >
> > 89133f9: clocksource: Resume clocksource without taking the
> > clocksource mutex
> >
> 
> Hi Ingo,
> 
> Indeed, Maciej said this issue is gone with .32-rc1. But I don't think
> this is the same
> issue with 89133f9 because in this one timekeeping_resume() is called
> with irq enabled.
> This is very odd and the bug exists in other parts.

It is the same issue. Maciej has CONFIG_PREEMPT_VOLUNTARY=y which means
taking the mutex in clocksource_resume() could have called into
schedule(), thus enabling irqs.

Michal
