Return-Path: <linux-kernel-owner+w=401wt.eu-S1030325AbXCSQP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030325AbXCSQP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030326AbXCSQP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:15:26 -0400
Received: from mail.tpi.com ([198.107.51.143]:3752 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030325AbXCSQPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:15:25 -0400
Message-ID: <45FEB71B.90406@canonical.com>
Date: Mon, 19 Mar 2007 10:15:23 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: Suspend to RAM fault in VT when resuming
References: <45F709F2.80504@canonical.com> <20070313212457.GD12370@elf.ucw.cz> <45F752EF.6030701@canonical.com> <20070319150753.GC1915@elf.ucw.cz>
In-Reply-To: <20070319150753.GC1915@elf.ucw.cz>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Tue 2007-03-13 19:42:07, Tim Gardner wrote:
>> Pavel Machek wrote:
>>> Hi1
>>>
>>>> I've chased one of the 'Suspend to RAM' resume problems to a specific
>>>> line in drivers/char/vt.c, see attached 2.6.21-rc3 diff with
>>> Has suspend/resume ever worked on that hardware?
>>>
>>>> TRACE_RESUME() instrumentation. The macro scr_writew resolves to '*addr
>>>> = val', which appears to be causing the problem. I've verified that the
>>>> pointer is not NULL, but don't know if its really valid. Its pretty
>>>> tough to tell what is happening, but on a Dell XPS it just hangs. A Dell
>>>> Precision blinks the keyboard lights.
>>> It is possible that video is not initialized at that point, and that
>>> hardware goes seriously unhappy when you access non-existing vga. Does
>>> it resume ok when you completely disable video support? 
>> Resume works on the Dell XPS with the Ubuntu Edgy release
>> Ubuntu-2.6.17-10.25 (2.6.17 plus a zillion fixes). Ubuntu's git tree is
>> rsync://rsync.kernel.org/pub/scm/linux/kernel/git/bcollins/ubuntu-2.6.git.
>> Ubuntu-2.6.17-8.21 is the first version where resume works, but there
>> are a boatload of changes in ACPI and SW suspend between that and the
>> previous tag Ubuntu-2.6.17-7.20. I don't know what made SW suspend work,
>> but even knowing that won't tell me what broke it again.
>>
>> I've been avoiding the bisect process because it is quite time consuming
>> on my slow machine, there is much branch weirdness, and I'm not that
>> good with git. I thought if I narrowed the failure down to a small chunk
>> of code in 2.6.21-rc3, then the answer might be obvious. No such luck, huh?
>>
>> This crash behaves like the video memory space has become unmapped. Is
>> that possible?
> 
> That seems improbable. It is physical ram, we do not unmap that..
> 

The machine _has_ just come out of BIOS ACPI space. Perhaps PCI
resources for video are hosed. All I can tell for sure is that this one
line appears to cause some kind of crash. I'm working on finding some
1394 resources to see if I can nail this one.

-- 
Tim Gardner tim.gardner@ubuntu.com
