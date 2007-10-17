Return-Path: <linux-kernel-owner+w=401wt.eu-S933743AbXJQPP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933743AbXJQPP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757325AbXJQPPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:15:20 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:2840 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbXJQPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:15:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=D411pL6WRUxArATx6xBNE/oKDbK3OuiwsCih+F0fxJ44yPgEgsxh83g7Y8ZFTnS50Q/YLRiQoA7hwI3Rez/EMUXMyulgfNYJGonWzNetcwg3JYxBGj8D9L3pyh1rFje0FBcFi16sEtRv+uu7KU/BvWefL5zEIg93j2u80QcQ5y8=
Message-ID: <4716272D.9040107@gmail.com>
Date: Wed, 17 Oct 2007 23:15:57 +0800
From: Yi Yang <yang.y.yi@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070809)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org, mj@atrey.karlin.mff.cuni.cz,
       crutcher+kernel@datastacks.com
Subject: Re: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef
 key
References: <4714DDA8.8030204@gmail.com> <20071016172124.GA19882@elf.ucw.cz>
In-Reply-To: <20071016172124.GA19882@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek 写道:
> Hi!
>
>   
>> For SysRq, we just can get hot key list from Documentation/sysrq.txt
>> , but in the most of cases, the user can't access it by hand on
>> using SysRq to debug, so it is better for SysRq to provide an online
>> help for the users.
>>
>> SysRq has already provided a similiar help before this patch, but it
>> is not so definite that the user doesn't know what happened and how
>> to do on pressing an undefined hot key.
>>
>> In addition, that funtion has a big loop with another big loop
>> embedded which is very inefficient, it is intended to skip some hot
>> key help info for such a function as "Changing Loglevel", just print
>> a help info for this, that is very unnecessary. In fact, the key '0'
>>  - '8' have different results the user should know.
>>
>> This patch add this online help function, it'll print thw whole hot
>> key list and corresponding function descriptions, it can print the new
>> defined hot key without any changed needed.
>>
>> The output is the below on pressing an undefined hot key:
>>
>> SysRq : <6>this hot key isn't defined.
>>
>> SysRq Help Information:
>>
>>   Hot Key      Function Description
>> ===========    ====================
>> ALT+SysRq+0    Changing Loglevel to this value
>> ALT+SysRq+1    Changing Loglevel to this value
>> ALT+SysRq+2    Changing Loglevel to this value
>> ALT+SysRq+3    Changing Loglevel to this value
>> ALT+SysRq+4    Changing Loglevel to this value
>> ALT+SysRq+5    Changing Loglevel to this value
>> ALT+SysRq+6    Changing Loglevel to this value
>> ALT+SysRq+7    Changing Loglevel to this value
>> ALT+SysRq+8    Changing Loglevel to this value
>> ALT+SysRq+9    Changing Loglevel to this value
>> ALT+SysRq+a    Not defined
>> ALT+SysRq+b    Resetting
>> ALT+SysRq+c    Trigger a crashdump
>> ALT+SysRq+d    Not defined
>> ALT+SysRq+e    Terminate All Tasks
>> ALT+SysRq+f    Manual OOM execution
>> ALT+SysRq+g    Not defined
>> ALT+SysRq+h    Not defined
>> ALT+SysRq+i    Kill All Tasks
>> ALT+SysRq+j    Not defined
>> ALT+SysRq+k    SAK
>> ALT+SysRq+l    Not defined
>> ALT+SysRq+m    Show Memory
>> ALT+SysRq+n    Nice All RT Tasks
>> ALT+SysRq+o    Power Off
>> ALT+SysRq+p    Show Regs
>> ALT+SysRq+q    Show Pending Timers
>> ALT+SysRq+r    Keyboard mode set to XLATE
>> ALT+SysRq+s    Emergency Sync
>> ALT+SysRq+t    Show State
>> ALT+SysRq+u    Emergency Remount R/O
>> ALT+SysRq+v    Not defined
>> ALT+SysRq+w    Show Blocked State
>> ALT+SysRq+x    Not defined
>> ALT+SysRq+y    Not defined
>> ALT+SysRq+z    Not defined
>>     
>
> This will scroll out of users view on small terminals.
>
> Plus it is untrue. On sparc, it is stop+x, not sysrq+x.
>
>   
You're right, it it better to remove ALT+SysRq
>> +/*
>> + * Hot key table SysRq supports
>> + */
>> +static char __read_mostly sysrq_hot_key_table[36] = {
>> +	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
>> +	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
>> +	'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
>> +	'u', 'v', 'w', 'x', 'y', 'z'
>> +};
>>     
>
> Plus this is practically guaranteed to get out of sync with
> reality. If you did this to make sysrq printing faster... then that is
> very bad optimization.
> 									Pavel
>   
This char array is just for output, thees are jsut the keys sysrq has 
defined, in the current
design of sysrq, to add a new key is not easy unless you use an existed 
but unused key,
so this has no problem.

SysRq is just for debugging or emergent handling, so this array is 
impossible to result in
any bad effects, it is just for convenience.

