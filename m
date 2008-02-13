Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbYBMSwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbYBMSwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759962AbYBMSwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:52:16 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:36750 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758305AbYBMSwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:52:15 -0500
Message-ID: <47B33C56.3070502@inria.fr>
Date: Wed, 13 Feb 2008 19:52:06 +0100
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Paul Mundt <lethal@linux-sh.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Purpose of numa_node?
References: <47A11ACD.1090400@redhat.com> <20080131074045.GA13788@linux-sh.org>	 <47A1D03A.3020508@inria.fr>	 <86802c440801311329h67a79139xa33994e2cc116781@mail.gmail.com>	 <47A23F1C.7080809@inria.fr>	 <86802c440801311342y16ff7c7eib28bf1c576be7075@mail.gmail.com> <86802c440801311535v2bb9977ma884129662c9a2d5@mail.gmail.com>
In-Reply-To: <86802c440801311535v2bb9977ma884129662c9a2d5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>> Have a look at the above link. I don't get -1. I get 0 everywhere, while
>>> I should get 1 for some devices. And if I unplug/replug a device using
>>> fakephp, numa_node becomes correct (1 instead of 0). This just looks
>>> like the code is there but things are initialized in the wrong order.
>>>       
>> do you have
>> ...
>> bus 00 -> pxm 0 -> node 0
>> ...
>> bus 40 -> pxm 1 -> node 1
>> ...
>> bus 80 -> pxm 1 -> node 1
>>
>> in your boot msg or dmesg?
>>
>> if not, your dsdt doesn't have _PXM for pci root bus. or you need to
>> ask your HW vendor to add that in their BIOS, or use my patchset.
>>     
>
> please try the attached patchset
>
> please get x86.git then use quilt apply the patch
>
> http://people.redhat.com/mingo/x86.git/README
>   

I finally managed to test this and it seems to work. I now get the
following numa_node attributes:
/sys/devices/pci0000:00/0000:00:01.0/numa_node    0
/sys/devices/pci0000:00/0000:00:07.0/numa_node    0
/sys/devices/pci0000:00/0000:00:07.0/0000:38:0d.0/numa_node    0
/sys/devices/pci0000:00/0000:00:08.0/numa_node    0
/sys/devices/pci0000:00/0000:00:08.1/numa_node    0
/sys/devices/pci0000:00/0000:00:08.2/numa_node    0
/sys/devices/pci0000:00/0000:00:09.0/numa_node    0
/sys/devices/pci0000:00/0000:00:09.1/numa_node    0
/sys/devices/pci0000:00/0000:00:09.2/numa_node    0
/sys/devices/pci0000:00/0000:00:0a.0/numa_node    0
/sys/devices/pci0000:00/0000:00:0a.0/0000:22:00.0/numa_node    0
/sys/devices/pci0000:00/0000:00:0b.0/numa_node    0
/sys/devices/pci0000:00/0000:00:0c.0/numa_node    0
/sys/devices/pci0000:00/0000:00:0c.0/0000:0c:00.0/numa_node    0
/sys/devices/pci0000:00/0000:00:0c.0/0000:0c:00.0/0000:0d:00.0/numa_node   
0
/sys/devices/pci0000:00/0000:00:0d.0/numa_node    0
/sys/devices/pci0000:00/0000:00:0d.0/0000:01:00.0/numa_node    0
/sys/devices/pci0000:00/0000:00:0e.0/numa_node    0
/sys/devices/pci0000:00/0000:00:0e.0/0000:17:00.0/numa_node    0
/sys/devices/pci0000:00/0000:00:0e.0/0000:17:00.0/0000:18:00.0/numa_node   
0
/sys/devices/pci0000:00/0000:00:18.0/numa_node    0
/sys/devices/pci0000:00/0000:00:18.1/numa_node    0
/sys/devices/pci0000:00/0000:00:18.2/numa_node    0
/sys/devices/pci0000:00/0000:00:18.3/numa_node    0
/sys/devices/pci0000:00/0000:00:19.0/numa_node    0
/sys/devices/pci0000:00/0000:00:19.1/numa_node    0
/sys/devices/pci0000:00/0000:00:19.2/numa_node    0
/sys/devices/pci0000:00/0000:00:19.3/numa_node    0
/sys/devices/pci0000:00/0000:00:1a.0/numa_node    0
/sys/devices/pci0000:00/0000:00:1a.1/numa_node    0
/sys/devices/pci0000:00/0000:00:1a.2/numa_node    0
/sys/devices/pci0000:00/0000:00:1a.3/numa_node    0
/sys/devices/pci0000:00/0000:00:1b.0/numa_node    0
/sys/devices/pci0000:00/0000:00:1b.1/numa_node    0
/sys/devices/pci0000:00/0000:00:1b.2/numa_node    0
/sys/devices/pci0000:00/0000:00:1b.3/numa_node    0
/sys/devices/pci0000:40/0000:40:0f.0/numa_node    1
/sys/devices/pci0000:40/0000:40:10.0/numa_node    1
/sys/devices/pci0000:40/0000:40:11.0/numa_node    1
/sys/devices/pci0000:40/0000:40:12.0/numa_node    1
/sys/devices/pci0000:40/0000:40:12.0/0000:51:00.0/numa_node    1
/sys/devices/pci0000:40/0000:40:13.0/numa_node    1

The 5 last lines above would report 0 instead of 1 with an older kernel.
Everything looks correct now (0000:40 is the second PCIe bus and it is
attached to socket #1).

Thanks a lot, Yinghai! Are you planning to merge these patches in the
near future? 2.6.26?

Brice

PS: I saved the corresponding dmesg. If you want to look at it, please
let me know.

