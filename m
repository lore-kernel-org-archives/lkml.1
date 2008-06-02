Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYFBTDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYFBTDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 15:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYFBTCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 15:02:54 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:48619 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYFBTCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 15:02:52 -0400
Message-ID: <484444A4.80206@keyaccess.nl>
Date: Mon, 02 Jun 2008 21:06:12 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Avuton Olrich <avuton@gmail.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Rene Herman <rene.herman@gmail.com>,
       Len Brown <len.brown@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my
 ALSA intel8x0 sound card regression
References: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com>	 <4842CC50.4030406@keyaccess.nl> <3aa654a40806012025ic6b9d0dlec05211bad782581@mail.gmail.com>
In-Reply-To: <3aa654a40806012025ic6b9d0dlec05211bad782581@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.8 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02-06-08 05:25, Avuton Olrich wrote:

> On Sun, Jun 1, 2008 at 9:20 AM, Rene Herman <rene.herman@keyaccess.nl> wrote:
>> On 01-06-08 16:42, Avuton Olrich wrote:
>>
>>> My intel8x0 card stops working due to a regression; bisection and
>>> information below.
>>>
>>> May have relationship to this thread
>>>
>>> http://groups.google.com/group/linux.kernel/browse_thread/thread/d5857287a36e71af/d7ae0a1490b7d142?lnk=st
>>>
>>> http://avuton.googlepages.com/intel8x0-config.gz
>>> http://avuton.googlepages.com/intel8x0-cpuinfo
>>> http://avuton.googlepages.com/intel8x0-dmesg
>> This dmesg seems to be 6-byte file consisting of "dmesg\n" ...
> 
> Corrected:
> http://avuton.googlepages.com/dmesg.txt

Thanks. Important lines:

[    0.000000] Linux version 2.6.26-rc4 (sbh@rocket) (gcc version 4.2.4 
(Gentoo 4.2.4 p1.0)) #4 SMP PREEMPT Sun Jun 1 17:41:35 PDT 2008

<snip>

[    0.205750] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.205891] pnp: PnP ACPI init
[    0.205945] ACPI: bus type pnp registered
[    0.206968] pnp 00:07: mem resource (0xfebfa000-0xfebfac00) overlaps 
0000:00:1b.0 BAR 0 (0xfebf8000-0xfebfbfff), disabling
[    0.208685] pnp: PnP ACPI: found 13 devices
[    0.208737] ACPI: ACPI bus type pnp unregistered

<snip>

[    0.231865] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.231923] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.231990] system 00:07: ioport range 0x480-0x4bf has been reserved
[    0.232045] system 00:07: iomem range 0xffafe000-0xffb0cbff could not 
be reserved
[    0.232114] system 00:07: iomem range 0xffb00000-0xffbfffff could not 
be reserved
[    0.232182] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been 
reserved
[    0.232188] system 00:07: iomem range 0xfed20000-0xfed3ffff has been 
reserved
[    0.232188] system 00:07: iomem range 0xfed45000-0xfed89fff has been 
reserved
[    0.232188] system 00:07: iomem range 0xfff00000-0xfffffffe could not 
be reserved
[    0.232188] system 00:07: iomem range 0xfebfe000-0xfebfec00 has been 
reserved
[    0.232188] system 00:07: iomem range 0xfebfa000-0xfebfac00 has been 
reserved

(*)

<snip>

[    7.432374] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, 
low) -> IRQ 22
[    7.432374] PCI: Unable to reserve mem region #1:4000@febf8000 for 
device 0000:00:1b.0
[    7.432374] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[    7.432374] HDA Intel: probe of 0000:00:1b.0 failed with error -16

So it's first saying it's disabling the region, then grabbing it at (*) 
anyway.

I suppose/gather this worked at _some_ point, so over to author I guess.

>>> http://avuton.googlepages.com/intel8x0-ioports
7>>> http://avuton.googlepages.com/intel8x0-lspci-vvv
>>> http://avuton.googlepages.com/intel8x0-modules
>>> http://avuton.googlepages.com/intel8x0-ver-linux
>>> http://avuton.googlepages.com/intel8x0-version
>>>
>>> commit 53052feb6ddd05cb2b5c6e89fb489bf83bbb6803
>>> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
>>> Date:   Mon Apr 28 16:34:15 2008 -0600
>>>
>>>    PNP: remove pnp_mem_flags() as an lvalue
>>>
>>>    A future change will change pnp_mem_flags() from a "#define that
>>>    simplifies to an lvalue" to "an inline function that returns the
>>>    flags value."
>>>
>>>    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>>>    Acked-By: Rene Herman <rene.herman@gmail.com>
>>>    Signed-off-by: Len Brown <len.brown@intel.com>
>>>
>> I'm probably just really blind but I don't see how that specific commit may
>> have made any difference. It _is_ in the exact spot which would fix that
>> overlap problem of yours but this should be an identity change as far as
>> fuctionality goes. Are you _really_ sure it's this one?
>>
>> (Is this racing with anything?)
> 
> I will confirm in the next 24 hours that the previous revision works.

Rene.
