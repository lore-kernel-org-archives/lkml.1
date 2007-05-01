Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbXEAPBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbXEAPBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbXEAPBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:01:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41608 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbXEAPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:01:15 -0400
Subject: Re: DST/BT878 module customization (.. was: Critical points about
	...)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org,
       Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 01 May 2007 11:55:33 -0300
Message-Id: <1178031333.3958.63.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

Em Seg, 2007-04-30 às 23:17 +0200, Markus Rechberger escreveu:
> Hi,
> 
> Trent Piepho wrote another patch for it, it just completes Uwe's patch
> in the end.
> 
> http://linuxtv.org/hg/~tap/dst-new?cmd=changeset;node=bbdd2b53cd5c;style=gitweb

The above patch plus the other on
http://linuxtv.org/hg/~tap/dst-new?cmd=changeset;node=32fb55ac9501;style=gitweb

Implements properly the Uwe's ide. 

However, I did a test here applying both patches, and de-selecting dst
drivers.

With this configuration, dvb-bt8xx hangs during initialization,
generating an OOPS, if you have a board with DST (modprobe dvb-bt8xx
never returns).

$ ps ax|grep modprobe
 2769 pts/0    S      0:00 modprobe dvb_bt8xx
 2779 pts/0    S+     0:00 grep --color modprobe

$ dmesg
DVB: registering new adapter (bttv0).
DVB: Unable to find symbol dst_attach()
Unable to handle kernel NULL pointer dereference at 00000000000002f0 RIP:
<ffffffff8825f11b>{:dvb_bt8xx:dvb_bt8xx_probe+3195}
PGD 7cfba067 PUD 7cfc5067 PMD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in: dvb_bt8xx dvb_core cx8800 cx88xx bt878 usbhid dvb_pll tuner bttv video_buf firmware_class ir_common i2c_algo_bit btcx_risc tveeprom i2c_core pcspkr sn9c102 compat_ioctl32 videodev v4l1_compat v4l2_common forcedeth kqemu joydev analog gameport ohci1394 ieee1394 ehci_hcd ohci_hcd usbcore reiserfs sd_mod sata_nv libata scsi_mod
Pid: 1286, comm: modprobe Tainted: P      2.6.17.4 #1
RIP: 0010:[<ffffffff8825f11b>] <ffffffff8825f11b>{:dvb_bt8xx:dvb_bt8xx_probe+3195}
RSP: 0018:ffff81007c239e38  EFLAGS: 00010296
RAX: 000000000000002b RBX: ffff81007c05a800 RCX: 0000000000000003
RDX: 0000000000000000 RSI: 0000000000000292 RDI: ffffffff803905bc
RBP: 0000000000000000 R08: 0000000000004c72 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81007c190000
R13: ffff81007c05a8d0 R14: ffff81007c05ac98 R15: ffff81007c05abc8
FS:  00002b8b39ddf6f0(0000) GS:ffffffff80476000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000002f0 CR3: 000000007cfc2000 CR4: 00000000000006e0
Process modprobe (pid: 1286, threadinfo ffff81007c238000, task ffff81007dfd4960)
Stack: ffff81007c05acb0 ffff81007c05a870 000000717c1e31c0 ffff81007c190198
       ffff81007c190000 ffffffff88261940 ffffffff88261940 0000000000000000
       0000000000518130 ffffffff8026ce95
Call Trace: <ffffffff8026ce95>{driver_probe_device+101}
       <ffffffff8026d00a>{__driver_attach+122} <ffffffff8026cf90>{__driver_attach+0}
       <ffffffff8026c6f9>{bus_for_each_dev+73} <ffffffff8026c2e8>{bus_add_driver+136}
       <ffffffff80152977>{sys_init_module+199} <ffffffff80109d2a>{system_call+126}

Code: f6 04 25 f0 02 00 00 20 0f 84 01 ff ff ff e9 7d fd ff ff 66
RIP <ffffffff8825f11b>{:dvb_bt8xx:dvb_bt8xx_probe+3195} RSP <ffff81007c239e38>
CR2: 00000000000002f0

So, those patches aren't enough to fix the issue.

Cheers,
Mauro

