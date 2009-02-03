Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbZBCR6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbZBCR6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZBCR6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:58:32 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:56461 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZBCR6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:58:31 -0500
Message-ID: <498885CC.4060509@intertwingly.net>
Date: Tue, 03 Feb 2009 12:58:36 -0500
From: Sam Ruby <rubys@intertwingly.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [APIC] Kernel panic, rsync corruption, intel q8200, 2.6.28-rc8
References: <4978767D.4060700@intertwingly.net> <20090130000758.1dff0113.akpm@linux-foundation.org>
In-Reply-To: <20090130000758.1dff0113.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 22 Jan 2009 08:37:01 -0500 Sam Ruby <rubys@intertwingly.net> wrote:
> 
>> Hardware summary: http://tinyurl.com/ap79ra
>> APIC details: http://intertwingly.net/stories/2009/01/22/
>> Note acpidump.err: Wrong checksum for OEMB!
>>
>> Messages on boot using Intrepid, Jaunty Alpha 3, or Fedora 10:
>>
>> [    0.296001] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
>> [    0.296001] Kernel panic - not syncing: IO-APIC + timer doesn't work! 
>>   Boot with apic=debug and send a report.  Then try booting with the 
>> 'noapic' option.
>> [    0.296001]
>>
>> Able to get past this issue using "noapic", at which point things mostly 
>> work,
> 
> Join the ever-growing noapic club :(
> 
> I assume this is an ACPI problem.  Or at least, a BIOS problem which
> ACPI can solve for us.

My understanding is that APCI and APIC are two different things.

>> but rsync of large iso images result in corrupt files.  Able to 
>> copy those same files using Vista on the same machine, or using Hardy on 
>> another machine.  This problem may not be related to the above, but it 
>> seems plausible to me that this might be an interrupt issue.
> 
> Yes, it might be unrelated.  There are no kernel messages when it happens?

I see no messages to /var/log/messages while doing the following (which 
involves rsync'ing a 2618793984 byte file from an NTFS to ext3 drive on 
the same machine:

rubys@rubix4:~/tmp$ rsync /mnt/shared/windows7_7000.iso .
rubys@rubix4:~/tmp$ openssl md5 windows7_7000.iso
MD5(windows7_7000.iso)= 953b9ac92d58f5edef525004bcce048d
rubys@rubix4:~/tmp$ rsync /mnt/shared/windows7_7000.iso .
rubys@rubix4:~/tmp$ openssl md5 windows7_7000.iso
MD5(windows7_7000.iso)= 695328ef1280708eb73303656f6ef0b2

>> memtest86+ runs clean.
>>
>> Quite willing to invest time in installing kernels or distributions on 
>> fresh hard drives, run tests, obtain debug information, and report back.
>>
>> More background here: http://intertwingly.net/blog/2009/01/20/noAPIC
>>
>> Not subscribed, but will actively monitor the web archives for this 
>> mailing list for the next several days.
> 
> It'd be best to raise a report against ACPI?BIOS (I think) at
> bugzilla.kernel.org, please.

Once again, I'm talking about apic not acpi... does this advice still hold?

> If any previous kernel version worked OK, please be sure to note that.

I don't believe that's the case.  Put another way, I've yet to find a 
Linux kernel that can boot without the noapic option on this machine.

> Thanks.

- Sam Ruby
