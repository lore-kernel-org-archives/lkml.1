Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbXKVHWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbXKVHWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 02:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbXKVHW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 02:22:29 -0500
Received: from m-04.th.seeweb.it ([217.64.195.227]:59877 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbXKVHW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 02:22:28 -0500
Message-ID: <47452EAC.5060801@users.sourceforge.net>
Date: Thu, 22 Nov 2007 08:24:28 +0100
From: "legolas558@users.sourceforge.net" <legolas558@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071122)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pavel Machek <pavel@ucw.cz>, mnowak@redhat.com, shaohua.li@intel.com
Subject: Re: Laptop keyboard unusable when ACPI is active
References: <47001841.1000107@users.sourceforge.net> <470DD906.9090504@users.sourceforge.net> <470F600B.3030305@users.sourceforge.net>
In-Reply-To: <470F600B.3030305@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

some upates about this issue (see also bug 9147 
http://bugzilla.kernel.org/show_bug.cgi?id=9147 ).

The 'ac', 'battery' and 'thermal' modules (compiled as stand-alone) do 
cause the bug; it suffices that one of them (or any set of them) is 
loaded to trigger the bug either immediately or after some time.
If none of them is loaded into memory, the bug does not happen.
Also, the 'battery' module does not generate system messages although 
the problem is equally verified.

The 'thermal' module instead, when loaded with 'modprobe thermal', 
causes the enter key pressed to execute the command to be indefinitively 
repeated into any terminal. This is currently a perfectly reproducible 
testcase for bug 9147.

The bug has been confirmed by at least another user (with different 
hardware configuration); please reply for either bug addressing or 
confirmation.

The current known best workaround to this bug is to compile all the 
above mentioned ACPI modules as stand-alone and to not (auto)load them 
(loosing their vital functionalities, since we are talking about laptops 
here, see http://gentoo-wiki.com/HARDWARE_Maxdata_Pro_7000_DX for an 
example of affected hardware).

It is also important to note that this bug always comes with bug 8740 
http://bugzilla.kernel.org/show_bug.cgi?id=8740 (also confirmed and also 
an ACPI issue).

Best regards,
--
  Daniele C.


legolas558@users.sourceforge.net ha scritto:
> I am posting this message just to say that this bug is being addressed
> on the bug tracker:
> http://bugzilla.kernel.org/show_bug.cgi?id=9147
>
> Regards,
> --
>   Daniele C.
>
>
> legolas558@users.sourceforge.net ha scritto:
>   
>> legolas558@users.sourceforge.net ha scritto:
>>   
>>     
>>> Kernel: 2.6.22-r5
>>> Kernel option: i8042.nomux=1
>>>     
>>>       
>> I am now using kernel 2.6.22-r8 (Gentoo) and the following kernel options:
>>
>> i8042.nomux=1 acpi=off
>>
>> I have tried kernel 2.6.23-rc9 but the problem is still there.
>>
>>   
>>     
>>> The problem which still remains, and I can't fix or work it around, is
>>> witnessed by the below dmesg lines:
>>> -----
>>> atkbd.c: Unknown key released (translated set 2, code 0xe0 on
>>> isa0060/serio0).
>>> atkbd.c: Use 'setkeycodes e060 <keycode>' to make it known.
>>> atkbd.c: Unknown key released (translated set 2, code 0xe0 on
>>> isa0060/serio0).
>>> atkbd.c: Use 'setkeycodes e060 <keycode>' to make it known.
>>> atkbd.c: Unknown key released (translated set 2, code 0xe0 on
>>> isa0060/serio0).
>>> atkbd.c: Use 'setkeycodes e060 <keycode>' to make it known.
>>> -----
>>> The release event for some keys is never caught, so all sorts of
>>> troubles happen if for example I use the Del key and it stucks, or if
>>> I use the Ctrl key and it never gets released...pushing again the
>>> stuck key brings back the key in the proper status.
>>>     
>>>       
>> With acpi=off the problem is totally worked around.
>>
>>   
>>     
>>> Can somebody please give me some clues about this issue, and possible
>>> solutions? I have been searching the web for a couple of weeks and
>>> seems like it is a common trouble of notebook users, but nobody has
>>> yet published a solution.
>>>     
>>>       
>> I am trying to find a path myself in this issue - which dates back to at
>> least 2005 and has never been resolved.
>>
>> I would now try some other kernel parameter in order to preserve ACPI
>> functionality and possibly prevent ACPI from messing up the keyboard IRQs.
>> Can somebody please give me istructions regarding the correct tests
>> (regarding kernel parameters and/or anything else) to perform in order
>> to better isolate the issue?
>>
>> Related Gentoo bug tracker item:
>> http://bugs.gentoo.org/show_bug.cgi?id=194781
>>
>> Other messages about the same kernel bug (many more can be found
>> googling around, and no solution yet):
>> https://lists.linux-foundation.org/pipermail/bugme-new/2005-January/011736.html
>> http://dev.laptop.org/ticket/2401
>>
>> Regards,
>> --
>>   Daniele C.
