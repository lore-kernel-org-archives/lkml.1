Return-Path: <linux-kernel-owner+w=401wt.eu-S1762853AbXIXTHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762853AbXIXTHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761106AbXIXTHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:07:23 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:23337 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759302AbXIXTHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nCm4S72/BdAEuQzhrSkeJj/2QpcfYJAxYkXT4v54yhvxH1rs98P7HouXdoo1HudoTx3k5FLrHkifC3wbhcTsRqoh8RI//OX2Ivnr/ndryQCe9IA284W1PpTwEAayX3H3SOi1hud6UWBUb/YCEJcH0Bmk19xM+Hj5haTDIeydXdo=
Message-ID: <64bb37e0709241207q1c188b35ua485a06776ed4bf2@mail.gmail.com>
Date: Mon, 24 Sep 2007 21:07:19 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc7-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/24/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/

With the five hotfixes applied it works for me.

But it fails to power down my system when shutting down.

It prints twice 'System halted' and blinks the keyboard leds, but does
not switch off. On all other kernel version I only see one keyboard
blink before the power goes out.

I compared its dmesg to vanilla-rc7 and -rc4-mm1, but expect that rc-4
assigns different IRQs I can't see any differences except the normal
variation in BogoMips etc.

As the system still responded to SysRq I got the following informations:
[  415.770000] SysRq : Show Regs
[  415.770000] CPU 3:
[  415.780000] Modules linked in: radeon drm nfsd exportfs ipv6 tuner
tea5767 tda8290 tuner_simple mt20xx tvaudio msp3400 bttv video_buf
ir_common compat_ioctl32 btcx_risc tveeprom videodev v4l2_common
v4l1_compat pata_amd usbhid hid sg
[  415.780000] Pid: 0, comm: swapper Not tainted 2.6.23-rc7-mm1 #1
[  415.780000] RIP: 0010:[<ffffffff8020ac79>]  [<ffffffff8020ac79>]
default_idle+0x29/0x40
[  415.780000] RSP: 0018:ffff81010038bf30  EFLAGS: 00000246
[  415.780000] RAX: 0000000000000400 RBX: ffffffff80810040 RCX: 0000000000000000
[  415.780000] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000005
[  415.780000] RBP: 0000000000030400 R08: 0000000000000000 R09: ffff81010038be68
[  415.950000] R10: 000000000100002c R11: ffffffff80219be0 R12: 0000000000000000
[  415.950000] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  415.950000] FS:  00007f35c69726f0(0000) GS:ffff810100319700(0000)
knlGS:0000000000000000
[  415.950000] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  415.950000] CR2: 00007fe432928c40 CR3: 0000000000201000 CR4: 00000000000006e0
[  416.070000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  416.070000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  416.070000]
[  416.070000] Call Trace:
[  416.070000]  [<ffffffff8020acea>] cpu_idle+0x5a/0x90
[  416.070000]

No blocked tasks were shown with SysRq+W.
Last lines before I used SysRq+B (That worked, a normal reboot started):

[  450.780000] SysRq : Emergency Remount R/O
[  450.790000] Emergency Remount complete
[  453.650000] SysRq : Emergency Sync
[  453.660000] Emergency Sync complete
[  455.910000] SysRq : Power Off
[  455.920000] md: stopping all md devices.
[  455.930000] md: md1 still in use.
[  456.940000] sd 8:0:1:0: [sdd] Synchronizing SCSI cache
[  456.960000] sd 8:0:1:0: [sdd] Stopping disk
[  457.480000] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
[  457.490000] sd 2:0:0:0: [sdc] Stopping disk
[  457.500000] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[  457.520000] sd 1:0:0:0: [sdb] Stopping disk
[  457.530000] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  457.550000] sd 0:0:0:0: [sda] Stopping disk
[  457.560000] Power down.
[  479.090000] SysRq : Power Off
[  479.100000] md: stopping all md devices.
[  479.110000] md: md1 still in use.
[  480.120000] sd 8:0:1:0: [sdd] Synchronizing SCSI cache
[  480.140000] sd 8:0:1:0: [sdd] Stopping disk
[  480.660000] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
[  480.670000] sd 2:0:0:0: [sdc] Stopping disk
[  480.680000] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[  480.700000] sd 1:0:0:0: [sdb] Stopping disk
[  480.710000] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  480.730000] sd 0:0:0:0: [sda] Stopping disk
[  480.740000] Power down.
[  489.030000] SysRq : Resetting

Torsten
