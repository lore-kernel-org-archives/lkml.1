Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbZCKR3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbZCKR3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbZCKR3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:29:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62785 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZCKR3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:29:40 -0400
Message-ID: <49B7F502.10603@wettinet.de>
Date: Wed, 11 Mar 2009 18:29:38 +0100
From: =?ISO-8859-15?Q?Ivo_R=F6ssling?= <ivo@wettinet.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.27.7 runs into Kernel Panic on Shuttle X27D with Intel
 Atom 330 
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+HYIbZU+Fy9YDx33TRWU7OEF9eM+QxqwCwbsy
 DBquAqMsgw5lgaSXznaGsRoYQ5I/QkVc02uGY3ZE/e44IEcwrS
 sCwzxrndB3bZpDRK0eo3xVOVp2L/CZR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, there!

I experienced a kernel panic when trying to install the OpenSuSE 11.1
[x86-64] on my new Shuttle X27D with an Intel Atom 330.

The manual of the Shuttle X27D is not all too verbose, so I cannot say
much about the chipset or BIOS yet. (But I might find out whatever may
be important. It's just that I don't have it at hand right now...)

When I boot the Install DVD of OpenSuSE [x86-64] and chose "Install"
without changing any option, I run into the following error:

---------- snip ----------
BUG: unable to handle kernel paging request at ffffffff80209000
IP: [<ffffffff80246bc>] on_each_cpu+0x0/0x30
PGD 203067 PUD 207063 PMD 7dfc6163 PTE 209161
Oops: 003 [1] SMP
last sysfs file:
CPU 0
Modules linked in:
supported: Yes
Pid: 1, comm: swapper Not tainted 2.6.27.7-default #1
---------- snap ----------

[...]

---------- snip ----------
Call Trace:
[<ffffffff80229f1b>] change_page_attrset_clr+0x130/0x1e4
[<ffffffff8022752b>] mark_rodata_ro+0x65/0x78
[<ffffffff80209130>] init_post+0x13/0x183
[<ffffffff808eb930>] kernel_init+0xe6/0xea
[<ffffffff8020d7b9>] child_rip+0xa/0x11

Code: 25 00 00 00 00 48 89 da 48 87 10 e8 a7 e0 00 00 85 c0 74 e3 65 48
8b 04 25 00 00 00 00 48 c7 00 00 00 00 00 31 c0 41 5a 5b 5d c3 <41> 55
49 89 fd 41 54 49 89 f4 53 e8 dd c0 01 00 89 c3 fa 0f 1f
RIP [<ffffffff802460bc>] on_each_cpu+0x0/0x30
 RSP <ffff8807d419d78>
CR2: fffffff80209000
---[end trace 49212d7546df107a]---
Kernel panic - not syncing: Attempted to kill init!
---------- snap ----------

I tried to update my BIOS to the latest version provided by Shuttle.com,
which itself was successful. Unfortunately that didn't help anything.
I also tried the hint posted in one of the SuSE-forums to use the the
network installation. But that didn't help either...

On some webpage I read that the network device of the Shuttle causes
kernel panic on MacOS, so I disabled it in the BIOS. Unforunately that
didn't help either. Only the error changed slightly a bit:

---------- snip ----------
BUG: unable to handle kernel paging request at 00000000006f1000
IP: [<ffffffff8020d420>] apic_timer_interrupt+0x0/0x90
PGD 0
Oops: 0002 [1] SMP
last sysfs file:
CPU 0
Modules linked in:
Supported: Yes
Pid: 1, comm: swapper Not tainted 2.6.27.7-default #1
---------- snap ----------

[...]

---------- snip ----------
Call Trace:
[<ffffffff8022886e>] __phys_addr+0x1e/0x2e
[<ffffffff80229b42>] __change_page_attr+0x13b/0x25d
[<ffffffff80229c81>] __change_page_attr_set_clr+0x1d/0x53
[<ffffffff80229d65>] cpa_process_alias+0xae/0x134
[<ffffffff80229c92>] __change_page_attr_set_clr+0x2e/0x53
[<ffffffff80229ea7>] change_page_attrset_clr+0xbc/0x1e4
[<ffffffff8022752b>] mark_rodata_ro+0x65/0x78
[<ffffffff80209130>] init_post+0x13/0x183
[<ffffffff808eb930>] kernel_init+0xe6/0xea
[<ffffffff8020d7b9>] child_rip+0xa/0x11


Code: 44 00 00 65 ff 04 25 20 00 00 00 65 48 0f 44 24 25 28 00 00 00 55
e8 e6 21 01 00 e9 19 f6 ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 <68> 10
ff ff ff fc 48 83 ec 48 48 89 7c 24 40 48 48 89 74 24 38 48
RIP [<ffffffff8020d420>] apic_timer_interrupt+0x0/0x90
 RSP <ffff88007d419d28>
CR2: 00000000006f1000
---[end trace 41d930af09f92734 ]---
Kernel panic - not syncing: Attempted to kill init!
---------- snap ----------


I should finally note that the kernel panic did NOT occur when trying to
install OpenSuSE 11.0 [x86-64] (which is running a 2.6.25.5-1.1 kernel)
or OpenSuSE 11.1 [i586]

Ivo.

P.S.: I'd like to be personally CC'ed the answers/comments posted to the
list in response to my posting.


