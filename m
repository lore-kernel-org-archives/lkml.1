Return-Path: <linux-kernel-owner+w=401wt.eu-S932905AbXHDW4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbXHDW4z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 18:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932170AbXHDW4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 18:56:46 -0400
Received: from ns3.system-techniques.com ([204.91.156.41]:51262 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbXHDW4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 18:56:45 -0400
Date: Sat, 4 Aug 2007 15:56:34 -0700 (PDT)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Attila Nagy <bra@fsn.hu>
cc: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: Re: Hangs and reboots under high loads, oops with DEBUG_SHIRQ
In-Reply-To: <46B195EF.7090409@fsn.hu>
Message-ID: <Pine.LNX.4.64.0708041525290.14065@filesrv1.baby-dragons.com>
References: <46AE0420.4030900@fsn.hu> <20070730171953.5fe93979@the-village.bc.nu>
 <46AF4570.7070606@fsn.hu> <46AFB2CB.6040906@atipa.com> <46B195EF.7090409@fsn.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.8 (ns3.baby-dragons.com [204.91.156.41]); Sat, 04 Aug 2007 22:56:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 	Hello Atilla ,

On Thu, 2 Aug 2007, Attila Nagy wrote:
> On 2007.08.01. 0:08, Roger Heflin wrote:
>> Attila Nagy wrote:
>>> HARDWARE ERROR
>>> HARDWARE ERROR. This is *NOT* a software problem!
>>> Please contact your hardware vendor
>>> CPU 1 BANK 0 TSC 1167e915e93ce
>>> MCG status:RIPV MCIP
>>> MCi status:
>>> Uncorrected error
>>> Error enabled
>>> Processor context corrupt
>>> MCA: Internal Timer error
>>> STATUS b200004010000400 MCGSTATUS 5
>>> This is not a software problem!
>>> Run through mcelog --ascii to decode and contact your hardware vendor
>>> 
>>> HARDWARE ERROR
>>> HARDWARE ERROR. This is *NOT* a software problem!
>>> Please contact your hardware vendor
>>> CPU 1 BANK 5 TSC 1167e915e9ea8
>>> MCG status:RIPV MCIP
>>> MCi status:
>>> Uncorrected error
>>> Error enabled
>>> Processor context corrupt
>>> MCA: Internal Timer error
>>> STATUS b200221024080400 MCGSTATUS 5
>>> This is not a software problem!
>>> Run through mcelog --ascii to decode and contact your hardware vendor
>> 
>> Attila,
>> 
>> We had some issues with very similar boards all of the problems
>> seem to be around the PCIX bus area of the machine, setting the
>> PCIX buses to 66 mhz in the bios made things stable (but slow).   Not using
>> the PCIX bus also seemed to make things work.   We got MCE's and
>> other odd crashes under heavy IO loads.   I believe turning things
>> down to 100mhz made things more stable, but things still crashed.
>> 
>> Supermicro reported being able to fix the issue with:
>> setting the PCI Configuration -> PCI-e I/O performance
>> setting to Colasce 128B.
>> 
>> I am not exactly sure where to set it as we did not try it
>> as we had already changed to a different motherboard that did not
>> have the issue.
>> 
>> If this works please tell me.
> Roger, you are my hero. :)
> With that PCI-e setting (again, for the record, this is on a Supermicro X7DBE 
> motherboard,
> and the BIOS setting is PCIe I/O performance, which has two states: Coalesce 
> and Payload 256B)
> all of the four machines have survived a half day of continous bashing. 
> Previously one, or two
> machines typically fell off after such amount of IO load, so it looks 
> promising so far.
> I hope this won't change over the time.
>
> BTW, this is still with 2.6.21.5, because the SCSI target stuff I use (SCST) 
> has some
> -I hope temporary- problems with changed (deleted) interfaces in newer 
> kernels.
>
> Should the DEBUG_SHIRQ problem in e1000 affect stability (or performance)?
>
> Thanks,

 	I too have a SuperMicro MB ,  But it is a X7DB8 .  Same symptoms . 
Reported MCE problems here a couple of times .
 	I set the BIOS setting 'PCIe I/O performance', to 'Coalesce' .
  	For everyones information ,  stability went way up ,  scsi IO is ~ half 
,  But if there's no stability ...

 	I'm going to try their 1.3b bios update & see if that helps any .
 	iirc ,  Some said they'd already acquired the lastest for their MB & 
that did not help them at all .  What th eheck I'll give it a try anyway .
 		Hth ,  JimL
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
