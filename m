Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbXHBI35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbXHBI35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 04:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbXHBI3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 04:29:50 -0400
Received: from people.fsn.hu ([195.228.252.137]:54208 "EHLO people.fsn.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbXHBI3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 04:29:47 -0400
Message-ID: <46B195EF.7090409@fsn.hu>
Date: Thu, 02 Aug 2007 10:29:35 +0200
From: Attila Nagy <bra@fsn.hu>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Roger Heflin <rheflin@atipa.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Hangs and reboots under high loads, oops with DEBUG_SHIRQ
References: <46AE0420.4030900@fsn.hu> <20070730171953.5fe93979@the-village.bc.nu> <46AF4570.7070606@fsn.hu> <46AFB2CB.6040906@atipa.com>
In-Reply-To: <46AFB2CB.6040906@atipa.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.08.01. 0:08, Roger Heflin wrote:
> Attila Nagy wrote:
>> HARDWARE ERROR
>> HARDWARE ERROR. This is *NOT* a software problem!
>> Please contact your hardware vendor
>> CPU 1 BANK 0 TSC 1167e915e93ce
>> MCG status:RIPV MCIP
>> MCi status:
>> Uncorrected error
>> Error enabled
>> Processor context corrupt
>> MCA: Internal Timer error
>> STATUS b200004010000400 MCGSTATUS 5
>> This is not a software problem!
>> Run through mcelog --ascii to decode and contact your hardware vendor
>>
>> HARDWARE ERROR
>> HARDWARE ERROR. This is *NOT* a software problem!
>> Please contact your hardware vendor
>> CPU 1 BANK 5 TSC 1167e915e9ea8
>> MCG status:RIPV MCIP
>> MCi status:
>> Uncorrected error
>> Error enabled
>> Processor context corrupt
>> MCA: Internal Timer error
>> STATUS b200221024080400 MCGSTATUS 5
>> This is not a software problem!
>> Run through mcelog --ascii to decode and contact your hardware vendor
>
> Attila,
>
> We had some issues with very similar boards all of the problems
> seem to be around the PCIX bus area of the machine, setting the
> PCIX buses to 66 mhz in the bios made things stable (but slow).   Not 
> using
> the PCIX bus also seemed to make things work.   We got MCE's and
> other odd crashes under heavy IO loads.   I believe turning things
> down to 100mhz made things more stable, but things still crashed.
>
> Supermicro reported being able to fix the issue with:
> setting the PCI Configuration -> PCI-e I/O performance
> setting to Colasce 128B.
>
> I am not exactly sure where to set it as we did not try it
> as we had already changed to a different motherboard that did not
> have the issue.
>
> If this works please tell me.
Roger, you are my hero. :)
With that PCI-e setting (again, for the record, this is on a Supermicro 
X7DBE motherboard,
and the BIOS setting is PCIe I/O performance, which has two states: 
Coalesce and Payload 256B)
all of the four machines have survived a half day of continous bashing. 
Previously one, or two
machines typically fell off after such amount of IO load, so it looks 
promising so far.
I hope this won't change over the time.

BTW, this is still with 2.6.21.5, because the SCSI target stuff I use 
(SCST) has some
-I hope temporary- problems with changed (deleted) interfaces in newer 
kernels.

Should the DEBUG_SHIRQ problem in e1000 affect stability (or performance)?

Thanks,
