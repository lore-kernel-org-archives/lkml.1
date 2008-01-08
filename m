Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYAHKvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYAHKvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYAHKvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:51:42 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:40933 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752535AbYAHKvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:51:40 -0500
Message-ID: <47835598.7020308@linux.vnet.ibm.com>
Date: Tue, 08 Jan 2008 16:21:04 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.24-rc7 Build Failure on headers_install
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <4781E75B.3020307@linux.vnet.ibm.com> <20080107101235.GA13609@uranus.ravnborg.org>
In-Reply-To: <20080107101235.GA13609@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, Jan 07, 2008 at 02:18:27PM +0530, Kamalesh Babulal wrote:
>> Hi,
>>
>> The make allyesconfig build fails on x86_64 (AMD box) with the following
>> error
>>
>>   CHK     include/linux/version.h
>>   CHK     include/linux/utsrelease.h
>>   CALL    scripts/checksyscalls.sh
>>   CHK     include/linux/compile.h
>>   CHK     include/linux/version.h
>> make[2]: `scripts/unifdef' is up to date.
>> make[2]: *** No rule to make target `|', needed by `asm-generic'.  Stop.
>> make[1]: *** [headers_install] Error 2
>> make: *** [vmlinux] Error 2
> 
> Which make version are you using - it looks like a make bug.
> Did this occur with an older kernel or has this behaviour just started?
> 
> To get further you can disable "headers check" in kernel hacking menu
> but we need to find out why it fails for you.
> 
> Note: '|' is used to say that a prerequisite is 'order only' in
> scripts/Makefile.headersinst
> 
> 	Sam
Hi Sam,

After disabling the headers_check, the build failure is not seen,
i tried compiling 2.6.24-rc{2,3,4,5,6,7} all of these have this failure.
And when i tried compiling 2.6.23 with allyesconfig i got the following
error

  SYSCALL arch/x86_64/vdso/vdso.so
/usr/bin/ld: section .data [ffffffffff700900 -> ffffffffff700917] overlaps section .plt [ffffffffff7008e4 -> ffffffffff700903]
collect2: ld returned 1 exit status
make[1]: *** [arch/x86_64/vdso/vdso.so] Error 1
make: *** [arch/x86_64/vdso] Error 2

# make --version
GNU Make version 3.79.1

# ld -v
GNU ld version 2.14.90.0.4 20030523

# gcc --version
gcc (GCC) 3.2.3 20030502 

let me know if, i could help you with more information.
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
