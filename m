Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab0CDN0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 08:26:44 -0500
Received: from mail.agmk.net ([91.192.224.71]:49650 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0CDN0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 08:26:43 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: =?utf-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, mikey@neuling.org
Subject: Re: restrict initial stack space expansion to rlimit - the process
 killer...
References: <op.u8zxvxnpzipv1w@pawels.alatek.krakow.pl>
 <op.u81dn2i8zipv1w@pawels.alatek.krakow.pl>
 <2375c9f91003040205y7dff89bbl96de381f9e1393bc@mail.gmail.com>
Date: Thu, 04 Mar 2010 14:26:36 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: =?utf-8?B?UGF3ZcWCIFNpa29yYQ==?= <pawel.sikora@agmk.net>
Message-ID: <op.u81oymnjzipv1w@pawels.alatek.krakow.pl>
In-Reply-To: <2375c9f91003040205y7dff89bbl96de381f9e1393bc@mail.gmail.com>
User-Agent: Opera Mail/10.10 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 04-03-2010 o 11:05:03 Américo Wang <xiyou.wangcong@gmail.com>  
napisał(a):

> 2010/3/4 Paweł Sikora <pawel.sikora@agmk.net>:
>> Hi all,
>>
>> i'm currently testing the 2.6.32.9 and observing random process killing
>> on my builder machine (x86-64) which contains several tcl/bash
>> scripts for svn checkout, compilation, archive and ftp deploying.
>>
>> here's a fragment of build log:
>>
>> (...)
>> [CXX] obj-release-i486-gnu-linux/genMappingRst.o
>> [CXX] obj-release-i486-gnu-linux/otelloVerdiThread.o
>> i486-gnu-linux-g++: Internal error: Killed (program as)
>> Please submit a full bug report.
>> See <http://gcc.gnu.org/bugs.html> for instructions.
>> make[1]: *** [obj-release-i486-gnu-linux/genMappingRst.o] Error 1
>>
>> the builder process tree looks like this:
>>
>> $ pstree -Acl
>> ?---screen-+-bash---loop.sh-+-loop.sh---tclsh8.4---temp_9_12676174---tclsh8.4---temp_3_12676174---tclsh8.4---temp_4_12676174---tclsh8.4---temp_9_12676176---make---make-+-sh---ccache---x86_64-gnu-linu-+-as
>>             |
>> |
>> |                               `-cc1plus
>>             |
>> |
>> `-sh---ccache---x86_64-gnu-linu-+-as
>>             |
>> |
>> `-cc1plus
>>             |                `-tee
>>             `-bash---pstree
>>
>>
>> as you can see there're few levels of bash and tclsh(8.4)
>> and make/ccache/binutils/g++ workers at the bottom.
>>
>> i've noticed that rolling back to the 2.6.32.8 (or just reverting
>> the 'ulimit -s' commit: 35e2093d5d7b632c083af3578c05876375828314)
>> fixes the problem.
>>
>> so, is it my stack ulimit (8192) to small, or maybe the new limit
>> calculations are wrong? shoud i bump the stack limit for new kernels?
>
>
> Please check if you have this patch:
>
> http://lkml.org/lkml/2010/2/15/61
>
> Thanks!

2.6.32.9 + a17e18790a8c47113a73139d54a375dc9ccd8f08 works fine.
i think it should be pushed to 2.6.32.10 as soon as possible.
