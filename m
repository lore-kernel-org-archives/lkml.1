Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbXCUKk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbXCUKk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 06:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXCUKk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 06:40:56 -0400
Received: from tornado.reub.net ([210.185.126.1]:47838 "EHLO tornado.reub.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXCUKkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 06:40:55 -0400
X-Greylist: delayed 1569 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Mar 2007 06:40:55 EDT
Message-ID: <46010596.6040900@reub.net>
Date: Wed, 21 Mar 2007 21:14:46 +1100
From: Reuben Farrelly <reuben-linuxkernel@reub.net>
User-Agent: Thunderbird 2.0pre (Windows/20070319)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org>
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/2007 3:56 PM, Andrew Morton wrote:
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> 
> Will appear later at
> 
>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> 
> 
> 
> - Restored the RSDL CPU scheduler (a new version thereof)

Just booted into this kernel, and hit this, which locked up the machine:

This is tornado.reub.net (Linux x86_64 2.6.21-rc4-mm1) 20:16:58

tornado login: ------------[ cut here ]------------
kernel BUG at kernel/sched.c:3505!
invalid opcode: 0000 [1] SMP
last sysfs file: devices/pci0000:00/0000:00:1f.3/i2c-adapter/i2c-0/0-002e/pwm3
CPU 1
Modules linked in: firmware_class eeprom lm85 hwmon_vid i2c_i801 8021q 
iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nfnetlink 
iptable_mangle ip_tables nfs lockd sunrpc ohci1394 ieee1394 usb_storage
Pid: 8250, comm: clamd Not tainted 2.6.21-rc4-mm1 #1
RIP: 0010:[<ffffffff8025d2cb>]  [<ffffffff8025d2cb>] __sched_text_start+0x3cb/0x8b3
RSP: 0000:ffff8100023cfee0  EFLAGS: 00010002
RAX: 000000000000008c RBX: ffff810001e040e8 RCX: 000000000000000c
RDX: 0000000000000000 RSI: 000000000000008c RDI: ffff810001e049b8
RBP: ffff8100023cff70 R08: 000000000000008c R09: ffff810001e049a8
R10: 0000000000000034 R11: 0000000000000000 R12: ffff810001e03f00
R13: 0000000000000002 R14: 00000000ffffffff R15: 000000521b55f827
FS:  00002b1dfda2ec00(0000) GS:ffff81000208ec40(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002aaaaafcf000 CR3: 0000000004ac3000 CR4: 00000000000006e0
Process clamd (pid: 8250, threadinfo ffff8100023ce000, task ffff810004c090a0)
Stack:  ffff810004c090a0 ffffffff8025fdb7 ffff810004c090a0 00007fffae43e955
  ffff810004c09248 00000001023cff28 ffffffff8029635d 0000000000c5aac0
  0000000000000005 00002b1dfc7d6d5a ffffffff8025fdb7 0000000000000000
Call Trace:
  [<ffffffff8025fdb7>] trace_hardirqs_on_thunk+0x35/0x37
  [<ffffffff8029635d>] trace_hardirqs_on+0x12a/0x15d
  [<ffffffff8025fdb7>] trace_hardirqs_on_thunk+0x35/0x37
  [<ffffffff8025a7e0>] retint_careful+0x12/0x2e


Code: 0f 0b eb fe 49 8b 94 24 e0 01 00 00 49 8b 84 24 d8 01 00 00
RIP  [<ffffffff8025d2cb>] __sched_text_start+0x3cb/0x8b3
  RSP <ffff8100023cfee0>
BUG: spinlock lockup on CPU#0, swapper/0, ffff810001e03f00
BUG: spinlock lockup on CPU#1, clamd/8250, ffff810001e03f00

every few minutes the last two lines would be repeated.

This kernel does not include the hotfixes (the gentoo portage ebuild for this 
release does not yet include them), however I am uncertain if they fix this 
problem or not anyway.

Also, what happened to the -mm announcements sent to 
linux-kernel-announce@vger.kernel.org?  Maybe I'm the only person to miss them :-)

Reuben
