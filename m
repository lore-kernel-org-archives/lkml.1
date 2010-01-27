Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785Ab0A0N1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab0A0N1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489Ab0A0N1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:27:21 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:45662 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab0A0N1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:27:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CXl1w9rFdh4ENGKoaam3XumYyw49RjbuoaagJfZyaCEgoyB2g0fgAgy3Y3ZPH39+ST
         Nli7roKx23KzDmZ9LHNQOliSdEGyMvbnR3Dg3XNDWXQzfycMvSMBBOLBFrXq79yxP6Nt
         svfNWCQf2VeEJmCV8ZUb+xZ5rQrKKgR39lKN8=
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
From: peng huang <huangpeng.linux@gmail.com>
To: Jeff Garrett <jeff@jgarrett.org>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, huangpeng.linux@gmail.com
In-Reply-To: <20100126145951.GA4987@jgarrett.org>
References: <20100126084740.GA5265@jgarrett.org>
	 <1264509660.29891.7.camel@huang-laptop>
	 <20100126145951.GA4987@jgarrett.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 22:27:17 +0900
Message-ID: <1264598837.32649.9.camel@huang-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-01-26 (火) の 08:59 -0600 に Jeff Garrett さんは書きました:
> On Tue, Jan 26, 2010 at 09:41:00PM +0900, peng huang wrote:
> > Hi,
> > can you show me the file /proc/acpi/processor/CPU*/power.
> > and are you sure your cpu usage is 0 or nearly zero.
> 
> Yea, I'm pretty sure my cpu usage is nearly zero.  powertop shows fewer
> than 20 wakeups per second, shows 99% C2 residency, top shows 100% idle,
> perf top shows acpi_idle_enter_simple as the most common function
> (~50%).  Very little is running on the box, and I've compiled out the
> heavier parts of the kernel (such as USB)...
> 
> (It still has ordinary userspace running, e.g. udev & hal, and still has
> sshd and network traffic, as examples.)
> 
> This is all consistent with a very idle machine, I think.

yes,you processor is always in c2,it does means your system is nearly
ilde.

> > this is the info of my laptop(using core 2 processors):
> > powertop's output:
> > Cn                Avg residency       P-states (frequencies)
> > C0 (cpu running)        (10.6%)         2.00 Ghz     1.9%
> > C0                0.0ms ( 0.0%)         1.67 Ghz     0.1%
> > C1 mwait          0.0ms ( 0.0%)         1333 Mhz     0.0%
> > C2 mwait          0.0ms ( 0.0%)         1000 Mhz    98.0%
> > C3 mwait          1.1ms (89.4%)
> 
> Yea, my laptop also (also core 2) has 700-1000 wakeups/sec and spends
> greater than 80% of its time in C3...  That's partly why I'm curious
> about what my core i7 desktop is doing.

So I think it is a core i7 thing.I have heard that some intel cpu have a
problem when in c2-state,maybe that is why you cpu cant enter c3-state.
I think there is some configuration about deep c-state in the bios,may
be you can try it(it cannot solve this problem...).
And in some bios there is a enhanced idle state configuration ,but i
dont known if it is the reason why the cpu cannot enter c3-state.You can
try it anyway.

With disable the deep c-state you BIOS will not give c3-info to the
OS,then you would see there is no c3-state in the OS.

> > and power things:
> > huang@huang-laptop:~$ cat /proc/acpi/processor/CPU0/power 
> > active state:            C0
> > max_cstate:              C8
> > maximum allowed latency: 2000000000 usec
> > states:
> >     C1:                  type[C1] promotion[--] demotion[--]
> > latency[001] usage[00002364] duration[00000000000000000000]
> >     C2:                  type[C2] promotion[--] demotion[--]
> > latency[001] usage[00070662] duration[00000000000006013816]
> >     C3:                  type[C3] promotion[--] demotion[--]
> > latency[017] usage[04774185] duration[00000000010838418152]
> > 
> > you can see C3 with powertop,so i think your BIOS has enabled Deep 
> > C-state.
> 
> Here's my power files...
> 
> /proc/acpi/processor/CPU0/power:
> active state:            C0
> max_cstate:              C8
> maximum allowed latency: 2000000000 usec
> states:
>     C1:                  type[C1] promotion[--] demotion[--] latency[001] usage[00001470] duration[00000000000000000000]
>     C2:                  type[C2] promotion[--] demotion[--] latency[017] usage[00234416] duration[00000000017165798539]
>     C3:                  type[C3] promotion[--] demotion[--] latency[017] usage[00000000] duration[00000000000000000000]
> /proc/acpi/processor/CPU1/power:
> active state:            C0
> max_cstate:              C8
> maximum allowed latency: 2000000000 usec
> states:
>     C1:                  type[C1] promotion[--] demotion[--] latency[001] usage[00000481] duration[00000000000000000000]
>     C2:                  type[C2] promotion[--] demotion[--] latency[017] usage[00090169] duration[00000000017188463157]
>     C3:                  type[C3] promotion[--] demotion[--] latency[017] usage[00000000] duration[00000000000000000000]
> /proc/acpi/processor/CPU2/power:
> active state:            C0
> max_cstate:              C8
> maximum allowed latency: 2000000000 usec
> states:
>     C1:                  type[C1] promotion[--] demotion[--] latency[001] usage[00000418] duration[00000000000000000000]
>     C2:                  type[C2] promotion[--] demotion[--] latency[017] usage[00068874] duration[00000000017193805291]
>     C3:                  type[C3] promotion[--] demotion[--] latency[017] usage[00000000] duration[00000000000000000000]
> /proc/acpi/processor/CPU3/power:
> active state:            C0
> max_cstate:              C8
> maximum allowed latency: 2000000000 usec
> states:
>     C1:                  type[C1] promotion[--] demotion[--] latency[001] usage[00001356] duration[00000000000000000000]
>     C2:                  type[C2] promotion[--] demotion[--] latency[017] usage[00362752] duration[00000000017156707397]
>     C3:                  type[C3] promotion[--] demotion[--] latency[017] usage[00000000] duration[00000000000000000000]
> 
> > 
> > -huang
> > 
> > 2010-01-26 (火) の 02:47 -0600 に Jeff Garrett さんは書きました:
> > > Hi,
> > > 
> > > I was trying to chase down a theory that my desktop machine (a core i7)
> > > is running warm (the fan sounds like it's at full speed all the time,
> > > and I think it's not always acted this way -- hence the theory).
> > > 
> > > powertop is never showing it spending any time in C3...
> > > 
> > > I compiled a kernel without USB/sound/radeon, and ran without X.  I was
> > > able to get the wakeups/sec down below 20, but no time is spent in C3.
> > > 
> > > sysfs looks to agree with powertop here (time = 0 on C3):
> > > /sys/devices/system/cpu/cpu0/cpuidle/state0/desc: CPUIDLE CORE POLL IDLE
> > > /sys/devices/system/cpu/cpu0/cpuidle/state0/latency: 0
> > > /sys/devices/system/cpu/cpu0/cpuidle/state0/name: C0
> > > /sys/devices/system/cpu/cpu0/cpuidle/state0/power: 4294967295
> > > /sys/devices/system/cpu/cpu0/cpuidle/state0/time: 457
> > > /sys/devices/system/cpu/cpu0/cpuidle/state0/usage: 59
> > > /sys/devices/system/cpu/cpu0/cpuidle/state1/desc: ACPI FFH INTEL MWAIT 0x0
> > > /sys/devices/system/cpu/cpu0/cpuidle/state1/latency: 1
> > > /sys/devices/system/cpu/cpu0/cpuidle/state1/name: C1
> > > /sys/devices/system/cpu/cpu0/cpuidle/state1/power: 1000
> > > /sys/devices/system/cpu/cpu0/cpuidle/state1/time: 308177
> > > /sys/devices/system/cpu/cpu0/cpuidle/state1/usage: 3975
> > > /sys/devices/system/cpu/cpu0/cpuidle/state2/desc: ACPI FFH INTEL MWAIT 0x10
> > > /sys/devices/system/cpu/cpu0/cpuidle/state2/latency: 17
> > > /sys/devices/system/cpu/cpu0/cpuidle/state2/name: C2
> > > /sys/devices/system/cpu/cpu0/cpuidle/state2/power: 500
> > > /sys/devices/system/cpu/cpu0/cpuidle/state2/time: 873440787
> > > /sys/devices/system/cpu/cpu0/cpuidle/state2/usage: 239038
> > > /sys/devices/system/cpu/cpu0/cpuidle/state3/desc: ACPI FFH INTEL MWAIT 0x20
> > > /sys/devices/system/cpu/cpu0/cpuidle/state3/latency: 17
> > > /sys/devices/system/cpu/cpu0/cpuidle/state3/name: C3
> > > /sys/devices/system/cpu/cpu0/cpuidle/state3/power: 350
> > > /sys/devices/system/cpu/cpu0/cpuidle/state3/time: 0
> > > /sys/devices/system/cpu/cpu0/cpuidle/state3/usage: 0
> > > 
> > > This may be a complete red herring, but I added some printk logic to
> > > acpi_idle_bm_check(), and it is getting called often, but bm_status is
> > > always 1.  [I infer from this that the idle logic is trying to go into
> > > C3, but this check is stopping it...  Unless I misread something.]
> > > 
> > > Is this expected behavior or is this a legitimate problem?
> > > 
> > > How might I investigate this further?
> > > 
> > > Attaching dmesg, /proc/cpuinfo, powertop -d output.
> > > 
> > > Thanks,
> > > Jeff Garrett
> > 
> > 
> > -- 
> > peng huang <huangpeng.linux@gmail.com>
> > 


-- 
peng huang <huangpeng.linux@gmail.com>

