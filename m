Return-Path: <linux-kernel-owner+w=401wt.eu-S1764254AbXJQPHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764254AbXJQPHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 11:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbXJQPH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 11:07:27 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:41953 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755740AbXJQPH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 11:07:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=fLbIxx1Vs6Ba0mw4CTwAtBJHjmCpPCOWgtM3DoSoIP+BzYigwrqWC+YIT7X//2LUmjyQ7EqJcVBpun24Kt0tctHMkAHqq1tVTIETJqK9DD4Va8G8fIvTCW0o/3tQQ3NnL25XG2a1UF00gAcJi7CreIavDvIz6CCGw2QbWOMBJu4=
Message-ID: <47162556.7020009@gmail.com>
Date: Wed, 17 Oct 2007 23:08:06 +0800
From: Yi Yang <yang.y.yi@gmail.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070809)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org, mj@atrey.karlin.mff.cuni.cz,
       pavel@atrey.karlin.mff.cuni.cz, crutcher+kernel@datastacks.com
Subject: Re: [PATCH 2.6.23] SysRq: print hotkey info while pressing undef
 key
References: <4714DDA8.8030204@gmail.com> <jewstnhwuu.fsf@sykes.suse.de>
In-Reply-To: <jewstnhwuu.fsf@sykes.suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab 写道:
> Yi Yang <yang.y.yi@gmail.com> writes:
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
>           ^^^
>
> This is misplaced.
>   

printk(KERN_INFO "SysRq : \n") can fix it.

>   
>> @@ -410,7 +420,7 @@ void __handle_sysrq(int key, struct tty_
>>  	spin_lock_irqsave(&sysrq_key_table_lock, flags);
>>  	orig_log_level = console_loglevel;
>>  	console_loglevel = 7;
>> -	printk(KERN_INFO "SysRq : ");
>> +	printk(KERN_INFO "\nSysRq : ");
>>     
>
> It does not make any sense to put the printk level just before the
> newline, since the newline resets it to the default level.
>   
Thank you, I'll remove \n.
> Andreas.
>
>   

