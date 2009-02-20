Return-Path: <linux-kernel-owner+w=401wt.eu-S1756757AbZBTTyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757AbZBTTyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZBTTyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:54:20 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:41033 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbZBTTyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:54:19 -0500
Message-ID: <499F0A67.0@cfl.rr.com>
Date: Fri, 20 Feb 2009 14:54:15 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II
 processor
References: <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com> <20090219141131.GM4301@alberich.amd.com> <20090220115357.GE4834@alberich.amd.com> <499ECF87.2070204@cfl.rr.com> <20090220160843.GF4834@alberich.amd.com> <20090220163844.GG4834@alberich.amd.com> <499EE3BA.7070105@cfl.rr.com> <499EEB0F.8010201@cfl.rr.com> <20090220182212.GH4834@alberich.amd.com> <499EF662.7010001@cfl.rr.com>
In-Reply-To: <499EF662.7010001@cfl.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Andreas Herrmann wrote:
>> On Fri, Feb 20, 2009 at 12:40:31PM -0500, Mark Hounschell wrote:
>>
>>> ACPI: HPET id: 0x10b9a201 base: 0xfed00000
>>   <snip>
>>
>>> hpet: hpet_enable(834):
>>> hpet: ID: 43538301, PERIOD: 429b17e
>>
>> This means that your BIOS could be bogus.
>> Obviously ACPI HPET table contains different information about
>> your HPET configuration than the HPET registers are showing.
>>
>> This means that other chipset configuration (e.g. ACPI tables) could
>> also be wrong.
>>
>> To confirm this please provide us output of
>>
>> # xxd /sys/firmware/acpi/tables/HPET
> 
> markh@harley:~> xxd /sys/firmware/acpi/tables/HPET
> 0000000: 4850 4554 3800 0000 0101 5258 3738 3020  HPET8.....RX780
> 0000010: 4157 5244 4143 5049 312e 3042 4157 5244  AWRDACPI1.0BAWRD
> 0000020: 9800 0000 01a2 b910 0000 0000 0000 d0fe  ................
> 0000030: 0000 0000 0010 0000
> 
> Mark
>

I don't intend to sound stupid but isn't this a _read only_  HPET ID register,
read by the BIOS and put in a table which ends up being read by the kernel then
in turn put in /sys/firmware/acpi/tables/HPET? If it is correct there, doesn't
that mean the BIOS read it correctly and it is correct? And in turn, mean that
the function used to read it for your debug printk could just be reading it wrong?

Also remember in the beginning of this thread this machine was running on a
Phenom-I and when I put a Phenom II in it I could no longer boot a 1000Hz
kernel. I know, that often  means nothing. But not always???

I still have that original Phenom available and it is in another very similar
BIOSTAR motherboard TA770 A2+ SE and is running a 1000Hz kernel. The MB does
have a different BIOS mfgr however. Would it be of any benefit to do any of
these things on that machine?


Regards
Mark
