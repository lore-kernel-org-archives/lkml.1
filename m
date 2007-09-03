Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbXICSeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbXICSeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 14:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbXICSea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 14:34:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:62748 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbXICSe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 14:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=dGfF++V7lGhSJEDSffWVW7NNpP+uuwf7accU6K1DpU9L+vRZEawlCW2pFbj5a9hCQ41jJz6Vhz5zMUQjUMvfqrc8iJqSrw3ObihyK+cgAMW9HyR3wcf+82N6ha+jWnf+Ma2j0dCeynN8RjQV3iT6ILAQOrcl+TcFmiy0ca3K+Yc=
Message-ID: <46DC5347.1060106@googlemail.com>
Date: Mon, 03 Sep 2007 20:32:39 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Prakash Punnoor <prakash@punnoor.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc5
References: <alpine.LFD.0.999.0708312343440.27951@evo.linux-foundation.org> <200709020954.08285.prakash@punnoor.de> <200709021149.42733.rjw@sisk.pl>
In-Reply-To: <200709021149.42733.rjw@sisk.pl>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Sunday, 2 September 2007 09:54, Prakash Punnoor wrote:
>> Hi,
>>
>> 2.6.23-rc5 locks up hard (Magic Syskeys won't even work) after a few minutes 
>> of work on x86_64. 2.6.23-rc4 was fine. I'll try git-bisect to find out what 
>> is causing trouble. Yes, I am using nvidia binary but it didn't make troubles 
>> since ages... When I found the bugger, I'll try whether it works w/o nvidia 
>> binary.
> 
> Just for the record, I'm running -rc5 on two x86_64 boxes without any visible
> issue.
> 
> I don't use any binary graphics drivers, though.

2.6.23-rc5 dies here random[1] too .. on 2 Dell boxes ( i686 not x86_64 here ) which I upgraded to rc5 yesterday.

When dies 'Caps Lock and Scroll Lock' blinks and the box lockups hard .. rc4 got an 7 days uptime on both with the same config ,
kernel compiled with same gcc/glibc/binutils etc.

I don't have any Oops/BUG or whatever messages in any of my logs nor I'm able to capture everything with netconsole :/
Any idea how else I could capture the Oops/BUG messages ?

Ohh well all I have is this : ( captured with a script which I started some seconds before a box died , no idea it has something to
do with this bug but I post anyway )

..

[ 5414.309269] SysRq : Show Pending Timers
[ 5414.309359] Timer List Version: v0.3
[ 5414.309363] HRTIMER_MAX_CLOCK_BASES: 2
[ 5414.309366] now at 5391544457987 nsecs
[ 5414.309371] 
[ 5414.309372] cpu: 0
[ 5414.309377]  clock 0:
[ 5414.309390]   .index:      0
[ 5414.309394]   .resolution: 1 nsecs
[ 5414.309399]   .get_time:   ktime_get_real
[ 5414.309429]   .offset:     1188833557343399512 nsecs
[ 5414.309435] active timers:
[ 5414.309443]  clock 1:
[ 5414.309448]   .index:      1
[ 5414.309454]   .resolution: 1 nsecs
[ 5414.309458]   .get_time:   ktime_get
[ 5414.309473]   .offset:     0 nsecs
[ 5414.309477] active timers:
[ 5414.309482]  #0: <3>BUG: scheduling while atomic: swapper/0x10010000/0
[ 5414.309500]  [<c0317120>] __sched_text_start+0x5b0/0x6c0
[ 5414.309530]  [<c0115f3c>] __cond_resched+0x18/0x29
[ 5414.309548]  [<c031729a>] cond_resched+0x2a/0x31
[ 5414.309562]  [<c0317ad4>] mutex_lock+0xb/0x1c
[ 5414.309573]  [<c013879e>] lookup_module_symbol_name+0x14/0xbb
[ 5414.309613]  [<c0130018>] print_name_offset+0x1a/0x8e
[ 5414.309630]  [<c0119fd7>] release_console_sem+0x1b1/0x1d1
[ 5414.309656]  [<c012ed00>] timekeeping_resume+0x7d/0xa1
[ 5414.309668]  [<c012d566>] ktime_get_ts+0x1b/0x4e
[ 5414.309681]  [<c01309aa>] timer_list_show+0x661/0xa55
[ 5414.309700]  [<c01320c2>] tick_sched_timer+0x0/0xbd
[ 5414.309715]  [<c022e2a3>] __handle_sysrq+0x7a/0x115
[ 5414.309730]  [<c0228abc>] kbd_event+0x330/0x5d4
[ 5414.309741]  [<c022878c>] kbd_event+0x0/0x5d4
[ 5414.309755]  [<c0279c62>] input_event+0x410/0x44f
[ 5414.309790]  [<c027d8de>] atkbd_interrupt+0x42c/0x56e
[ 5414.309817]  [<c0276a78>] serio_interrupt+0x2f/0x69
[ 5414.309832]  [<c02775f1>] i8042_interrupt+0x108/0x23e
[ 5414.309849]  [<c0121429>] do_timer+0x1c/0xed
[ 5414.309867]  [<c013a271>] handle_IRQ_event+0x25/0x4a
[ 5414.309885]  [<c013b706>] handle_edge_irq+0xb2/0x102
[ 5414.309911]  [<c0104ec3>] do_IRQ+0x3b/0x78
[ 5414.309923]  [<c010db93>] smp_apic_timer_interrupt+0x59/0x84
[ 5414.309937]  [<c010323f>] common_interrupt+0x23/0x28
[ 5414.309947]  [<c0101565>] default_idle+0x0/0x3e
[ 5414.309959]  [<c0101594>] default_idle+0x2f/0x3e
[ 5414.309973]  [<c0100c19>] cpu_idle+0x5e/0x78
[ 5414.309982]  [<c03f2c5a>] start_kernel+0x2c2/0x348
[ 5414.309996]  [<c03f23dd>] unknown_bootoption+0x0/0x1de
[ 5414.310010]  =======================

...

I don't use any *binary* drivers.


[1] It dies after minutes or after hour(s) , dies while doing something ( like compiling , copying stuff ) or while
    doing nothing ( box idles no activity at all ).

Right now I got an 3h uptime ( heh ) while died before in about 2 hours 5 times..

> 
> Greetings,
> Rafael


Gabriel 
