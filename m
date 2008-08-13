Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbYHMVXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbYHMVXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 17:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYHMVXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 17:23:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:15855 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbYHMVXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 17:23:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,203,1217833200"; 
   d="scan'208";a="606551687"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Milan Plzik <milan.plzik@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Date: Wed, 13 Aug 2008 14:22:32 -0700
Subject: RE: Possible CPU_IDLE bug [WAS: Re: Timer unstability on when	using
 C2	and deeper sleep states (Dell Latitude XT)]
Thread-Topic: Possible CPU_IDLE bug [WAS: Re: Timer unstability on when
	using C2	and deeper sleep states (Dell Latitude XT)]
Thread-Index: Acj9gjAGl2N+oyX1TGudLHOz5ils3QAB8zrg
Message-ID: <7E82351C108FA840AB1866AC776AEC460945BFF2@orsmsx505.amr.corp.intel.com>
References: <1218566008.13866.41.camel@localhost>
	 <1218625125.4304.7.camel@localhost> <1218636980.5250.12.camel@localhost>
	 <7E82351C108FA840AB1866AC776AEC460945BB44@orsmsx505.amr.corp.intel.com>
 <1218658873.4336.15.camel@localhost>
In-Reply-To: <1218658873.4336.15.camel@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Milan Plzik [mailto:milan.plzik@gmail.com]
>Sent: Wednesday, August 13, 2008 1:21 PM
>To: Pallipadi, Venkatesh
>Cc: linux-kernel@vger.kernel.org
>Subject: RE: Possible CPU_IDLE bug [WAS: Re: Timer unstability
>on when using C2 and deeper sleep states (Dell Latitude XT)]
>
>On St, 2008-08-13 at 11:14 -0700, Pallipadi, Venkatesh wrote:
>>
>> >-----Original Message-----
>> >From: linux-kernel-owner@vger.kernel.org
>> >[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Milan Plzik
>> >Sent: Wednesday, August 13, 2008 7:16 AM
>> >To: linux-kernel@vger.kernel.org
>> >Subject: Possible CPU_IDLE bug [WAS: Re: Timer unstability on
>> >when using C2 and deeper sleep states (Dell Latitude XT)]
>> >
>> >  Hello again,
>> >
>> >On St, 2008-08-13 at 12:58 +0200, Milan Plzik wrote:
>> >> I apologize for replying on my own mail (and also for
>> >top-posting, but
>> >> this information is global update, not exactly fitting
>any of topics
>> >> mentioned below).
>> >>
>> >>   After playing for a longer while I found out that the
>system ends
>> >> sometimes in state where, in order to do anything useful,
>I need to
>> >> press keys on keyboard. Otherwise, the system just stalls and does
>> >> nothing. I have no idea why does this happen (especially
>when I know
>> >> that OHCI or wireless network adapter produce fair amount of
>> >> interrupts). My /proc/interrupts is below. Just for the record,
>> >> chipset
>> >> on board is ATI RS600 with (apparently from lspci) ATI SB600
>> >> southbridge.
>> >
>> >  it looks like this problem disappears if CONFIG_CPU_IDLE option is
>> >disabled, system seems to be stable for more than one hour. This
>> >suggests that something may be wrong with the CPU_IDLE
>code. I can not
>> >spend much more time by debugging the kernel, but if anyone has an
>> >suggestion about what to fix, I will gladly test it.
>> >
>> >  Best regards,
>> >        Milan Plzik
>>
>> It may not be a problem with cpuidle code per se. We have
>had issues earlier like this one
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=10011
>>
>> Cpuidle tries to go to C3 state aggressively and thus may be
>indirectly causing the problem with graphics hardware or
>something like that.
>>
>> From Dave's comment in the above bugzilla:
>> can you try with Option "DRI" "Off" in your xorg.conf
>>
>> Does that change anything?
>
>  The DRI flag itself seems to have little to no effect on
>what actually
>happens. I noticed that the problems are really visible with
>CONFIG_HZ_1000 and no preemption, other settings seem to blur the
>problem a little (but it seems to be still there). I did some
>additional
>testing, below are the results. Testing programs were: powertop (ran
>immediately after booting), X server startup and starting mplayer with
>some videos.
>
>1) plain boot witho processor.max_cstate not set, DRI off:
>  (boot process seemed to stall here and there)
>  a) powertop on console (before running X server) returns bogus
>numbers, like 20000 wakeups/sec.
>  b) starting X server -- succeeds, but only after tapping keys on
>keyboard, otherwise seems to stall.
>  c) mplayer seems to get stuck here and there, keypresses help and it
>is able to play a little more of the video for a while.
>  d) additional observation: keyboard autorepeat stopped (mostly)
>working, though it was enabled in both X server and console
>
>2) processor.max_cstate=2, DRI off
>  a) powertop on console starts giving rational numbers, such as 300
>wakeups/sec
>  b) X server seems to start correctly
>  c) mplayer seems to play files for a while, then it starts flickering
>as if it wasn't able to keep up with speed; at the same time powertop
>reports 90% of time spent in C2
>
>2a) processor.max_cstate=2, DRI on (just changed X server configuration
>without reboot)
>  video playback seems to be more stable, but that might be just GPU
>acceleration
>
>3) processor.max_cstate=2, DRI on after cold reboot
>  symptoms like with attempt 1), but powertop returns correct numbers
>
>4) processor.max_cstate=1, DRI on
>  in this state I'm writing this e-mail and so far seems to be
>stable :)
>
><guess>
>  I can just guess what causes these problems... . 1) might seem like
>improper timer setup after resuming from C3 (at least that
>would explain
>that weird powertop numbers).
>
>  The issue with keyboard needing to be pressed seems more like some
>race condition, when sometimes the interrupts are not properly enabled
>-- sometimes it works, sometimes not.
></guess>
>
>  I hope these results will help at least a little. If something other
>is neccessary, I'll try to do it ASAP.
>

Were all these tests with 2.6.26? Can you try with 2.6.27-rc3?

There is one bugfix patch that, IIRC, went in after 2.6.26.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b8f8c3cf0a4ac0632ec3f0e15e9dc0c29de917af

Thanks,
Venki
