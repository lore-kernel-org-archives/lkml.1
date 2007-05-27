Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbXE0P1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbXE0P1Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 11:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbXE0P1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 11:27:04 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:36129 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754802AbXE0P1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 11:27:03 -0400
Message-ID: <4659A343.80500@dgreaves.com>
Date: Sun, 27 May 2007 16:26:59 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
References: <4658B7DD.3060309@tmr.com> <4659442E.2060307@dgreaves.com> <4659834E.4070506@tmr.com>
In-Reply-To: <4659834E.4070506@tmr.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> David Greaves wrote:
>> Bill Davidsen wrote:
>>> Anyway, I pulled the plug on the UPS, and the system shut down. But when
>>> it powered up, it booted the default kernel rather than the test kernel,
>>> decided that it couldn't resume, and then did a cold boot.
>>
>> Booting the machine isn't the kernel's job, it's the bootloader's job.
>>
> And resume is not the the bootloader's job... if memory and registers
> are restored, and a jump is made to the resume address, a resumed system
> should result. clearly some part of that didn't happen :-(

Well, what if you wanted to boot a 2nd, dual-boot OS?
The bootloader needs to boot the kernel which may choose to resume.

Is there a misunderstanding here?

I read your OP as saying that you booted kernel B (configured to have suspend
support) and then hit suspend. When the machine rebooted the "default kernel"
ie, kernel A, not kernel B was selected by the bootloader. Since the default
kernel didn't have or couldn't resume, it simply booted.
Just what I'd expect.

>> It is very dangerous to attempt a resume with a different kernel than
>> the one
>> that has gone to sleep.
>> Different kernels may be compiled with different options that affect
>> where or
>> how in-memory structures are saved.
>>
> If the mainline resume is depending on that no wonder resume is so
> fragile. User action can change order of module loads, kmalloc calls
> move allocated structures, etc. Counting on anything to be locked in
> place seems naive.
Err, no. It's a lot more sophisticated. However it does ask that you not resume
with a different kernel than you suspended with - not unreasonable!!

>> So you suspend with a kernel which holds your filesystem
>> data/cache/inodes at
>> 0x1234000 and restore with a kernel that expects to see your
>> filesystem data at
>> 0x1235000.
>>
>> Ouch.
>>
> I would hope that the data used by the resumed kernel would be the same
> data that was suspended, not something from another kernel.

Linux based OSes provide enough rope to build a harness or a noose. Choose wisely :)

As you suggest you are about to, it may be best to get a distro-configured
system or do some more background research. Mainline doesn't provide scripts to
interact with bootloaders etc.

Nb I replied because I've just done some work configuring s2d and now have 3
desktop/server machines doing suspend2disk on 2.6.21 quite nicely - thanks all
around.

David

