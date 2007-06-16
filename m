Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbXFPWvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbXFPWvX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 18:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbXFPWvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 18:51:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46754 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924AbXFPWu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 18:50:58 -0400
Date: Sat, 16 Jun 2007 15:49:46 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: netdev <netdev@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Michael Buesch <mb@bu3sch.de>, Gary Zambrano <zambrano@broadcom.com>,
       "Jeff Garzik" <jgarzik@pobox.com>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
Subject: Re: b44: high ping times with wireless-dev
Message-ID: <20070616154946.5fb6b013@localhost.localdomain>
In-Reply-To: <200706162327.47413.maxi@daemonizer.de>
References: <200706162327.47413.maxi@daemonizer.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2007 23:27:43 +0200
Maximilian Engelhardt <maxi@daemonizer.de> wrote:

> Hello,
> 
> I recently did some test and found out something interesting about the b44 
> problem I wrote earlier. 
> 
> The problem is the following:
> When I use my BCM4401 with the b44 driver in wireless-dev I get very high ping 
> times looking like this:
> 
> 64 bytes from 172.30.10.1: icmp_seq=1 ttl=64 time=1863 ms
> 64 bytes from 172.30.10.1: icmp_seq=2 ttl=64 time=855 ms
> 64 bytes from 172.30.10.1: icmp_seq=3 ttl=64 time=1855 ms
> 64 bytes from 172.30.10.1: icmp_seq=4 ttl=64 time=855 ms
> 64 bytes from 172.30.10.1: icmp_seq=5 ttl=64 time=1854 ms
> 64 bytes from 172.30.10.1: icmp_seq=6 ttl=64 time=854 ms
> 64 bytes from 172.30.10.1: icmp_seq=7 ttl=64 time=1851 ms
> 64 bytes from 172.30.10.1: icmp_seq=8 ttl=64 time=851 ms
> 64 bytes from 172.30.10.1: icmp_seq=9 ttl=64 time=1851 ms
> 64 bytes from 172.30.10.1: icmp_seq=10 ttl=64 time=851 ms
> 
> I also found out that shortly after I boot my laptop and log into kde ping 
> times are not that high but start to increase very quickly:
> 
> 64 bytes from 172.30.10.1: icmp_seq=53 ttl=64 time=2.19 ms
> 64 bytes from 172.30.10.1: icmp_seq=54 ttl=64 time=2.22 ms
> 64 bytes from 172.30.10.1: icmp_seq=55 ttl=64 time=2.20 ms
> 64 bytes from 172.30.10.1: icmp_seq=56 ttl=64 time=2.20 ms
> 64 bytes from 172.30.10.1: icmp_seq=57 ttl=64 time=18.6 ms
> 64 bytes from 172.30.10.1: icmp_seq=58 ttl=64 time=1268 ms
> 64 bytes from 172.30.10.1: icmp_seq=59 ttl=64 time=268 ms
> 64 bytes from 172.30.10.1: icmp_seq=60 ttl=64 time=1268 ms
> 64 bytes from 172.30.10.1: icmp_seq=61 ttl=64 time=268 ms
> 64 bytes from 172.30.10.1: icmp_seq=62 ttl=64 time=6.08 ms
> 64 bytes from 172.30.10.1: icmp_seq=63 ttl=64 time=268 ms
> 64 bytes from 172.30.10.1: icmp_seq=64 ttl=64 time=1264 ms
> 64 bytes from 172.30.10.1: icmp_seq=65 ttl=64 time=264 ms
> 
> After some time digging around I found out something really interesting. When 
> I play some music ping times are immediately lower. If I stop playing music 
> they are back to the same times as they were before.
> 
> I guess that there is a problem with interrupts so I post some information of 
> my system in hope it will be usefull.
> 
> maxi@koala:~$ cat /proc/interrupts
>           CPU0       
>  0:     126317    XT-PIC-XT        timer
>  1:       3600    XT-PIC-XT        i8042
>  2:          0    XT-PIC-XT        cascade
>  7:          1    XT-PIC-XT        parport0
>  8:          1    XT-PIC-XT        rtc
>  9:      17371    XT-PIC-XT        acpi
> 10:      13237    XT-PIC-XT        firewire_ohci, yenta, yenta, ehci_hcd:usb1, 
> uhci_hcd:usb3, uhci_hcd:usb4, Intel 82801DB-ICH4, Intel 82801DB-ICH4 Modem, 
> eth0
> 11:      89059    XT-PIC-XT        uhci_hcd:usb2, i915@pci:0000:00:02.0
> 12:        632    XT-PIC-XT        i8042
> 14:      10354    XT-PIC-XT        libata
> 15:       7408    XT-PIC-XT        libata
> NMI:          0 
> ERR:          0
> 
> 
> [...]
> ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
> ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10 (level, low) -> 
> IRQ 10
> ssb: Sonics Silicon Backplane found on PCI device 0000:02:02.0
> b44.c:v2.0
> eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:c0:9f:29:99:a7
> [...]
> 
> This problem did only happen with wireless-dev (checkout this evening) and 
> with -mm kernels I used some time ago for testing. Currently I'm running 
> 2.6.22-rc4 that works perfectly fine and doesn't show that problem.
> 
> Maxi

Can you build with APIC for uniprocessor.

There is lots of IRQ sharing, so
 - one of the other device's may be not handling shared IRQ properly.
   Try unloading firewhire modem and yenta devices.

 - IRQ might be set edge triggered which doesn't work with NAPI
	or shared IRQ.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
