Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbXGaWNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbXGaWNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbXGaWNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:13:24 -0400
Received: from 125.14.124.24.cm.sunflower.com ([24.124.14.125]:61078 "EHLO
	mail.atipa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753220AbXGaWNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:13:23 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 18:13:19 EDT
Message-ID: <46AFB2CB.6040906@atipa.com>
Date: Tue, 31 Jul 2007 17:08:11 -0500
From: Roger Heflin <rheflin@atipa.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Attila Nagy <bra@fsn.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Hangs and reboots under high loads, oops with DEBUG_SHIRQ
References: <46AE0420.4030900@fsn.hu> <20070730171953.5fe93979@the-village.bc.nu> <46AF4570.7070606@fsn.hu>
In-Reply-To: <46AF4570.7070606@fsn.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 31 Jul 2007 22:11:26.0562 (UTC) FILETIME=[BCF33C20:01C7D3BF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Attila Nagy wrote:
> On 2007.07.30. 18:19, Alan Cox wrote:
>> O> MCE:
>>  
>>> [153103.918654] HARDWARE ERROR
>>> [153103.918655] CPU 1: Machine Check Exception:                5 Bank 
>>> 0: b200004010000400
>>> [153104.066037] RIP !INEXACT! 10:<ffffffff802569e6> 
>>> {mwait_idle+0x46/0x60}
>>> [153104.145699] TSC 1167e915e93ce
>>> [153104.183554] This is not a software problem!
>>> [153104.234724] Run through mcelog --ascii to decode and contact your 
>>> hardware vendor
>>>     
>>
>> If you it through mcelog as it suggests it wil decode the meaning of the
>> MCE data and that should give you some idea. Generally speaking MCE
>> errors are real hardware errors but can certainly be caused by external
>> factors (power supply glitches, heat etc)
>>   
> Sorry, of course I ran that through mcelog, but inadvertently attached 
> the original version.
> 
> I've tried the machines with two types of power sources (different 
> UPSes, line filtering, etc,
> and the chassis have redundant PSes), monitoring the temperatures (seems 
> to be OK,
> the CPUs don't go over 30 °C even under load). I have the latest BIOS 
> for the
> motherboard.
> But I will recheck everything.
> 
> BTW, here's the output from mcelog, I see this occasionally on all four 
> machines:
> 
> HARDWARE ERROR
> HARDWARE ERROR. This is *NOT* a software problem!
> Please contact your hardware vendor
> CPU 1 BANK 0 TSC 1167e915e93ce
> MCG status:RIPV MCIP
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: Internal Timer error
> STATUS b200004010000400 MCGSTATUS 5
> This is not a software problem!
> Run through mcelog --ascii to decode and contact your hardware vendor
> 
> HARDWARE ERROR
> HARDWARE ERROR. This is *NOT* a software problem!
> Please contact your hardware vendor
> CPU 1 BANK 5 TSC 1167e915e9ea8
> MCG status:RIPV MCIP
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: Internal Timer error
> STATUS b200221024080400 MCGSTATUS 5
> This is not a software problem!
> Run through mcelog --ascii to decode and contact your hardware vendor
> 
> Thanks,
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Attila,

We had some issues with very similar boards all of the problems
seem to be around the PCIX bus area of the machine, setting the
PCIX buses to 66 mhz in the bios made things stable (but slow).   Not using
the PCIX bus also seemed to make things work.   We got MCE's and
other odd crashes under heavy IO loads.   I believe turning things
down to 100mhz made things more stable, but things still crashed.

Supermicro reported being able to fix the issue with:
setting the PCI Configuration -> PCI-e I/O performance
setting to Colasce 128B.

I am not exactly sure where to set it as we did not try it
as we had already changed to a different motherboard that did not
have the issue.

If this works please tell me.

                      Roger





