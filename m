Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbYEAAYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbYEAAYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 20:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbYEAAYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 20:24:32 -0400
Received: from simmts12-qfe0.srvr.bell.ca ([206.47.199.141]:41704 "EHLO
	simmts12-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932365AbYEAAYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 20:24:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEBALqqGEicIvo8/2dsb2JhbAAIimiibQ
Message-ID: <48190DBB.9020102@gmail.com>
Date: Wed, 30 Apr 2008 21:24:27 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: WARNING: at kernel/panic.c:375 __stack_chk_test+0x50/0x54()
References: <4819078C.9080405@gmail.com> <48190844.5080804@linux.intel.com>
In-Reply-To: <48190844.5080804@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Kevin Winchester wrote:
>> Hi Arjan,
>>
>> There doesn't seem to be an entry in MAINTAINERS for stack protector, 
>> but your signoff was on the last stack protector related commit I could 
>> find, so it's probably a good bet.
>>
>> I get the following in my dmesg after testing linux-next with the stack 
>> protector turned on.  This is an x86-64 UP box if that helps.  It 
>> appears to be related to the test for the feature (or perhaps that is 
>> supposed to happen when the feature is tested, I'm not sure...).  Config 
>> below.
>>
> 
> the important question is: exactly what gcc are you using? (and if you use a distro gcc,
> which distro)
> 
> second question would be, what does the following command give?
> 
> echo "int foo(void) { char X[200]; return 3; }" | $1 -S -xc -c -O0 -mcmodel=kernel -fstack-protector - -o -
> 
> (this is the command from scripts/gcc-x86_64-has-stack-protector.sh that the kernel uses to test at compiletime
>   if you have stack protector support)

Ubuntu Hardy Heron

kevin@alekhine:~$ gcc --version
gcc (GCC) 4.2.3 (Ubuntu 4.2.3-2ubuntu7)
Copyright (C) 2007 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


kevin@alekhine:~$ echo "int foo(void) { char X[200]; return 3; }" | $1 -S -xc -c -O0 -mcmodel=kernel -fstack-protector - -o -
bash: -S: command not found

I assume that $1 was supposed to be gcc, so how about:

kevin@alekhine:~/linux/linux-2.6/scripts$ sh gcc-x86_64-has-stack-protector.sh gcc something
something

So I would assume that means I pass...

Does that help at all?

-- 
Kevin Winchester




