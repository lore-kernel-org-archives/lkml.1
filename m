Return-Path: <linux-kernel-owner+w=401wt.eu-S1759932AbYGKLKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbYGKLKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbYGKLEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:04:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:38369 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141AbYGKLEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZegtgfsCa0etBh1+Yrq/SvpViQzLVsM2AUC6iniNJoW6XaXYe2nBtMIydb93MZjTXW
         jKODaoVTNLTB5/M53P9Ss/Q35IKVenAu4ztaRA6PL/lbRMKE54zW3qSPh2laookDJfqn
         MuqT09hwlcAPfJY/d1q2MwQ74AJTABemkLGos=
Message-ID: <19f34abd0807110404p5c588debu681aa466cc98ad08@mail.gmail.com>
Date: Fri, 11 Jul 2008 13:04:30 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0807110202o10ca65c7yf93d8b2146a05e33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
	 <b647ffbd0807100703q442a9825hb857c321452027e7@mail.gmail.com>
	 <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
	 <19f34abd0807101249y24632b50h769a7af2c9514864@mail.gmail.com>
	 <b647ffbd0807101316o97fe6d4p5b2cbcda472f2ae1@mail.gmail.com>
	 <19f34abd0807102249t6b2e9e97l97bc5b22cc7709ef@mail.gmail.com>
	 <b647ffbd0807110202o10ca65c7yf93d8b2146a05e33@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 11:02 AM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
> Vegard,
>
>
> regarding the first crash. Would you please run your test with the
> following debugging patch and let me know its output?
>
> The apperance of " * [ pid ] comm (name), orig_cpu() ... " means we
> hit a problematic case (with Miao Xie's patch it shouldn't crash).
>
> I see that you have CONFIG_SCHED_DEBUG=y so I'm also interested in
> messages from sched_domain_debug() - "CPU# attaching ...". IOW, all
> the kernel messages appearing while a cpu is going down and up.

I didn't look into it, but your patch gives the following warnings:

kernel/sched.c: In function 'try_to_wake_up':
kernel/sched.c:2080: warning: 'orig_cpu' may be used uninitialized in
this function
kernel/sched.c:2080: warning: 'cpu' may be used uninitialized in this function

Running on qemu (sorry, real machine has to wait) gets me this:

__migrate(6 -- migration/1) -> cpu (0) == ret (1)
__migrate(7 -- ksoftirqd/1) -> cpu (0) == ret (1)
__migrate(8 -- watchdog/1) -> cpu (0) == ret (1)
__migrate(10 -- events/1) -> cpu (0) == ret (1)
__migrate(104 -- kblockd/1) -> cpu (0) == ret (1)
__migrate(111 -- ata/1) -> cpu (0) == ret (1)
__migrate(118 -- khubd) -> cpu (0) == ret (1)
__migrate(178 -- pdflush) -> cpu (0) == ret (1)
__migrate(262 -- aio/1) -> cpu (0) == ret (1)
__migrate(278 -- nfsiod) -> cpu (0) == ret (1)
__migrate(994 -- khpsbpkt) -> cpu (0) == ret (1)
__migrate(1023 -- kpsmoused) -> cpu (0) == ret (1)
__migrate(1032 -- kstriped) -> cpu (0) == ret (1)
__migrate(1036 -- kondemand/1) -> cpu (0) == ret (1)
__migrate(1061 -- rpciod/1) -> cpu (0) == ret (1)
__migrate(1209 -- udevd) -> cpu (0) == ret (1)
__migrate(2793 -- getty) -> cpu (0) == ret (1)
__migrate(2827 -- syslogd) -> cpu (0) == ret (1)
__migrate(2849 -- dd) -> cpu (0) == ret (1)
__migrate(2852 -- klogd) -> cpu (0) == ret (1)
__migrate(2877 -- named) -> cpu (0) == ret (1)
__migrate(2878 -- named) -> cpu (0) == ret (1)
__migrate(2879 -- named) -> cpu (0) == ret (1)
__migrate(2880 -- named) -> cpu (0) == ret (1)
__migrate(2881 -- named) -> cpu (0) == ret (1)
__migrate(2941 -- cupsd) -> cpu (0) == ret (1)
__migrate(2978 -- mysqld_safe) -> cpu (0) == ret (1)
__migrate(3039 -- mysqld) -> cpu (0) == ret (1)
__migrate(3050 -- mysqld) -> cpu (0) == ret (1)
__migrate(3051 -- mysqld) -> cpu (0) == ret (1)
__migrate(3052 -- mysqld) -> cpu (0) == ret (1)
__migrate(3054 -- mysqld) -> cpu (0) == ret (1)
__migrate(3058 -- mysqld) -> cpu (0) == ret (1)
__migrate(3059 -- mysqld) -> cpu (0) == ret (1)
__migrate(3067 -- mysqld) -> cpu (0) == ret (1)
__migrate(3071 -- mysqld) -> cpu (0) == ret (1)
__migrate(3040 -- logger) -> cpu (0) == ret (1)
__migrate(3152 -- postgres) -> cpu (0) == ret (1)
__migrate(3350 -- bash) -> cpu (0) == ret (1)
__migrate(3398 -- smbd) -> cpu (0) == ret (1)
__migrate(3426 -- winbindd) -> cpu (0) == ret (1)
__migrate(3433 -- winbindd) -> cpu (0) == ret (1)
__migrate(3454 -- dovecot) -> cpu (0) == ret (1)
__migrate(3472 -- pop3-login) -> cpu (0) == ret (1)
__migrate(3474 -- imap-login) -> cpu (0) == ret (1)
__migrate(3475 -- imap-login) -> cpu (0) == ret (1)
__migrate(3498 -- cron) -> cpu (0) == ret (1)
__migrate(3536 -- apache2) -> cpu (0) == ret (1)
__migrate(3546 -- apache2) -> cpu (0) == ret (1)
__migrate(3550 -- apache2) -> cpu (0) == ret (1)
__migrate(3552 -- apache2) -> cpu (0) == ret (1)
__migrate(3616 -- su) -> cpu (0) == ret (1)
__migrate(3630 -- bash) -> cpu (0) == ret (1)
__migrate(3634 -- kstopmachine) -> cpu (0) == ret (1)
general protection fault: 0600 [#1] PREEMPT SMP DEBUG_PAGEALLOC

Pid: 0, comm: swapper Not tainted (2.6.26-rc9-00103-g2702484 #18)
EIP: 0600:[<00000004>] EFLAGS: 00000002 CPU: 1
EIP is at 0x4
EAX: 00010600 EBX: c0102d10 ECX: c123a080 EDX: c7858000
ESI: 00000001 EDI: c07df880 EBP: c7861f94 ESP: c7861f84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c7860000 task=c7858000 task.ti=c7860000)
Stack: c0791020 c123a020 00000001 00000000 c7861fb4 c056d12b 00000000 00000000
       00000000 00000000 00000800 00000000 c7861fb0 00000000 00000000 00000000
       00000000 00000000 00000000 00000000 00000000 00000000 000000d8 00000000
Call Trace:
 [<c056d12b>] ? start_secondary+0x14b/0x1b0
 =======================
Code:  Bad EIP value.
EIP: [<00000004>] 0x4 SS:ESP 0068:c7861f84
---[ end trace f8284f363f0b3f16 ]---
Kernel panic - not syncing: Attempted to kill the idle task!


Note: This was latest linux-2.6.git/master WITHOUT Miao Xie's patch.

But it seems to have done "call $0" at one point or another. But it
might just be qemu as we didn't see exactly this report on the real
machine before.

Ok, now I tested it on my laptop (sorry, no serial console :-)) and I
get a spinlock recursion. Sorry for bad pics, but it's the best I can
do with the camera at hand:

http://folk.uio.no/vegardno/linux/DSC04925.JPG
http://folk.uio.no/vegardno/linux/DSC04926.JPG
http://folk.uio.no/vegardno/linux/DSC04927.JPG (probably best pic, but
some of the msg is cut off, see pic #1 instead)

Should I use Miao Xie's patch as well?

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
