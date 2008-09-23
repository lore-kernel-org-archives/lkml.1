Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYIWRdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYIWRdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYIWRdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:33:11 -0400
Received: from www.tglx.de ([62.245.132.106]:33530 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626AbYIWRdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:33:10 -0400
Date: Tue, 23 Sep 2008 19:30:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
In-Reply-To: <48D921B3.2060809@redhat.com>
Message-ID: <alpine.LFD.1.10.0809231927060.2038@apollo.tec.linutronix.de>
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com> <48D7F5E8.3000705@redhat.com> <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com> <48D81B5F.2030702@redhat.com> <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
 <48D832B6.3010409@redhat.com> <33307c790809221712x4fbd9781u958c98d4585e92a9@mail.gmail.com> <48D901FE.5060604@redhat.com> <20080923150410.GA28341@Krystal> <48D90B84.4030905@redhat.com> <alpine.LFD.1.10.0809230847360.3265@nehalem.linux-foundation.org>
 <48D921B3.2060809@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008, Masami Hiramatsu wrote:
> > So if you can test this, try it with 
> >  (a) cpufreq at a fixed _low_ value (to not cause overheating)
> >  (b) with the spray-can cooling the thing and cpufreq at a fixed high 
> >      value
> > and see if the TSC is constant then.
> 
> Hi Linus,
> 
> Thank you for your advice. I tested it again according your advice,
> I did:
> - service cpuspeed stop
> - echo 1000000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
>   and checked /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq is
>   1000000.
> - echo 1 >  /proc/acpi/thermal_zone/THM/polling_frequency
> - cooling with spray-can :)
> - cat /proc/acpi/thermal_zone/THM/temperature
>   temperature:             39 C
> 
> and ran the test.
> ---
> p0: c:1107576,	 ns:990280	 ratio:111
> p0: c:1805640,	 ns:1008787	 ratio:178
> p0: c:1998324,	 ns:1000127	 ratio:199
> p0: c:946380,	 ns:990280	 ratio:95
> p0: c:871728,	 ns:1000267	 ratio:87
> p0: c:1807380,	 ns:1007949	 ratio:179
> p0: c:1784808,	 ns:1000127	 ratio:178
> p0: c:1768488,	 ns:991676	 ratio:178
> p0: c:1802292,	 ns:1008299	 ratio:178
> p0: c:1787088,	 ns:1000406	 ratio:178
> p0: c:1999176,	 ns:1000896	 ratio:199
> p0: c:881364,	 ns:991956	 ratio:88
> p0: c:1802712,	 ns:1008019	 ratio:178
> p0: c:1787088,	 ns:998590	 ratio:178
> ---
> this seems not so stable yet. :-(
> 
> After test I checked temperature again.
> # cat /proc/acpi/thermal_zone/THM/temperature
> temperature:             39 C
> 
> Hmm, 39 C is not so high. I wouldn't be surprised even if this
> is an individual product bug. Anyway, currently, Linux itself
> works well on this laptop with hpet.:-)

Do you have C-States enabled on that machine ?

ls /sys/devices/system/cpu/cpu0/cpuidle/

has it more than a state0 entry ?

If yes, please do:

cat /sys/devices/system/cpu/cpu0/cpuidle/stateX/usage

where X is the highest number in there.

cat /proc/acpi/processor/CPU0/power

might be useful as well.

Thanks,

	tglx
