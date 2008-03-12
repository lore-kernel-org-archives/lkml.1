Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYCLVCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYCLVCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYCLVCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:02:43 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:57977 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbYCLVCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:02:41 -0400
Date: Wed, 12 Mar 2008 22:02:28 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Samuel Tardieu <sam@rfc1149.net>
cc: LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
Subject: Re: 2.6.25-rc hangs
In-Reply-To: <2008-03-12-19-06-06+trackit+sam@rfc1149.net>
Message-ID: <alpine.DEB.1.00.0803122137210.5088@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803080251110.4325@sheep.housecafe.de> <alpine.DEB.1.00.0803090658040.5349@sheep.housecafe.de>
 <47D413FA.50602@sandeen.net> <alpine.DEB.1.00.0803091858480.5349@sheep.housecafe.de> <47D42AD6.10500@sandeen.net> <alpine.DEB.1.00.0803091934090.5349@sheep.housecafe.de> <2008-03-12-19-06-06+trackit+sam@rfc1149.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Samuel Tardieu wrote:
> Can't you skip it with "git bisect skip" in this case? (I've never
> tried "skip" but from "git bisect" documentation it does what you
> want, and "git bisect" will select a nearby revision)

Yes, I shall try so. In the meantime I tried -rc5 but even more headaches 
with this one:

[ 1219.355352] ------------[ cut here ]------------
[ 1219.355359] WARNING: at drivers/usb/host/ehci-hcd.c:287 ehci_iaa_watchdog+0x7a/0x80()
[ 1219.355362] Modules linked in: act_police sch_ingress cls_u32 sch_sfq sch_cbq xt_tcpudp ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_nat_ftp nf_nat nf_conntrack_ftp xt_conntrack nf_conntrack iptable_filter ip_tables ipt_ULOG x_tables nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc tun fuse sg sr_mod twofish_i586 twofish_common eeprom w83l785ts asb100 hwmon_vid hwmon usb_storage ecb zd1211rw firmware_class snd_intel8x0 snd_ac97_codec mac80211 ac97_bus snd_pcm snd_timer snd soundcore pl2303 usbserial snd_page_alloc cfg80211 i2c_nforce2 i2c_core
[ 1219.355411] Pid: 450, comm: md0_raid1 Not tainted 2.6.25-rc5 #1
[ 1219.355415]  [<c0119a0f>] warn_on_slowpath+0x5f/0x90
[ 1219.355429]  [<c0138d57>] __lock_acquire+0x537/0x10b0
[ 1219.355441]  [<c0117062>] task_tick_fair+0x32/0x60
[ 1219.355446]  [<c01159cf>] scheduler_tick+0xcf/0x200
[ 1219.355453]  [<c011b47d>] profile_tick+0x3d/0x80
[ 1219.355459]  [<c0102ed7>] restore_nocheck+0x12/0x15
[ 1219.355467]  [<c043c9ff>] _spin_lock_irqsave+0x3f/0x50
[ 1219.355475]  [<c03620ba>] ehci_iaa_watchdog+0x7a/0x80
[ 1219.355480]  [<c0122748>] run_timer_softirq+0x128/0x190
[ 1219.355486]  [<c0105688>] do_softirq+0x98/0xd0
[ 1219.355492]  [<c0362040>] ehci_iaa_watchdog+0x0/0x80
[ 1219.355498]  [<c011ecb2>] __do_softirq+0x52/0xa0
[ 1219.355503]  [<c0105688>] do_softirq+0x98/0xd0
[ 1219.355507]  [<c0144960>] handle_level_irq+0x0/0xe0
[ 1219.355515]  [<c011ec3d>] irq_exit+0x4d/0x70
[ 1219.355518]  [<c0105750>] do_IRQ+0x90/0xf0
[ 1219.355522]  [<c013837c>] trace_hardirqs_on+0x9c/0x110
[ 1219.355529]  [<c0103886>] common_interrupt+0x2e/0x34
[ 1219.355536]  [<c043c982>] _spin_unlock_irq+0x22/0x30
[ 1219.355540]  [<c02ba101>] __make_request+0xc1/0x320
[ 1219.355550]  [<c02b91e7>] generic_make_request+0x177/0x230
[ 1219.355556]  [<c043caf5>] _spin_unlock_irqrestore+0x45/0x60
[ 1219.355561]  [<c013837c>] trace_hardirqs_on+0x9c/0x110
[ 1219.355567]  [<c03705d9>] raid1d+0x419/0xcc0
[ 1219.355574]  [<c0138d57>] __lock_acquire+0x537/0x10b0
[ 1219.355581]  [<c01159cf>] scheduler_tick+0xcf/0x200
[ 1219.355590]  [<c0102ed7>] restore_nocheck+0x12/0x15
[ 1219.355593]  [<c037b6e0>] md_thread+0x0/0xe0
[ 1219.355599]  [<c013837c>] trace_hardirqs_on+0x9c/0x110
[ 1219.355608]  [<c043caf5>] _spin_unlock_irqrestore+0x45/0x60
[ 1219.355612]  [<c037b6e0>] md_thread+0x0/0xe0
[ 1219.355616]  [<c013837c>] trace_hardirqs_on+0x9c/0x110
[ 1219.355622]  [<c037b6e0>] md_thread+0x0/0xe0
[ 1219.355626]  [<c037b702>] md_thread+0x22/0xe0
[ 1219.355631]  [<c012c6d0>] autoremove_wake_function+0x0/0x40
[ 1219.355639]  [<c037b6e0>] md_thread+0x0/0xe0
[ 1219.355643]  [<c012c402>] kthread+0x42/0x70
[ 1219.355647]  [<c012c3c0>] kthread+0x0/0x70
[ 1219.355651]  [<c0103a1f>] kernel_thread_helper+0x7/0x18
[ 1219.355657]  =======================
[ 1219.355660] ---[ end trace d0567d7a35270324 ]---


@dm-devel, can you get something useful out of these traces?

Thank you,
Christian.
-- 
BOFH excuse #152:

My pony-tail hit the on/off switch on the power strip.
