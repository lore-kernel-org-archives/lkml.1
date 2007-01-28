Return-Path: <linux-kernel-owner+w=401wt.eu-S932268AbXA1Ffv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbXA1Ffv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 00:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932410AbXA1Ffv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 00:35:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:44769 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268AbXA1Ffu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 00:35:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VFbSpOhPZimymdihl05LPWmx+CMPhZBH6u7v//4EJ+ZN3Wp4PMtf7bPPZ7JpjS4ADnNisI8vyVDGzYP6NuU3Ak0oSSTZsCprpBQXFu4c7L2ryR1hseBb8JJJIWMCRxFYw2jVBiSFs1sQJGqPNOcF5FolvfuZF26wEYnK3EI99h4=
Message-ID: <8355959a0701272135p150bb95dkf62dbfc07c0cdccc@mail.gmail.com>
Date: Sun, 28 Jan 2007 11:05:48 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: 2.6.20-rc6-rt2 - SMP/x86 -- questions about .config selection
Cc: "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I did boot with (almost) no problems. Here is ps ax info:-

 PID TTY      STAT   TIME COMMAND
    1 ?        Ss     0:00 init [5]
    2 ?        S      0:00 [migration/0]
    3 ?        S      0:00 [posix_cpu_timer]
    4 ?        S      0:00 [softirq-high/0]
    5 ?        S      0:00 [softirq-timer/0]
    6 ?        S      0:00 [softirq-net-tx/]
    7 ?        S      0:00 [softirq-net-rx/]
    8 ?        S      0:00 [softirq-block/0]
    9 ?        S      0:00 [softirq-tasklet]
   10 ?        S      0:00 [softirq-sched/0]
   11 ?        S      0:00 [softirq-hrtimer]
   12 ?        S      0:00 [softirq-rcu/0]
   13 ?        S<     0:00 [desched/0]
   14 ?        S      0:00 [migration/1]
   15 ?        S      0:00 [posix_cpu_timer]
   16 ?        S      0:00 [softirq-high/1]
   17 ?        S      0:00 [softirq-timer/1]
   18 ?        S      0:00 [softirq-net-tx/]
   19 ?        S      0:00 [softirq-net-rx/]
   20 ?        S      0:00 [softirq-block/1]
   21 ?        S      0:00 [softirq-tasklet]
   22 ?        S      0:00 [softirq-sched/1]
   23 ?        S      0:00 [softirq-hrtimer]
   24 ?        S      0:00 [softirq-rcu/1]
   .........
   .........

Here is the interrupt info:-

           CPU0       CPU1
  0:        354          0   IO-APIC-edge      timer
  1:        361          0   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          7          0   IO-APIC-edge      i8042
 14:       1985          0   IO-APIC-edge      ide0
 16:      13042          0   IO-APIC-fasteoi   uhci_hcd:usb4, HDA
Intel, i915@pci:0000:00:02.0
 18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb3
 19:      11520          0   IO-APIC-fasteoi   uhci_hcd:usb2, libata
 20:          2          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5
 21:        515          0   IO-APIC-fasteoi   eth0
NMI:          0          0
LOC:      23573      24545
ERR:          0
MIS:          0


I did get REMINDER, the following debugging options are turned on in
your .config:

        CONFIG_CRITICAL_IRQSOFF_TIMING
        CONFIG_FUNCTION_TRACE

This I have understood, no issues here.

There is some confusion for me while configuring a rt kernel &
proceeding for experiments. I did choose the following:-

NO_HZ=y
HIGH_RES_TIMERS=y
SMP=y
PREEMPT_VOLUNTARY=y
PREEMPT_SOFTIRQS=y
PREEMPT_HARDIRQS=y
SPINLOCK_BKL=y
CLASSIC_RCU=y
SCHED_SMT=y
IRQBALANCE=y
HZ_1000=y


#1 Is this correct to say PREEMPT_VOLUNTARY=y  for rt on this desktop PC?
#2 I am not clear about IRQ config selection (which one should be
enable/disable for a PC, I did select all as shown in the above
config). Any suggestion?
#3 Any other parameter(s) I need to enable/disable to get better
results? (did disable APM)


Thanks,

~Su37
