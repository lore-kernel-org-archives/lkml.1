Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYH0BeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYH0BeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 21:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYH0BeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 21:34:06 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:36816 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752936AbYH0BeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 21:34:03 -0400
Message-ID: <48B4AE68.4040205@snapgear.com>
Date: Wed, 27 Aug 2008 11:31:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Parag Warudkar <parag.lkml@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Rusty Russell <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-embedded@vger.kernel.org
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>	 <200808261111.19205.rusty@rustcorp.com.au>	 <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>	 <20080826183051.GB10925@cs181140183.pp.htv.fi>	 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>	 <20080826205916.GB11734@cs181140183.pp.htv.fi>	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>	 <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>	 <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>	 <48B4A577.3020303@snapgear.com> <f7848160808261808p3391c99ekfa1d8991bbf73c10@mail.gmail.com>
In-Reply-To: <f7848160808261808p3391c99ekfa1d8991bbf73c10@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Parag Warudkar wrote:
> On Tue, Aug 26, 2008 at 8:53 PM, Greg Ungerer <gerg@snapgear.com> wrote:
> 
>> I have some simple devices (network access/routers) with 8MB of RAM,
>> at power up not really being configured to do anything running 25
>> processes. (Heck there is over 10 kernel processes running!). Configure
>> some interfaces and services and that will easily push past 40.
>> I'd be happy with a 160k saving :-)
>>
> 
> So you really need to run all 25 processes on that 8Mb box?

Yes, of course. Considerable effort has been put into running
a minimal set of processes (that still for fills the required function
set of this device).


> (For reference even the NGW100 development board comes with 16Mb RAM).

Lots of development boards are fitted with lots of RAM.

And the pressure will still be on in _real_ products to reduce
the RAM footprint as much as possible. There are exceptions but
generally less is cheaper. Simple economics really.


> Even if you do need those all 25 processes on the 8Mb box, fixing the
> memory usage of those user space hogs is lot better than trying to
> save 160Kb in kernel stacks.

Yep, been done too. You don't squeeze a lot into these smaller
devices without looking at everything in it.


> Last I looked, user space wasn't particularly frugal with memory usage.

Then you haven't looked in the right places :-)

There are plenty of choices for making things small in user space.
Simple stuff like using uClibc, busybox, etc.

In this specific example things like /bin/init is 10k, /bin/inetd
is 10k, /bin/crond is 11k, etc. (Ofcourse it is a shared uClibc setup,
uClibc is ~300k). And XIP can help out here too.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
