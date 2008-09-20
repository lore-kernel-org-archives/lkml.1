Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYITTBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYITTBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 15:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYITTBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 15:01:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:23113 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbYITTBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 15:01:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EvYAVkTVBEZWK+OKVFyBL+OGtdPTxlq/hmHSIWrzrtSev6Swz6lMXTkpit9f+lHUBR
         enLPOjFJxg5T7zQT1gEVhJDVtanzPFps11HqjRd0b8CclgYJ8/iG7q8+wswihxZpJqCb
         PVd7/XJIQQsjx8DAIr1oLKEQitCJ4kHlIqeuA=
Message-ID: <48D54873.8010108@gmail.com>
Date: Sat, 20 Sep 2008 22:01:07 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: I need some serious help to debug suspend to ram problem
References: <48D4E685.8030801@gmail.com> <200809201810.45057.rjw@sisk.pl>
In-Reply-To: <200809201810.45057.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 20 of September 2008, Maxim Levitsky wrote:
>> Hi,
>>
>> I hit a dead end when trying to understand 
>> why my notebook can't resume from suspend to ram
>> if this is done two times a row.
>>
>> Single suspend/resume cycle works almost perfectly 
>> (beep that goes through the sound card is muted... 
>> no morse code for me... :-(
>>
>> )
>>
>> I compiled a minimal kernel (absolutely nothing but disk drivers, all experimental option like nohz
>> turned off)
>>
>> But I had to turn SMP, since without it system won't resume first time I suspend it.
>> (How could this affect suspend?)
> 
> It could if the system is 64-bit.  In which case please have a look at
> http://bugzilla.kernel.org/show_bug.cgi?id=11237
> 
>> With SMP and minimal kernel (of course  no closed drivers), I get same behavior,
>> first resume works second hangs.
>>
>> I then added some debug code to real mode wakeup code, I put there in first
>> place instructions, that will save some magic value to rtc (to alarm
>> registers that I know are preserved during boot cycle), and I discovered   
>> sad thing that first time bios does pass control to linux, but second time
>> (when it hangs), it doesn't. 
>>
>>
>> I tried to update bios, and I got same results.
>>
>> Of course it does work with that @#$%^& OS
> 
> So we're doing something wrong.  Please try the appended patch.
Thanks a lot, but this didn't help.

It still has same pattern, first suspend/resume works perfectly, 
second suspend/resume hangs hard.
It always happens like this, first resume always work 
(unless I turn off smp in kernel (I test this again), or reserve all low memory)

Also note that if I suspend the system to ram, resume, and then suspend to disk, 
then I can suspend to ram and resume, it seems that

on suspend to ram cycle somehow arms BIOS or something else, 
so second resume in a row doesn't work.

I run 32 bit kernel here, this is a long story 
(this bios doesn't turn fan on when running 64-bit version, 
I could update it, and I know that fan issue is fixed there, 
but new bios introduces bigger bug, namely it makes fan to run almost always 
regardless of 32/64 type of os.
And it doesn't fix this suspend/resume issue, I tested this. 
I could start/stop fan manually with a script, but this could fail, 
and maybe I will do so someday.)

The bugzilla seems to be unrelated here, since bios does 
pass control there, but corrupts memory.
Here I also have seen that bios corrupts memory, 
but everything resumes fine first time, and on second time,
bios doesn't pass control (I put set of instructions in beginning 
of wakeup real mode assembly file, no page tables, GDT/LDT are used there)


Best regards,
	Maxim Levitsky
