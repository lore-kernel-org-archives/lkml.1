Return-Path: <linux-kernel-owner+w=401wt.eu-S1759731AbXJLK6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759731AbXJLK6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 06:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbXJLK6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 06:58:12 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:53808 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbXJLK6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 06:58:11 -0400
Message-ID: <470F5341.6030906@free.fr>
Date: Fri, 12 Oct 2007 12:58:09 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>
CC: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: NMI watchdog
References: <470F3BE0.4050807@free.fr> <20071012100043.GA28777@atjola.homenet>
In-Reply-To: <20071012100043.GA28777@atjola.homenet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Steinbrink wrote:

> John Sigler wrote:
> 
>> I'm experiencing a full system lockup. I'm using an out-of-tree driver 
>> which I suspect is responsible. I'm trying to enable the NMI watchdog.
>>
>> # cat /proc/version
>> Linux version 2.6.22.1-rt9 (gcc version 3.4.6) #1 PREEMPT RT Tue Oct 9 
>> 12:25:47 CEST 2007
>>
>> # cat /proc/cmdline
>> ro root=/dev/hdc1 console=ttyS0,57600n8 console=tty0 panic=3 apic=debug 
>> nmi_watchdog=2
>>
>> However, after boot, the NMI count does not change.
>>
>> # cat /proc/interrupts ; sleep 10 ; cat /proc/interrupts
> 
> Try running some cpu hog in the background. The performance counters get
> increased only when the CPU is actually doing something. On a mostly
> idle system, it can take quite a while for the next NMI to show up.

You are right. In another shell, I ran while true; do : ; done

# cat /proc/interrupts ; sleep 10 ; cat /proc/interrupts
            CPU0
   0:        100   IO-APIC-edge      timer
   4:         82   IO-APIC-edge      serial
   8:          1   IO-APIC-edge      rtc
   9:          0   IO-APIC-fasteoi   acpi
  15:      13648   IO-APIC-edge      ide1
  16:       1303   IO-APIC-fasteoi   eth0
  17:        575   IO-APIC-fasteoi   eth1
  18:        575   IO-APIC-fasteoi   eth2
  19:        575   IO-APIC-fasteoi   eth3
NMI:       2889
LOC:     115768
ERR:          0
MIS:          0

            CPU0
   0:        100   IO-APIC-edge      timer
   4:         82   IO-APIC-edge      serial
   8:          1   IO-APIC-edge      rtc
   9:          0   IO-APIC-fasteoi   acpi
  15:      13672   IO-APIC-edge      ide1
  16:       1310   IO-APIC-fasteoi   eth0
  17:        580   IO-APIC-fasteoi   eth1
  18:        580   IO-APIC-fasteoi   eth2
  19:        580   IO-APIC-fasteoi   eth3
NMI:       2899
LOC:     116770
ERR:          0
MIS:          0

The performance counter appears to be configured to fire when the event 
count for CPU_CLK_UNHALTED reaches 2,400,000,000 (I have a 2.4 GHz CPU) 
i.e. one NMI per second when the CPU is 100% busy. Is that correct?

On a related note, I have a Pentium 3 which counts CPU_CLK_UNHALTED 
cycles even when the CPU is halted. I was told this is a bug, but it 
actually sounds like a a nice feature!

Is there really no way to have the event counter increment with every 
tick (even when the CPU is halted) on a P4?

Regards.
