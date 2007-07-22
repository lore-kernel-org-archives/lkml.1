Return-Path: <linux-kernel-owner+w=401wt.eu-S932996AbXGVXh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996AbXGVXh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762037AbXGVXhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:37:11 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:30109 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822AbXGVXhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:37:09 -0400
Date: Sun, 22 Jul 2007 16:41:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: =?ISO-8859-1?Q? "J.A._Magall=F3n" ?= <jamagallon@ono.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Oops with touch and unknown uid [was Re: 2.6.22-rc6-mm1]
Message-Id: <20070722164110.dfa6d928.randy.dunlap@oracle.com>
In-Reply-To: <20070722234814.0f792452@werewolf-wl>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
	<20070722234814.0f792452@werewolf-wl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2007 23:48:14 +0200 J.A. Magallón wrote:

> On Thu, 28 Jun 2007 03:43:21 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/
> > 

so is this 2.6.22-rc6-mm1 or is it as Oops says:  2.6.21-jam12 ?

I tested 2.6.22-rc6-mm1 and couldn't reproduce this.
Maybe your .config file would help.


> I have noticed a funny problem.
> Lets say 666 is not an uid used on you system. This oopses:
> 
> rm -f dummy
> touch dummy
> chown 666 dummy
> touch dummy
> 
> Oops:
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address 0000006a
>  printing eip:
> c0165281
> *pde = 00000000
> Oops: 0000 [#2]
> PREEMPT SMP 
> Modules linked in: w83627hf hwmon_vid hwmon i2c_dev loop floppy udf microcode snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm nvidia(P) snd_timer 3c59x snd_page_alloc snd_util_mem snd_hwdep snd usblp ohci1394 e1000 ieee1394 sata_promise emu10k1_gp gameport intel_agp i2c_i801 agpgart evdev sg
> CPU:    3
> EIP:    0060:[<c0165281>]    Tainted: P      D VLI
> EFLAGS: 00210297   (2.6.21-jam12 #1)
> EIP is at permission+0x4/0xa1
> eax: 00000000   ebx: c5785aa0   ecx: c43a1f04   edx: 00000002
> esi: 00000000   edi: 00000000   ebp: c3442c00   esp: c43a1ef0
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process touch (pid: 8401, ti=c43a1000 task=c25d69b0 task.ti=c43a1000)
> Stack: c5785aa0 fffffff3 c017ba84 c43e9c50 c55c52a8 c43e9c50 c344ab7c 000000c9 
>        00000000 00000000 c3442c00 00000000 b7f14f70 c4f574d0 c2ea5400 c03ef580 
>        00000000 00000004 b7f14f70 c0125cac ffffffff 00000000 00000000 c4f574d0 
> Call Trace:
>  [<c017ba84>] do_utimes+0x174/0x1b9
>  [<c0125cac>] __atomic_notifier_call_chain+0x27/0x4d
>  [<c0111a06>] do_page_fault+0x523/0x68d
>  [<c017bbb3>] sys_utimensat+0x22/0x92
>  [<c01114e3>] do_page_fault+0x0/0x68d
>  [<c0102902>] sysenter_past_esp+0x5f/0x85
>  [<c0300000>] packet_setsockopt+0x279/0x325
>  =======================
> Code: eb b1 66 c1 ee 06 8d 74 26 00 eb 8c 83 e7 02 75 c5 b8 02 00 00 00 8d 74 26 00 e8 16 bf fb ff 85 c0 74 b3 31 c0 eb c9 56 53 89 c6 <0f> b7 58 6a f6 c2 02 74 31 8b 80 a4 00 00 00 f6 40 30 01 74 1c 
> EIP: [<c0165281>] permission+0x4/0xa1 SS:ESP 0068:c43a1ef0
> 
> Any ideas ?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
