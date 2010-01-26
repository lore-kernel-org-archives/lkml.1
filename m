Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362Ab0AZMlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab0AZMlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046Ab0AZMlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:41:08 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:62211 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0AZMlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:41:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WXCWuxM/ROZgibVBF+44KbhA/bovox440RsW4PO8ZLArU+nKFklhV92e8KqipIKtId
         exeChRYJ1XzUboNG84JiRsPG8FR+PM59A46lZ+PCPj8a9fb30U+KY5Plq1silm4hsuP0
         WDnd+uBKgrYkfngp8MecuWe1KYFqq5dPd1icg=
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
From: peng huang <huangpeng.linux@gmail.com>
To: Jeff Garrett <jeff@jgarrett.org>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20100126084740.GA5265@jgarrett.org>
References: <20100126084740.GA5265@jgarrett.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 21:41:00 +0900
Message-ID: <1264509660.29891.7.camel@huang-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
can you show me the file /proc/acpi/processor/CPU*/power.
and are you sure your cpu usage is 0 or nearly zero.

this is the info of my laptop(using core 2 processors):
powertop's output:
Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        (10.6%)         2.00 Ghz     1.9%
C0                0.0ms ( 0.0%)         1.67 Ghz     0.1%
C1 mwait          0.0ms ( 0.0%)         1333 Mhz     0.0%
C2 mwait          0.0ms ( 0.0%)         1000 Mhz    98.0%
C3 mwait          1.1ms (89.4%)


and power things:
huang@huang-laptop:~$ cat /proc/acpi/processor/CPU0/power 
active state:            C0
max_cstate:              C8
maximum allowed latency: 2000000000 usec
states:
    C1:                  type[C1] promotion[--] demotion[--]
latency[001] usage[00002364] duration[00000000000000000000]
    C2:                  type[C2] promotion[--] demotion[--]
latency[001] usage[00070662] duration[00000000000006013816]
    C3:                  type[C3] promotion[--] demotion[--]
latency[017] usage[04774185] duration[00000000010838418152]

you can see C3 with powertop,so i think your BIOS has enabled Deep 
C-state.

-huang

2010-01-26 (火) の 02:47 -0600 に Jeff Garrett さんは書きました:
> Hi,
> 
> I was trying to chase down a theory that my desktop machine (a core i7)
> is running warm (the fan sounds like it's at full speed all the time,
> and I think it's not always acted this way -- hence the theory).
> 
> powertop is never showing it spending any time in C3...
> 
> I compiled a kernel without USB/sound/radeon, and ran without X.  I was
> able to get the wakeups/sec down below 20, but no time is spent in C3.
> 
> sysfs looks to agree with powertop here (time = 0 on C3):
> /sys/devices/system/cpu/cpu0/cpuidle/state0/desc: CPUIDLE CORE POLL IDLE
> /sys/devices/system/cpu/cpu0/cpuidle/state0/latency: 0
> /sys/devices/system/cpu/cpu0/cpuidle/state0/name: C0
> /sys/devices/system/cpu/cpu0/cpuidle/state0/power: 4294967295
> /sys/devices/system/cpu/cpu0/cpuidle/state0/time: 457
> /sys/devices/system/cpu/cpu0/cpuidle/state0/usage: 59
> /sys/devices/system/cpu/cpu0/cpuidle/state1/desc: ACPI FFH INTEL MWAIT 0x0
> /sys/devices/system/cpu/cpu0/cpuidle/state1/latency: 1
> /sys/devices/system/cpu/cpu0/cpuidle/state1/name: C1
> /sys/devices/system/cpu/cpu0/cpuidle/state1/power: 1000
> /sys/devices/system/cpu/cpu0/cpuidle/state1/time: 308177
> /sys/devices/system/cpu/cpu0/cpuidle/state1/usage: 3975
> /sys/devices/system/cpu/cpu0/cpuidle/state2/desc: ACPI FFH INTEL MWAIT 0x10
> /sys/devices/system/cpu/cpu0/cpuidle/state2/latency: 17
> /sys/devices/system/cpu/cpu0/cpuidle/state2/name: C2
> /sys/devices/system/cpu/cpu0/cpuidle/state2/power: 500
> /sys/devices/system/cpu/cpu0/cpuidle/state2/time: 873440787
> /sys/devices/system/cpu/cpu0/cpuidle/state2/usage: 239038
> /sys/devices/system/cpu/cpu0/cpuidle/state3/desc: ACPI FFH INTEL MWAIT 0x20
> /sys/devices/system/cpu/cpu0/cpuidle/state3/latency: 17
> /sys/devices/system/cpu/cpu0/cpuidle/state3/name: C3
> /sys/devices/system/cpu/cpu0/cpuidle/state3/power: 350
> /sys/devices/system/cpu/cpu0/cpuidle/state3/time: 0
> /sys/devices/system/cpu/cpu0/cpuidle/state3/usage: 0
> 
> This may be a complete red herring, but I added some printk logic to
> acpi_idle_bm_check(), and it is getting called often, but bm_status is
> always 1.  [I infer from this that the idle logic is trying to go into
> C3, but this check is stopping it...  Unless I misread something.]
> 
> Is this expected behavior or is this a legitimate problem?
> 
> How might I investigate this further?
> 
> Attaching dmesg, /proc/cpuinfo, powertop -d output.
> 
> Thanks,
> Jeff Garrett


-- 
peng huang <huangpeng.linux@gmail.com>

