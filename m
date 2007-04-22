Return-Path: <linux-kernel-owner+w=401wt.eu-S1161042AbXDVXYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161042AbXDVXYM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 19:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161098AbXDVXYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 19:24:12 -0400
Received: from [70.254.190.220] ([70.254.190.220]:57711 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161042AbXDVXYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 19:24:11 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Apr 2007 19:24:11 EDT
Date: Sun, 22 Apr 2007 23:13:54 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: linux-kernel@vger.kernel.org
Subject: BUG: Null pointer dereference (2.6.21-rc7)
Message-ID: <Pine.LNX.4.64.0704222310030.25153@server.thyself>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On running "pktsetup 0 /dev/hdd", I get the following:

[ 3970.461403] =============================================
[ 3970.482051] [ INFO: possible recursive locking detected ]
[ 3970.498210] 2.6.21-rc7 #2
[ 3970.506062] ---------------------------------------------
[ 3970.522228] vol_id/8686 is trying to acquire lock:
[ 3970.536576]  (&bdev->bd_mutex){--..}, at: [<c01826b2>] do_open+0x65/0x285
[ 3970.557104]
[ 3970.557109] but task is already holding lock:
[ 3970.574627]  (&bdev->bd_mutex){--..}, at: [<c01826b2>] do_open+0x65/0x285
[ 3970.595160]
[ 3970.595161] other info that might help us debug this:
[ 3970.614757] 2 locks held by vol_id/8686:
[ 3970.626505]  #0:  (&bdev->bd_mutex){--..}, at: [<c01826b2>] do_open+0x65/0x285
[ 3970.648388]  #1:  (&ctl_mutex#2){--..}, at: [<c03d6b54>] mutex_lock+0x1c/0x1f
[ 3970.670065]
[ 3970.670070] stack backtrace:
[ 3970.683165]  [<c0104df5>] show_trace_log_lvl+0x1a/0x2f
[ 3970.698604]  [<c010544b>] show_trace+0x12/0x14
[ 3970.711964]  [<c01054fd>] dump_stack+0x16/0x18
[ 3970.725322]  [<c013150a>] __lock_acquire+0x12e/0xb93
[ 3970.740243]  [<c0131fd7>] lock_acquire+0x68/0x82
[ 3970.754122]  [<c03d6c46>] mutex_lock_nested+0xef/0x275
[ 3970.769560]  [<c01826b2>] do_open+0x65/0x285
[ 3970.782397]  [<c0182945>] __blkdev_get+0x73/0x7e
[ 3970.796279]  [<c0182965>] blkdev_get+0x15/0x17
[ 3970.809638]  [<c027dbde>] pkt_open+0x95/0xc4e
[ 3970.822737]  [<c01826e1>] do_open+0x94/0x285
[ 3970.835578]  [<c0182a93>] blkdev_open+0x28/0x51
[ 3970.849196]  [<c0161918>] __dentry_open+0xff/0x1b1
[ 3970.863594]  [<c0161a4b>] nameidata_to_filp+0x27/0x37
[ 3970.878770]  [<c0161a8e>] do_filp_open+0x33/0x3b
[ 3970.892654]  [<c0161ad9>] do_sys_open+0x43/0xc2
[ 3970.906274]  [<c0161b90>] sys_open+0x1c/0x1e
[ 3970.919113]  [<c0103e24>] sysenter_past_esp+0x5d/0x99
[ 3970.934292]  =======================
[ 3971.630710] pktcdvd: pkt_get_last_written failed
[ 3971.645027] BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000e
[ 3971.670652]  printing eip:
[ 3971.678786] c0161aef
[ 3971.685361] *pde = 00000000
[ 3971.693761] Oops: 0000 [#1]
[ 3971.702120] PREEMPT
[ 3971.708722] Modules linked in: udf snd_intel8x0 snd_ac97_codec ac97_bus i810_audio ac97_codec 8139cp 8139too iTCO_wdt
[ 3971.741005] CPU:    0
[ 3971.741006] EIP:    0060:[<c0161aef>]    Not tainted VLI
[ 3971.741008] EFLAGS: 00010203   (2.6.21-rc7 #2)
[ 3971.777034] EIP is at do_sys_open+0x59/0xc2
[ 3971.789555] eax: 00000002   ebx: 00008000   ecx: c0182a6b   edx: dc8df650
[ 3971.809878] esi: ffffff9c   edi: 00000002   ebp: de336fa4   esp: de336f88
[ 3971.830200] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[ 3971.847674] Process vol_id (pid: 8686, ti=de336000 task=d0b90de0 task.ti=de336000)
[ 3971.869812] Stack: 00000000 00000000 cef97000 00000003 bf9d7f65 00008000 b7facff4 de336fb0
[ 3971.895286]        c0161b90 00000000 de336000 c0103e24 bf9d7f65 00008000 00000000 00008000
[ 3971.920755]        b7facff4 bf9d5e08 00000005 0000007b 0000007b 00000000 00000005 ffffe410
[ 3971.946228] Call Trace:
[ 3971.954126]  [<c0104df5>] show_trace_log_lvl+0x1a/0x2f
[ 3971.969563]  [<c0104ea7>] show_stack_log_lvl+0x9d/0xa5
[ 3971.985004]  [<c01050aa>] show_registers+0x1fb/0x33c
[ 3971.999924]  [<c01052f2>] die+0x107/0x21f
[ 3972.011984]  [<c03d9d20>] do_page_fault+0x448/0x520
[ 3972.026644]  [<c03d8594>] error_code+0x74/0x7c
[ 3972.040003]  [<c0161b90>] sys_open+0x1c/0x1e
[ 3972.052841]  [<c0103e24>] sysenter_past_esp+0x5d/0x99
[ 3972.068022]  =======================
[ 3972.078728] Code: f0 78 7e 8b 45 08 89 d9 8b 55 ec 89 04 24 89 f0 e8 82 ff ff ff 3d 00 f0 ff ff 89 c7 76 0d 8b 45 f0 e8 dc fb ff ff 89 7d f0 eb 56 <8b> 40 0c bb 20 00 00 40 8b 70 30 0f b7 56 66 81 e2 00 f0 00 00
[ 3972.138557] EIP: [<c0161aef>] do_sys_open+0x59/0xc2 SS:ESP 0068:de336f88

Is this a bug?

If any more information is necessary, I'd be happy to provide it.
William Heimbigner
icxcnika@mar.tar.cc
