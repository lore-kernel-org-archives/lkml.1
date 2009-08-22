Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZHVNsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZHVNsO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 09:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753766AbZHVNsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 09:48:13 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:45396 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbZHVNsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 09:48:13 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Regression: Linux 2.6.31-rc7 lost sensors on asus mobo
Date: Sat, 22 Aug 2009 09:48:03 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5; KDE/4.2.4; i686; ; )
Cc: Robert Hancock <hancockrwd@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
 <4A8F8C49.2030406@gmail.com> <4A8FCE50.9070801@s5r6.in-berlin.de>
In-reply-to: <4A8FCE50.9070801@s5r6.in-berlin.de>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
Message-id: <200908220948.03426.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 August 2009, Stefan Richter wrote:
>Robert Hancock wrote:
>> On 08/21/2009 09:09 PM, Gene Heskett wrote:
>>>  From messages when I attempt to access the it87:
>>> Aug 21 22:59:37 coyote kernel: [  572.507928] it87: Found IT8716F chip
>>> at 0x290, revision 1 Aug 21 22:59:37 coyote kernel: [  572.507937] it87:
>>> in3 is VCC (+5V) Aug 21 22:59:37 coyote kernel: [  572.507939] it87: in7
>>> is VCCH (+5V Stand-By) Aug 21 22:59:37 coyote kernel: [  572.508232]
>>> ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region IP__
>>> [0x295-0x296] Aug 21 22:59:37 coyote kernel: [  572.508234] ACPI: Device
>>> needs an ACPI driver
>
>...
>
>> The ACPI AML on your machine indicates that the BIOS may attempt to
>> access the it87 hardware, and the kernel now by default blocks it87 from
>> requesting those ports as it may conflict with what the BIOS is trying
>> to do. On some machines, the ACPI BIOS accesses hardware monitoring
>> chips itself to manage ACPI thermal zones, etc. and the conflicting
>> access can cause incorrect temperature readings and other bad behavior.
>>
>> You can try acpi_enforce_resources=lax on the kernel command line to
>> restore the previous behavior. Or for some Asus boards, you can try the
>> asus_atk0110 ACPI driver instead of it87.
>
>PS:  There have been previous reports, e.g. those logged as
>http://bugzilla.kernel.org/show_bug.cgi?id=13967

I have applied that fix from the bz entry to my grub.conf but have not 
rebooted as yet.  However if this asus_atk0110.ko module is supposed to do 
the same job, then obviously I do not have some other, required option set in 
my .config's for rc6 and rc7.  Directly choosing it doesn't seem to be 
available in a make xconfig.  What am I missing?

Thanks, Stefan.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

It's the Magic that counts.
             -- Larry Wall on Perl's apparent ugliness

