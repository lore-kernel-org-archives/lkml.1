Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYBIXmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYBIXmc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 18:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbYBIXm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 18:42:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:17454 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915AbYBIXmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 18:42:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,328,1199692800"; 
   d="scan'208";a="337507177"
Message-ID: <47AE3958.6000504@intel.com>
Date: Sat, 09 Feb 2008 15:38:00 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Martin Rogge <marogge@onlinehome.de>, e1000-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: e1000 1sec latency problem
References: <200802091107.27284.marogge@onlinehome.de>	 <200802092100.04631.marogge@onlinehome.de> <47AE2071.10206@intel.com> <2c0942db0802091401t23489593t4a25e77dc877f0ec@mail.gmail.com>
In-Reply-To: <2c0942db0802091401t23489593t4a25e77dc877f0ec@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:
> On Feb 9, 2008 1:51 PM, Kok, Auke <auke-jan.h.kok@intel.com> wrote:
>> Martin Rogge wrote:
>>> On Saturday 09 February 2008 11:07:26 Martin Rogge wrote:
>>>> Hi,
>>>>
>>>> I am not so familiar with the various mailing lists and missed out on
>>>> e1000-devel@lists.sourceforge.net the first time. Please cc me on any
>>>> replies.
>>>>
>>>> I am looking for help with either making the e1000e driver work on my
>>>> Thinkpad T60 or fixing the 1s latency issue with e1000.
>>>>
>>>> To be honest, I do not understand why the e1000e driver failed to recognize
>>>> the NIC when I tried. At least, I noticed the correct device ID is defined
>>>> in drivers/net/e1000e/hw.h:
>>>>
>>>> #define E1000_DEV_ID_82573L                        0x109A
>>>>
>>>> Any help is appreciated.
>>>>
>>>> Thanks,
>>>>
>>>> Martin
>>>>
>>>> ----------  Forwarded Message  ----------
>>>>
>>>> Subject: Re: e1000 1sec latency problem
>>>> Date: Thursday 07 February 2008
>>>> From: Martin Rogge <marogge@onlinehome.de>
>>>> To: linux-kernel@vger.kernel.org
>>>>
>>>> Pavel Machek wrote:
>>>>> Hi!
>>>>>
>>>>> I have the famous e1000 latency problems:
>>>> Hi, I have the same problem with my Thinkpad T60.
>>>>
>>>> root@zorro:~# ping arnold
>>>> PING arnold (192.168.158.6) 56(84) bytes of data.
>>>> 64 bytes from arnold (192.168.158.6): icmp_seq=1 ttl=64 time=49.7 ms
>>>> 64 bytes from arnold (192.168.158.6): icmp_seq=2 ttl=64 time=0.438 ms
>>>> 64 bytes from arnold (192.168.158.6): icmp_seq=3 ttl=64 time=1000 ms
>>>> 64 bytes from arnold (192.168.158.6): icmp_seq=4 ttl=64 time=0.970 ms
>>>> 64 bytes from arnold (192.168.158.6): icmp_seq=5 ttl=64 time=885 ms
>>>> 64 bytes from arnold (192.168.158.6): icmp_seq=6 ttl=64 time=0.484 ms
>>>> 64 bytes from arnold (192.168.158.6): icmp_seq=7 ttl=64 time=529 ms
>>>> 64 bytes from arnold (192.168.158.6): icmp_seq=8 ttl=64 time=1.02 ms
>>>> 64 bytes from arnold (192.168.158.6): icmp_seq=9 ttl=64 time=149 ms
>>>> 64 bytes from arnold (192.168.158.6): icmp_seq=10 ttl=64 time=0.549 ms
>>>> 64 bytes from arnold (192.168.158.6): icmp_seq=11 ttl=64 time=0.829 ms
>>>>
>>>> --- arnold ping statistics ---
>>>> 11 packets transmitted, 11 received, 0% packet loss, time 9999ms
>>>> rtt min/avg/max/mdev = 0.438/238.113/1000.967/365.279 ms, pipe 2
>>>> root@zorro:~# uname -a
>>>> Linux zorro 2.6.24 #6 SMP PREEMPT Sun Feb 3 18:27:48 CET 2008 i686 Intel(R)
>>>> Core(TM)2 CPU         T7200  @ 2.00GHz GenuineIntel GNU/Linux
>>>> root@zorro:~# lspci -vvv
>>> [stuff deleted]
>>>
>>>> Unfortunately the e1000e driver is not an option as it will not detect the
>>>> NIC:
>>>>
>>>> ----from dmesg with e1000 compiled in:
>>>> Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
>>>> Copyright (c) 1999-2006 Intel Corporation.
>>>> ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
>>>> PCI: Setting latency timer of device 0000:02:00.0 to 64
>>>> e1000: 0000:02:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1)
>>>> 00:15:58:c3:3a:71
>>>> e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
>>>>
>>>> ----from dmesg with e1000e compiled in:
>>>> e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
>>>> e1000e: Copyright (c) 1999-2007 Intel Corporation.
>>>>
>>>> Any pointers?
>>>>
>>>> Thanks,
>>>>
>>>> Martin
>>>>
>>>>
>>>>
>>>> -------------------------------------------------------
>>> Just for the records, I googled the following solution for the Lenovo T60:
>>>
>>> (a) use the e1000 driver
>>> (b) if compiling as a module, add the following parameter to modprobe.conf:
>>> options e1000 RxIntDelay=5
>>> (c) if compiling a static driver, use the following patch (based on 2.6.24):
>>>
>>> --- e1000_param.c.orig        2008-01-24 23:58:37.000000000 +0100
>>> +++ e1000_param.c     2008-02-09 20:42:23.000000000 +0100
>>> @@ -158,7 +158,7 @@
>>>   * Valid Range: 0-65535
>>>   */
>>>  E1000_PARAM(RxIntDelay, "Receive Interrupt Delay");
>>> -#define DEFAULT_RDTR                   0
>>> +#define DEFAULT_RDTR                   5
>>>  #define MAX_RXDELAY               0xFFFF
>>>  #define MIN_RXDELAY                    0
>>>
>>> After reboot, the average ping time is still factor 10 worse than it should
>>> be, but it stays below 2 ms (which is a remarkable improvement compared to
>>> 1000 ms).
>> correct, this was a workaround which improved things for most people, but did not
>> *fix* it.
>>
>> the real fix is to disable L1 ASPM alltogether at the cost of more power
>> consumption, which is what is in e1000e in 2.6.25-git.
> 
> e1000e doesn't recognize his NIC. Will you be adding this to the e1000
> driver as well?


no, from 2.6.25 onwards e1000e will support 82573 nics, so you'll have to migrate
drivers, and you will get the fix automatically that way.

after 2.6.25 releases, support for all pci-e nics will be removed from the e1000
driver.

Cheers

Auke
