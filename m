Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZBCUTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZBCUTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 15:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZBCUTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 15:19:33 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:52694 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZBCUTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 15:19:32 -0500
Message-ID: <4988A6D9.8000605@intertwingly.net>
Date: Tue, 03 Feb 2009 15:19:37 -0500
From: Sam Ruby <rubys@intertwingly.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [APIC] Kernel panic, rsync corruption, intel q8200, 2.6.28-rc8
References: <4978767D.4060700@intertwingly.net>	<20090130000758.1dff0113.akpm@linux-foundation.org>	<498885CC.4060509@intertwingly.net> <20090203114849.b661f1ce.akpm@linux-foundation.org>
In-Reply-To: <20090203114849.b661f1ce.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 03 Feb 2009 12:58:36 -0500
> Sam Ruby <rubys@intertwingly.net> wrote:
> 
>> Andrew Morton wrote:
>>> On Thu, 22 Jan 2009 08:37:01 -0500 Sam Ruby <rubys@intertwingly.net> wrote:
>>>
>>>> Hardware summary: http://tinyurl.com/ap79ra
>>>> APIC details: http://intertwingly.net/stories/2009/01/22/
>>>> Note acpidump.err: Wrong checksum for OEMB!
>>>>
>>>> Messages on boot using Intrepid, Jaunty Alpha 3, or Fedora 10:
>>>>
>>>> [    0.296001] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
>>>> [    0.296001] Kernel panic - not syncing: IO-APIC + timer doesn't work! 
>>>>   Boot with apic=debug and send a report.  Then try booting with the 
>>>> 'noapic' option.
>>>> [    0.296001]
>>>>
>>>> Able to get past this issue using "noapic", at which point things mostly 
>>>> work,
>>> Join the ever-growing noapic club :(
>>>
>>> I assume this is an ACPI problem.  Or at least, a BIOS problem which
>>> ACPI can solve for us.
>> My understanding is that APCI and APIC are two different things.
> 
> They sure are.  But it is ACPI which communicates with the BIOS to tell
> the kernel about the APIC, hwo it's wired up, etc.
> 
> Although in this case it looks like the problem might be with the
> mp-bios tables, which ACPI does not handle.  In which case it would be
> core x86 code which will have to fix this up, not ACPI.
> 
> Did you try updating the BIOS?

My understanding is that a BIOS may be specific to the machine.
In the past, I've been able to find BIOS updates at manufacturer web 
sites.  This one is difficult to navigate, but the closest I have been 
able to find is:

http://www.acerpanam.com/synapse/forms/portal20.cfm?website=AcerPanAm.com&siteid=7117&areaid=2&formid=3394#results

Product Line => Desktop
Aspire M3640
Search

In the list that results, I see "INT15 Driver for AMI BIOS Core" for 
Vista, but no BIOS.  It could be that I just don't know where to look.

Note: my actual machine is designated AM3641-EQ8200A

>>>> but rsync of large iso images result in corrupt files.  Able to 
>>>> copy those same files using Vista on the same machine, or using Hardy on 
>>>> another machine.  This problem may not be related to the above, but it 
>>>> seems plausible to me that this might be an interrupt issue.
>>> Yes, it might be unrelated.  There are no kernel messages when it happens?
>> I see no messages to /var/log/messages while doing the following (which 
>> involves rsync'ing a 2618793984 byte file from an NTFS to ext3 drive on 
>> the same machine:
>>
>> rubys@rubix4:~/tmp$ rsync /mnt/shared/windows7_7000.iso .
>> rubys@rubix4:~/tmp$ openssl md5 windows7_7000.iso
>> MD5(windows7_7000.iso)= 953b9ac92d58f5edef525004bcce048d
>> rubys@rubix4:~/tmp$ rsync /mnt/shared/windows7_7000.iso .
>> rubys@rubix4:~/tmp$ openssl md5 windows7_7000.iso
>> MD5(windows7_7000.iso)= 695328ef1280708eb73303656f6ef0b2
>>
>>>> memtest86+ runs clean.
>>>>
>>>> Quite willing to invest time in installing kernels or distributions on 
>>>> fresh hard drives, run tests, obtain debug information, and report back.
>>>>
>>>> More background here: http://intertwingly.net/blog/2009/01/20/noAPIC
>>>>
>>>> Not subscribed, but will actively monitor the web archives for this 
>>>> mailing list for the next several days.
>>> It'd be best to raise a report against ACPI?BIOS (I think) at
>>> bugzilla.kernel.org, please.
>> Once again, I'm talking about apic not acpi... does this advice still hold?
> 
> Not sure.  Perhaps platform_i386/platform_x86_64 would be correct.
> Can the x86 maintainers please advise?

- Sam Ruby

