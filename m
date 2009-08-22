Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbZHVNkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbZHVNkR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 09:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZHVNkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 09:40:16 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:35064 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbZHVNkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 09:40:15 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Regression: Linux 2.6.31-rc7 lost sensors on asus mobo
Date: Sat, 22 Aug 2009 09:40:09 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5; KDE/4.2.4; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
 <200908212309.31505.gene.heskett@verizon.net> <4A8F8C49.2030406@gmail.com>
In-reply-to: <4A8F8C49.2030406@gmail.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200908220940.09178.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 August 2009, Robert Hancock wrote:
>On 08/21/2009 09:09 PM, Gene Heskett wrote:
>> On Friday 21 August 2009, Linus Torvalds wrote:
>>> You know the drill, so all together now: "Another week, another -rc
>>> kernel".
>>
>> Another rebuild didn't help:
>>
>> Thinking it didn't load it87, I tried again:
>>
>> [root@coyote 3.002005]# modprobe it87
>> FATAL: Error inserting it87
>> (/lib/modules/2.6.31-rc7/kernel/drivers/hwmon/it87.ko): Device or
>> resource busy [root@coyote 3.002005]# sensors
>> No sensors found!
>> Make sure you loaded all the kernel drivers you need.
>> Try sensors-detect to find out which these are.
>>
>> Been there, done that, no joy.
>>
>>  From messages when I attempt to access the it87:
>> Aug 21 22:59:37 coyote kernel: [  572.507928] it87: Found IT8716F chip at
>> 0x290, revision 1 Aug 21 22:59:37 coyote kernel: [  572.507937] it87: in3
>> is VCC (+5V) Aug 21 22:59:37 coyote kernel: [  572.507939] it87: in7 is
>> VCCH (+5V Stand-By) Aug 21 22:59:37 coyote kernel: [  572.508232] ACPI:
>> I/O resource it87 [0x295-0x296] conflicts with ACPI region IP__
>> [0x295-0x296] Aug 21 22:59:37 coyote kernel: [  572.508234] ACPI: Device
>> needs an ACPI driver
>>
>>  From uname -a
>> Linux coyote.coyote.den 2.6.31-rc7 #2 SMP PREEMPT Fri Aug 21 22:37:38 EDT
>> 2009 i686 athlon i386 GNU/Linux
>>
>> .config is attached, in case I've screwed the moose.
>
>The ACPI AML on your machine indicates that the BIOS may attempt to
>access the it87 hardware, and the kernel now by default blocks it87 from
>requesting those ports as it may conflict with what the BIOS is trying
>to do. On some machines, the ACPI BIOS accesses hardware monitoring
>chips itself to manage ACPI thermal zones, etc. and the conflicting
>access can cause incorrect temperature readings and other bad behavior.
>
>You can try acpi_enforce_resources=lax on the kernel command line to
>restore the previous behavior. Or for some Asus boards, you can try the
>asus_atk0110 ACPI driver instead of it87.

That module is loaded right now while I'm on rc5,

[root@coyote]# lsmod|grep asus
asus_atk0110            8124  0
hwmon                   2552  2 it87,asus_atk0110
[root@coyote hwmon]# lsmod|grep it87
it87                   20908  0
hwmon_vid               2780  1 it87
hwmon                   2552  2 it87,asus_atk0110


and all seems well.  I just went through a make xconfig for about 30 minutes, 
looking to see if there was someplace to select that and actually make it 
work in place of the it87 module.

I was not able to locate such an option.  Now what?

Thanks, Robert.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Having a wonderful wine, wish you were beer.

