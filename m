Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbYLXBcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbYLXBcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 20:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbYLXBb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 20:31:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:49928 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbYLXBb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 20:31:56 -0500
Message-ID: <495190F7.1030708@kernel.org>
Date: Tue, 23 Dec 2008 17:31:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ken Chen <kenchen@google.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: panic with tg_shares_up again?
References: <86802c440812231328oa5e9682q9ad70a96680463b2@mail.gmail.com>	 <20081223213630.GA5053@elte.hu>	 <b040c32a0812231546s70cf651la19aec03fb9a308c@mail.gmail.com> <b040c32a0812231707w7a1704c5y169b659a394ba2a7@mail.gmail.com>
In-Reply-To: <b040c32a0812231707w7a1704c5y169b659a394ba2a7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Chen wrote:
> On Tue, Dec 23, 2008 at 3:46 PM, Ken Chen <kenchen@google.com> wrote:
>> And from my local build of linux-tip with the patch, I have the
>> following assembly:
>>     1  ffffffff8023b74f:  48 8b 88 a8 00 00 00    mov    0xa8(%rax),%rcx
>>     2  ffffffff8023b756:  48 c7 45 d0 00 00 00    movq   $0x0,-0x30(%rbp)
>>     3  ffffffff8023b75d:  00
>>     4  ffffffff8023b75e:  48 85 c9                test   %rcx,%rcx
>>     5  ffffffff8023b761:  0f 95 c0                setne  %al
>>     6  ffffffff8023b764:  84 45 af                test   %al,-0x51(%rbp)
>>     7  ffffffff8023b767:  74 15                   je     ffffffff8023b77e
>>     8  ffffffff8023b769:  48 8b 45 b8             mov    -0x48(%rbp),%rax
>>     9  ffffffff8023b76d:  31 d2                   xor    %edx,%edx
>>    10  ffffffff8023b76f:  48 0f af c1             imul   %rcx,%rax
>>    11  ffffffff8023b773:  48 f7 75 b0             divq   -0x50(%rbp)
>>
>> line 6 is the compare against sd_rq_weight, but it was only to one
>> byte instead of the entire unsigned long.
>>
>> /me scratching my head ....
> 
> After a couple of hours joggling with type cast and different order in
> which these two variables are checked, the compiler I'm using seems to
> insist only check one byte out of sd_rq_weight.  I give up for the day
> and removed the 'static' function declaration of
> update_group_shares_cpu().  Without the 'static', the assembly looks
> alright to me.
> 
> I will ask compiler expert to see what's wrong with this code.  For
> now, the following add on patch seems generate correct x86 assembly
> code.

maybe my compiler has some problem too?  just upgrade to opensuse 11.1 last week.

yhlu@linux-mstp:~/xx/xx/kernel/tip/linux-2.6> gcc --version
gcc (SUSE Linux) 4.3.2 [gcc-4_3-branch revision 141291]
Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
