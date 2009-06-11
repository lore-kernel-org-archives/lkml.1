Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbZFKW4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbZFKW4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbZFKWzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:55:54 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:57526 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760191AbZFKWzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=LCVLlpfgXUt+mgEv6m8qTgBz/Kl1I1nU05RV/0DywGjCAjRyx7l8/lLcG+zwEsv4Bu
         qYWogeCCPoWtspPy27AyJy9Cn7kaO8hbqb6SIf2DU1HwinQow+IqvTc3sAvPjZFyxZi0
         8/uYw+0pNTvdOWiyi8ShgP4lfdIhMX5qLkExo=
MIME-Version: 1.0
In-Reply-To: <4A317433.5000700@goop.org>
References: <3e8340490906071010l33ceaf5eh304e163178384592@mail.gmail.com> 
	<3e8340490906081305u1ad00ba7s78b367e4fa8973c4@mail.gmail.com> 
	<4A317433.5000700@goop.org>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 11 Jun 2009 18:55:34 -0400
Message-ID: <3e8340490906111555r313ff6e9nce956fc76eff7382@mail.gmail.com>
Subject: Re: [OOPS] [XEN] OOPS early after boot on master
To: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       xen-devel@lists.xensource.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 5:16 PM, Jeremy Fitzhardinge<jeremy@goop.org> wrote:
> On 06/08/09 13:05, Bryan Donlan wrote:
>>
>> On Sun, Jun 7, 2009 at 1:10 PM, Bryan Donlan<bdonlan@gmail.com>  wrote:
>>
>>>
>>> Shortly after boot, I got this OOPS:
>>>
>>> ------------[ cut here ]------------
>>> kernel BUG at kernel/sched.c:1209!
>>> invalid opcode: 0000 [#1] SMP
>>> last sysfs file: /sys/block/md0/dev
>>> Modules linked in:
>>>
>>> Pid: 1312, comm: khelper Not tainted (2.6.30-rc8 #1)
>>> EIP: 0061:[<c011e3a9>] EFLAGS: 00010046 CPU: 3
>>> EIP is at resched_task+0x69/0x70
>>> EAX: 00000000 EBX: c05c5660 ECX: 00000000 EDX: 00000002
>>> ESI: d60bb810 EDI: d7026600 EBP: 00000001 ESP: d5b1dee0
>>>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
>>> Process khelper (pid: 1312, ti=d5b1c000 task=d6138420 task.ti=d5b1c000)
>>> Stack:
>>>  c05c5660 d605f810 c0125aa0 00000000 00000000 00000000 00000000 d6075eb8
>>>  d6075ef4 00000001 00000001 c011f7c3 00000000 00000003 d6075f00 d6075ef8
>>>  d6075efc 00000200 00000000 c011fea0 00000000 00000000 d6138420 d6075ef8
>>> Call Trace:
>>>  [<c0125aa0>] ? try_to_wake_up+0xa0/0x1d0
>>>  [<c011f7c3>] ? __wake_up_common+0x43/0x70
>>>  [<c011fea0>] ? complete+0x40/0x60
>>>  [<c0128c10>] ? mm_release+0x40/0xc0
>>>  [<c01051de>] ? __raw_callee_save_xen_restore_fl+0x6/0x8
>>>  [<c05c1a2e>] ? _spin_unlock_irqrestore+0x1e/0x30
>>>  [<c012c3e6>] ? exit_mm+0x16/0x110
>>>  [<c01051ee>] ? __raw_callee_save_xen_irq_enable+0x6/0x8
>>>  [<c012df2e>] ? do_exit+0xfe/0x6d0
>>>  [<c05c007b>] ? schedule_timeout+0x10b/0x150
>>>  [<c010bacc>] ? kernel_execve+0x1c/0x30
>>>  [<c013b550>] ? ____call_usermodehelper+0x0/0x130
>>>  [<c013b67b>] ? ____call_usermodehelper+0x12b/0x130
>>>  [<c013b550>] ? ____call_usermodehelper+0x0/0x130
>>>  [<c01087d7>] ? kernel_thread_helper+0x7/0x10
>>> Code: c2 74 0e 0f ae f0 89 f6 8b 46 04 f6 40 0c 04 74 09 5b 5e c3 8d
>>> b6 00 00 00 00 89 d0 ff 15 f0 2e 6f c0 5b 5e 8d b6 00 00 00 00 c3<0f>
>>> 0b eb fe 8d 76 00 53 89 c3 8b 0c 85 a0 b6 73 c0 ba 00 76 7a
>>> EIP: [<c011e3a9>] resched_task+0x69/0x70 SS:ESP 0069:d5b1dee0
>>> ---[ end trace 155a42330fa44f01 ]---
>>> Fixing recursive fault but reboot is needed!
>>>
>>> This occurs under i386, with commit 81ee1ba; x86_64 does not (seem to)
>>> have this issue. I'll try to bisect this shortly.
>>>
>>
>> Still working on the actual bisection, but the OOPS only occurs with
>> CONFIG_PARAVIRT_SPINLOCKS enabled.
>>
>
> Thanks for the report.  I haven't had a chance to look at it in detail, but
> its interesting that it appears to be pv spinlocks...

On further analysis, it seems that that's a red herring - disabling PV
spinlocks just makes it occur less often, I think... I'm currently
still bisecting it; it's complicated by other OOPS-causing bugs having
existed in the interim, but it definitely existed before the
introduction of CONFIG_PARAVIRT_SPINLOCKS.
