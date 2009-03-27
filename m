Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbZC0JzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbZC0JzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZC0JzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:55:09 -0400
Received: from main.gmane.org ([80.91.229.2]:57159 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080AbZC0JzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:55:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Philippe Reynes <philippe.reynes@isismpp.fr>
Subject: Re: [Announce] 2.6.29-rt1
Date: Fri, 27 Mar 2009 09:37:17 +0000 (UTC)
Message-ID: <gqi6oc$1s3$1@ger.gmane.org>
References: <49b7c2350903260354p6eaf50ebo87985dcfb8d48ba0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: extranet.isismpp.fr
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-rt-users@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi


I've got crashes when I run an app with thread with RT priority.
This crash could happen on any comman, here some log of crashes :


First one :

server calling Oops: Exception in kernel mode, sig: 5 [#1]
PREEMPT MPC837x RR605
Modules linked in:
NIP: c0075b08 LR: c0075a50 CTR: c00d7d90
REGS: dbb6dcb0 TRAP: 0700   Not tainted  (2.6.29-rt1)
MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 24002488  XER: 00000000
TASK = dddea1e0[1769] 'vsftpd' THREAD: dbb6c000
GPR00: 00000001 dbb6dd60 dddea1e0 df803e24 df803e10 df803e08 00000000 
ddc72020 
GPR08: 00000000 0000001b dddea1e0 df803e24 24000482 100bf094 00000000 
c04aa6fc 
GPR16: 00200200 00100100 c04e5958 c04e595c dbb6dd68 c04e0000 c04e0000 
c04aa6bc 
GPR24: 00000020 dbb6ddd8 00000010 df80ae00 00000000 dbb6de38 df816800 
df803e00 
NIP [c0075b08] cache_alloc_refill+0x180/0x62c
LR [c0075a50] cache_alloc_refill+0xc8/0x62c
Call Trace:
[dbb6dd60] [c038878c] preempt_schedule_irq+0x5c/0x80 (unreliable)
[dbb6ddd0] [c00761a0] kmem_cache_alloc+0x6c/0x140
[dbb6de00] [c002ddb4] __sigqueue_do_alloc+0xa0/0xec
[dbb6de10] [c002e2f8] send_signal+0xa4/0x224
[dbb6de30] [c002f680] do_notify_parent+0x1a8/0x1d4
[dbb6ded0] [c0025608] do_exit+0x584/0x69c
[dbb6df10] [c00257a0] do_group_exit+0x80/0xac
[dbb6df30] [c00257e0] sys_exit_group+0x14/0x28
[dbb6df40] [c00117f4] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfef463c
    LR = 0xffa5884
Instruction dump:
7f87f800 40be0018 80ff0010 38000001 901f0048 7f872000 419e00e8 80070010 
813b001c 7c090010 38000000 7c000114 <0f000000> 381a0001 38c7001c 7c0903a6 
---[ end trace 99200bd45c29aa91 ]---
Fixing recursive fault but reboot is needed!


Second one :
I've run my app, and after just run a simple "ifconfig"


-sh-2.05b# ifconfig 
eth0      Link eOops: Exception in kernel mode, sig: 5 [#1]
PREEMPT MPC837x RR605
Modules linked in:
NIP: c0075b08 LR: c0075a50 CTR: c02cf170
REGS: dab41cb0 TRAP: 0700   Not tainted  (2.6.29-rt1)
MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 24002488  XER: 00000000
TASK = df8be100[1756] 'ifconfig' THREAD: dab40000
GPR00: 00000001 dab41d60 df8be100 df803e24 df803e10 df803e08 00000000 
dddcc000 
GPR08: 00000000 0000001b df8be100 df803e24 24000482 10023370 00000000 
c04aa6fc 
GPR16: 00200200 00100100 c04e5958 c04e595c dab41d68 c04e0000 c04e0000 
c04aa6bc 
GPR24: 00000020 dab41dd8 00000010 df80ae00 00000000 dab41e38 df816800 
df803e00 
NIP [c0075b08] cache_alloc_refill+0x180/0x62c
LR [c0075a50] cache_alloc_refill+0xc8/0x62c
Call Trace:
[dab41d60] [00000001] 0x1 (unreliable)
[dab41dd0] [c00761a0] kmem_cache_alloc+0x6c/0x140
[dab41e00] [c002ddb4] __sigqueue_do_alloc+0xa0/0xec
[dab41e10] [c002e2f8] send_signal+0xa4/0x224
[dab41e30] [c002f680] do_notify_parent+0x1a8/0x1d4
[dab41ed0] [c0025608] do_exit+0x584/0x69c
[dab41f10] [c00257a0] do_group_exit+0x80/0xac
[dab41f30] [c00257e0] sys_exit_group+0x14/0x28
[dab41f40] [c00117f4] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xff3b63c
    LR = 0xffec884
Instruction dump:
7f87f800 40be0018 80ff0010 38000001 901f0048 7f872000 419e00e8 80070010 
813b001c 7c090010 38000000 7c000114 <0f000000> 381a0001 38c7001c 7c0903a6 
---[ end trace f43c24570097662c ]---
Fixing recursive fault but reboot is needed!



The kernel is a 2.6.29-rt1 compiled with ltib for powerpc (mpc8377E).

Philippe



Le Thu, 26 Mar 2009 19:54:25 +0900, GeunSik Lim a écrit :

> Hi,
> 
> I understood statement that Thosmas explained about invalid access of
> 2.6.29-rt1 soruces.
> In general,
> We remeber rc directory (./v2.6/testing/ and release directory (./v2.6/)
> certainly.
> 
> Release Version is located in
> http://www.kernel.org/pub/linux/kernel/v2.6/ site. RC      Version is
> located in
> http://www.kernel.org/pub/linux/kernel/v2.6/testing/ site.
> 
> I summarized quick howto per notice of "2.6.* rt patch" file. fc9#> wget
> http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.tar.bz2
>   (If linux version is RC[release candidate] version,
>  use "wget http://www.kernel.org/pub/linux/kernel/v2.6/testing/***"
>  command.)
> fc9#> wget
> http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rt1.bz2
> fc9#> tar xjf ./linux-2.6.29.tar.bz2
> fc9#> tar xvjf ./patch-2.6.29-rt1-broken-out.tar.bz2 fc9#> cd
> ./linux-2.6.29
> fc9#> for i in `cat ../patches/series | grep patch | grep -v "#"  `;do
> echo "+++ patching $i"; patch -p1 <
> 
> ../patches/$i;done
> fc9#> cp ./arch/x86/configs/i386_defconfig ./.config fc9#> make
> menuconfig
>         ..... Below Omission .....
>   	
>   	
> Regards,
> GeunSik Lim
> 
> ----- Original Message -----
> From: "Thomas Gleixner" <tglx@linutronix.de> To: "Jaswinder Singh
> Rajput" <jaswinder@kernel.org> Cc: "LKML"
> <linux-kernel@vger.kernel.org>; "rt-users"
> <linux-rt-users@vger.kernel.org>; "Ingo Molnar" <mingo@elte.hu>; "Steven
> Rostedt" <rostedt@goodmis.org>; "Peter Zijlstra" <peterz@infradead.org>;
> "Carsten Emde" <ce@ceag.ch>; "Clark Williams" <williams@redhat.com>;
> "Frank Rowand" <frank.rowand@am.sony.com> Sent: Thursday, March 26, 2009
> 6:09 AM Subject: Re: [Announce] 2.6.29-rt1
> 
> 
>> On Thu, 26 Mar 2009, Jaswinder Singh Rajput wrote:
>>
>>> On Wed, 2009-03-25 at 21:59 +0100, Thomas Gleixner wrote:
>>> > We are pleased to announce the next update to our new preempt-rt
>>> > series.
>>> >
>>> >      - port forward to 2.6.29 final
>>> >
>>> > Download locations:
>>> >
>>> >     http://rt.et.redhat.com/download/
>>> >     http://www.kernel.org/pub/linux/kernel/projects/rt/
>>> >
>>> > Information on the RT patch can be found at:
>>> >
>>> >     http://rt.wiki.kernel.org/index.php/Main_Page
>>> >
>>> > to build the 2.6.29-rt1 tree, the following patches should be
>>> > applied:
>>> >
>>> >     http://www.kernel.org/pub/linux/kernel/v2.6/testing/
linux-2.6.29.tar.bz2
>>>
>>> Is this valid ?
>>
>> If we remove the testing/ it should work better :)
>>
>>   tglx
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in the body of a message to majordomo@vger.kernel.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html Please read the FAQ
>> at  http://www.tux.org/lkml/
>>
>>
>>
>>


