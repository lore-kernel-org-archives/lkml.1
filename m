Return-Path: <linux-kernel-owner+w=401wt.eu-S934024AbXEEWls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934024AbXEEWls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 18:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbXEEWls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 18:41:48 -0400
Received: from buniche.hst.terra.com.br ([200.176.10.197]:43268 "EHLO
	buniche.hst.terra.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522AbXEEWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 18:41:47 -0400
X-Terra-Karma: -2%
X-Terra-Hash: 3e869178a76154f6a2872012165b7c55
Message-ID: <463D0808.6030500@centralinf.com.br>
Date: Sat, 05 May 2007 19:41:12 -0300
From: "Guilherme M. Schroeder" <guilherme@centralinf.com.br>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
References: <1178314144.6094.7.camel@localhost.localdomain>	 <200705050118.34711.ak@suse.de> <1178321228.6094.34.camel@localhost.localdomain>
In-Reply-To: <1178321228.6094.34.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The lspci output:

00:00.0 Host bridge: ATI Technologies Inc Radeon Xpress 200 Host Bridge 
(rev 01)
00:01.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
00:14.0 SMBus: ATI Technologies Inc SB600 SMBus (rev 13)
00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
00:14.2 Audio device: ATI Technologies Inc SB600 Azalia
00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
00:14.4 PCI bridge: ATI Technologies Inc SB600 PCI to PCI Bridge
01:05.0 VGA compatible controller: ATI Technologies Inc RC410 [Radeon 
Xpress 200]
02:09.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX 
(rev 02)

And what about the patch? there's a final version to try?

Thanks.

john stultz wrote:
> On Sat, 2007-05-05 at 01:18 +0200, Andi Kleen wrote:
>> On Friday 04 May 2007 23:29:04 john stultz wrote:
>>> One of the 2.6.21 regressions was Guilherme's problem seeing his box
>>> lock up when the system detected an unstable TSC and dropped back to
>>> using the HPET.
>>>
>>> In digging deeper, we found the HPET is not actually incrementing on
>>> this system. And in fact, the reason why this issue just cropped up was
>>> because of Thomas's clocksource watchdog code was comparing the TSC to
>>> the HPET (which wasn't moving) and thought the TSC was broken.
>>>
>>> Anyway, Guliherme checked for a BIOS update and did not find one, so
>>> I've added a DMI blacklist against his system so the HPET is not used.
>>>
>>> Many thanks to Guilherme for the slow and laborious testing that finally
>>> narrowed down this issue.
>> Before going to hard to maintain DMI black lists we should first check 
>> if it's a more general problem and can't it be solved better? Most likely
>> that system isn't the one with this issue and I don't want to apply
>> DMI patches forever.
> 
> We can give it a whirl, I just didn't want to add yet another "compare
> with some other counter that may or may not work" check. In this case,
> probably reading three times in a row and getting the same result would
> be a clearly broken box. 
> 
> 
>> In particular: what lspci chipset does it have?  If it's Intel it might be
>> worth checking the datasheet if there is some "HPET stop" bit -- perhaps it 
>> could be fixed up.
> 
> Guilherme: Could you provide lspci output? 
> 
> 
>> We seem to have a couple of Intel systems recently with HPET trouble.
> 
> Ok, I wasn't aware it was a common issue.
> 
> thanks
> -john
> 
> 
> 
