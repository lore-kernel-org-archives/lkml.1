Return-Path: <linux-kernel-owner+w=401wt.eu-S1761099AbZFRMES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761099AbZFRMES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbZFRMEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:04:04 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:56974 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627AbZFRMED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:04:03 -0400
Message-ID: <4A3A2D2B.7070704@in.ibm.com>
Date: Thu, 18 Jun 2009 17:33:55 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: alan@lxorguk.ukuu.org.uk, linuxppc-dev@ozlabs.org
Subject: [PowerPC] Badness at drivers/char/tty_ldisc.c:210 during shutdown
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I came across the following badness message during shutdown on a Power6 box.
This was with 2.6.30-git12(3fe0344faf7fdcb158bd5c1a9aec960a8d70c8e8)

------------[ cut here ]------------
Badness at drivers/char/tty_ldisc.c:210
NIP: c000000000409428 LR: c000000000409410 CTR: 0000000000000000
REGS: c0000000374f37f0 TRAP: 0700   Not tainted  (2.6.30-git12)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24000484  XER: 00000001
TASK = c00000003d941ae0[8535] 'vhangup' THREAD: c0000000374f0000 CPU: 1
<6>GPR00: 0000000000000001 c0000000374f3a70 c000000000ef4550 0000000000000001
<6>GPR04: c000000000409410 c00000003e99f000 c000000000406ba0 0000000000000000
<6>GPR08: 0000000000000000 0000000000000000 0000000000000000 c0000000374f3a70
<6>GPR12: 0000000024000488 c000000001002600 00000000ffffffff ffffffffffffffff
<6>GPR16: 00000000320c8a50 0000000000000002 0000000000000000 00000000320b03b0
<6>GPR20: 0000000000000000 0000000000000000 c00000003e1d3d00 0000000000000001
<6>GPR24: 0000000000000000 0000000000000000 0000000000000001 c00000003d4a05e0
<6>GPR28: 0000000000000000 c0000000013ffd38 c000000000e7e610 c0000000374f3a70
NIP [c000000000409428] .tty_ldisc_put+0xbc/0xf4
LR [c000000000409410] .tty_ldisc_put+0xa4/0xf4
Call Trace:
[c0000000374f3a70] [c000000000409410] .tty_ldisc_put+0xa4/0xf4 (unreliable)
[c0000000374f3b10] [c000000000409808] .tty_ldisc_reinit+0x38/0x80
[c0000000374f3ba0] [c00000000040a218] .tty_ldisc_hangup+0x190/0x260
[c0000000374f3c40] [c0000000004000d0] .do_tty_hangup+0x188/0x4c0
[c0000000374f3d20] [c000000000400480] .tty_vhangup_self+0x34/0x54
[c0000000374f3db0] [c0000000001917c8] .sys_vhangup+0x38/0x58
[c0000000374f3e30] [c000000000008534] syscall_exit+0x0/0x40
Instruction dump:
912b0088 4bcd2201 60000000 e87e8008 7f44d378 481c0735 60000000 801b0008
7c09fe70 7d200278 7c004850 54000ffe <0b000000> 7f63db78 4bd7cf0d 60000000

Not sure if this is a new issue. I haven't really paid attention
to messages that are displayed during shutdown.

Line 210 corresponds to the following code.

static void tty_ldisc_put(struct tty_ldisc *ld)
{
......
	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
	WARN_ON(ld->refcount); <<===
.......

Thanks
-Sachin



-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

