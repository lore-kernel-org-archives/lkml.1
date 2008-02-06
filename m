Return-Path: <linux-kernel-owner+w=401wt.eu-S1763351AbYBFA0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763351AbYBFA0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 19:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760816AbYBFA0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 19:26:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:43668 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYBFA0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 19:26:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,309,1199692800"; 
   d="scan'208";a="335520329"
Message-ID: <47A8FDDF.6080503@intel.com>
Date: Tue, 05 Feb 2008 16:22:55 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: =?windows-1252?Q?=3F=3F=3F=3F=3F=3F_=3F=3F=3F=3F=3F=3F=3F=3F=3F=3F=3F?= 
	<penguinista@mail.net.mk>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>
Subject: Re: PCIE ASPM support hangs my laptop pretty often
References: <200802051840.05237.penguinista@mail.net.mk> <20080205185100.GA4633@kroah.com> <47A8CE10.4010807@intel.com> <200802060105.45363.penguinista@mail.net.mk>
In-Reply-To: <200802060105.45363.penguinista@mail.net.mk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Feb 2008 00:23:35.0191 (UTC) FILETIME=[82DAC270:01C86856]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

?????? ??????????? wrote:
>>>>> I've patched my kernel with the PCIe ASPM and after setting
>>>>> echo powersave > /sys/module/pcie_aspm/parameters/policy
>>>>>
>>>>> I started to experience random hangs of my laptop.
>>>>> Hardware info:
>>>>> Thinkpad x60s 1704-5UG
>>>> the x60's chipset doesn't support ASPM properly afaik... bad idea.
>>> Well, the code shouldn't then cause a crash of the machine :)
>> The user enabled it specifically (where it is disabled by default)
>>
>> ASPM has been crashing e1000(e), which is why I've recently merged a patch
>> to disable L1 ASPM for the onboard 82573 nic on those platforms.
>>
>> this new infrastructure should work in the default configuration - enabling
>> ASPM where this system leaves it disabled is expected to give problems
>> unless you know what you are doing.
> 
> In my defense, the patch documentation didn't say it doesn't work with my 
> hardware, nor that it hangs the chipset :) and the promised 1.3w surelly 
> looked nice.
> 
> So, are there any benefits of ASPM if I have it in the kernel but it's set to 
> default? I got the impression that "default" means not much power savings?

did the Kconfig not come with a big fat (EXPERIMENTAL) ?

it actually depends for each device on the PCI-Express bus. Most PCI-E ports
support it but the device has the option of advertising enablement of that
capability or not.

both platform and each device on the pci-e bus are involved. some sata chipsets
work great with it, some that might not even advertise the capability... but it's
really hit and miss.

Your report is great of course, no doubt about it. I hope that people understand
that this feature can seriously break things at the bus level. It makes me feel a
lot better about the issues we had with some of our network cards and ASPM :)

once we get some feeling about how good ASPM works in the field for people we
might have to blacklist certain platforms or devices.

you could (for instance) try to see which device on your busses support ASPM and
work on per-device ASPM parameters (which is one of the things I suggested before)
so that we get an idea of which device is badly behaving with ASPM on your system.

Cheers,

Auke

