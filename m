Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbXKHHH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbXKHHH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 02:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXKHHHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 02:07:20 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:19571 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbXKHHHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 02:07:19 -0500
Message-ID: <4732B53C.2050509@oracle.com>
Date: Wed, 07 Nov 2007 23:05:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: werner <werner@copaya.yi.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: same problem with 2.6.24-rc2
References: <1194501449.25336@copaya.yi.org>
In-Reply-To: <1194501449.25336@copaya.yi.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[adding linux-kernel again]

werner wrote:
> The compilation is ready. By any reason that list as suggested by you wasn't generated.
> However, the 3 compiling/linking lists what my kernel-build-script normally generates,
> were. They are annexed here. It's the same , after booting the kernel crashs imediately
> with EIP error. And the building process reclaims a  missing Makefile.o in /<source-dir>/arch/x86.
> 

OK, first show us (that is, the mailing list "linux-kernel@vger.kernel.org", not
just me) what your "kernel-build-script" looks like.

The beginning of the log files that you sent to me (at end of this email)
is very suspicious looking.  It looks like you are not using the expect kernel
build procedures.

The crash problem (snippet below) is a fault in xor_sse_2() in the function
that tries to choose the best (fastest) xor method.  I would expect other
people to be having a similar problem.  I don't suspect that it's related to
the build problem (Makefile.o), but we need to have you building kernels
correctly before we try to find out why they break when you boot them.

> 
> =================================================================================
> On 7/Nov/2007 22:06 Randy Dunlap wrote ..
>> On Wed, 07 Nov 2007 21:32:43 -0300 (GFT) werner wrote:
>>
>>> On 7/Nov/2007 20:10 werner wrote ..
>>>> With 2.6.23-rc2 is the same problem:  it crashed at the beginning:  EIP 060
>> c03fdea4
>>>> EFLAGS 00010212 EIP is at xor_sse_2+0x34/0x200
>>>> Again during the compilation was reclaimed that <source-dir>/arch/x86/Makefile.o
>>>> cannot be found and were certain dependencies on it not made, such a file isn't
>>>> present in the source code (present are, f.ex. Makefile_32 , Makefile_64 ),
>> nor
>>>> was generated automaticaly during compilation, I think this is incorrect and
>> the
>>>> reason for the problems
>> Hi,
>>
>> Please provide the complete build log (with V=1 if possible) for the
>> missing Makefile.o problem.
>>
>> E.g.:
>>
>> make V=1 all >build.log 2>&1
>>
>> Make sure that build.log contains the error message and then send
>> the complete build.log file to us at linux-kernel@vger.kernel.org .
>>
>>
>>>> wl
>>>> werner@copaya.yi.org
>>>> =============================================================================
>>>> On 7/Nov/2007 16:14 Andrew Morton wrote ..
>>>>>> On Wed, 07 Nov 2007 15:55:12 -0300 (GFT) "werner" <werner@copaya.yi.org>
>> wrote:
>>>>>> I really don't know what's happening.  I don't understand nothing about
>> the
>>>> kernel
>>>>> error reporting system.   Because of this, always when there is a problem,
>> I
>>>> report
>>>>> it via e-mail to  linux-kernel@vger.kernel.org .  I don't know what people
>> there
>>>>> do with my messages.     
>>>>>
>>>>>
>>>>> It went like this:
>>>>>
>>>>> 1: you sent an email to linux-kernel
>>>>>
>>>>> 2: I sent a reply to you and linux-kernel
>>>>>
>>>>> 3: you sent a reply to me, but NOT linux-kernel!
>>>>>
>>>>> In other words, you did "reply", not "reply to all", thus you removed three
>>>>> thousand people from the discussion.  One of those people is the person who
>>>>> created the bug which you're hitting, and that person no longer knows
>>>>> what's happening.
>>>>>
>>>>>
>>>>> So please go back and resend all those emails, and retain ALL Cc:'s.  Don't
>>>>> just send them only to me.  Keep all indivisuals and all mailing lists on
>>>>> the email Cc: list.



> gcc -m32 -m elf_i386  /usr/src/linux-2.6.24-rc2-i486-1mn/arch/x86/Makefile.o   -o /usr/src/linux-2.6.24-rc2-i486-1mn/arch/x86/Makefile
> gcc: /usr/src/linux-2.6.24-rc2-i486-1mn/arch/x86/Makefile.o: No such file or directory
> gcc: no input files
> make: [/usr/src/linux-2.6.24-rc2-i486-1mn/arch/x86/Makefile] Error 1 (ignored)



-- 
~Randy
