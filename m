Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbYLHTC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbYLHTC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 14:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYLHTCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 14:02:20 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:47275 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbYLHTCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 14:02:19 -0500
Date: Mon, 8 Dec 2008 20:02:35 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Bug in i915 GEM module
Message-ID: <20081208190235.GA4498@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 81.31.45.161
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Mon, 08 Dec 2008 20:02:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to use UXA acceleration method and when browsing with firefox on
web galeries, I got the following error:
[24166.963712] [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
[24166.963724] [drm:i915_gem_object_pin] *ERROR* Failure to bind: -12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request empty 1 flushing empty 1
[24166.971734] ------------[ cut here ]------------
[24166.971739] kernel BUG at drivers/gpu/drm/i915/i915_gem.c:2211!
[24166.971744] invalid opcode: 0000 [#1] SMP 
[24166.971750] last sysfs file: /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/energy_full
[24166.971757] Dumping ftrace buffer:
[24166.971762]    (ftrace buffer empty)
[24166.971766] CPU 0 
[24166.971770] Modules linked in: usb_storage arc4 ecb iwlagn iwlcore mac80211 cfg80211 i915 drm rfcomm bridge stp llc bnep sco l2cap btusb bluetooth uinput fuse thinkpad_acpi rfkill snd_hda_intel ehci_hcd wmi uhci_hcd e1000e intel_agp [last unloaded: ecb]
[24166.971814] Pid: 7478, comm: Xorg Not tainted 2.6.28-rc7 #33
[24166.971819] RIP: 0010:[<ffffffffa00dfdeb>]  [<ffffffffa00dfdeb>] i915_gem_object_unpin+0x8b/0xa0 [i915]
[24166.971841] RSP: 0018:ffff8800776abd60  EFLAGS: 00010296
[24166.971846] RAX: 00000000ffffffff RBX: 0000000000000001 RCX: 0000000000000001
[24166.971850] RDX: 0000000000000909 RSI: ffff88007cb1b1e0 RDI: ffff880026a1cec0
[24166.971855] RBP: 00000000fffffff4 R08: ffff880078439800 R09: ffff880078706000
[24166.971859] R10: ffff8800776abc48 R11: 0000000080794140 R12: ffff88000d90fd00
[24166.971864] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000008
[24166.971869] FS:  00007ff49c45e6f0(0000) GS:ffffffff806ee240(0000) knlGS:0000000000000000
[24166.971874] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[24166.971878] CR2: 00007f6f9ca00550 CR3: 000000007756a000 CR4: 00000000000006e0
[24166.971883] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[24166.971888] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[24166.971893] Process Xorg (pid: 7478, threadinfo ffff8800776aa000, task ffff880077635900)
[24166.971897] Stack:
[24166.971900]  ffffffffa00e2d13 00000000007e6c40 ffff8800776abce8 ffff8800776abd80
[24166.971908]  0000000000000000 ffff880000000000 ffff8800776a0000 ffff88000ad46d40
[24166.971917]  ffff880078439800 ffff88007844f018 ffff880078439828 ffff8800268c9b40
[24166.971926] Call Trace:
[24166.971929]  [<ffffffffa00e2d13>] ? i915_gem_execbuffer+0x513/0xcc0 [i915]
[24166.971945]  [<ffffffff802b04c3>] ? do_sync_read+0xe3/0x130
[24166.971957]  [<ffffffffa00c4ede>] ? drm_gem_object_lookup+0x3e/0x60 [drm]
[24166.971982]  [<ffffffffa00e2800>] ? i915_gem_execbuffer+0x0/0xcc0 [i915]
[24166.971996]  [<ffffffffa00c3762>] ? drm_ioctl+0x112/0x340 [drm]
[24166.972014]  [<ffffffff802bdfa5>] ? vfs_ioctl+0x85/0xb0
[24166.972022]  [<ffffffff802be04c>] ? do_vfs_ioctl+0x7c/0x470
[24166.972029]  [<ffffffff80242d83>] ? do_setitimer+0xe3/0x370
[24166.972036]  [<ffffffff802be489>] ? sys_ioctl+0x49/0x80
[24166.972042]  [<ffffffff8020c4cb>] ? system_call_fastpath+0x16/0x1b
[24166.972050] Code: 0e 00 00 49 89 89 d8 0e 00 00 48 89 46 10 48 89 56 18 48 89 0a f0 41 ff 88 78 04 00 00 48 8b 47 18 f0 41 29 80 7c 04 00 00 f3 c3 <0f> 0b eb fe 90 0f 0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 
[24166.972116] RIP  [<ffffffffa00dfdeb>] i915_gem_object_unpin+0x8b/0xa0 [i915]
[24166.972131]  RSP <ffff8800776abd60>
[24166.972142] ---[ end trace 498b71a4b7694d0b ]---


-- 
Luká¹ Hejtmánek
