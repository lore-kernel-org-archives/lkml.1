Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZJCQOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZJCQOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 12:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbZJCQN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 12:13:59 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:39046 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbZJCQN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 12:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=R8L14WT2L4nbl4Wgivruj2NaKIRfafUtVTY9fLZHiNjHfFbAmm+3mckL09zF5n4vZb
         R/YIqFV0GtErVf5qRnJ58v8ePXbkbvwGuJbMNsVyRJPHoKB1fHcAjgDlgw+b+FmlqMQ4
         f3T7tXAFcylT1lnMRohdmgJkf2Ww4wMeFCvrU=
MIME-Version: 1.0
Date: Sat, 3 Oct 2009 12:13:20 -0400
X-Google-Sender-Auth: ee412112ac702b0b
Message-ID: <cb0375e10910030913h7fc5cf85l97e3e90bd61c3f89@mail.gmail.com>
Subject: 2.6.32-rc1: oops in vfs_getattr (sysfs, maybe?)
From: Andrew Lutomirski <luto@mit.edu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running find on /sys on 2.6.32-rc1, I got the oops below.  I
haven't been able to reproduce it.

Thanks,
Andy

[  401.431985] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000010
[  401.432256] IP: [<ffffffff8112eafb>] generic_fillattr+0x23/0xcb
[  401.432256] PGD 136799067 PUD 13374d067 PMD 0
[  401.432256] Oops: 0000 [#1] SMP
[  401.432256] last sysfs file:
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/power_now
[  401.432256] CPU 1
[  401.432256] Modules linked in: cpufreq_ondemand tp_smapi
thinkpad_ec dm_multipath uinput thinkpad_acpi hwmon arc4
snd_hda_codec_conexant ecb snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm snd_timer snd soundcore iwlagn i2c_i801 i2400m_usb
snd_page_alloc iwlcore i2400m mac80211 iTCO_wdt pcspkr
iTCO_vendor_support cfg80211 xts gf128mul aes_x86_64 aes_generic
dm_crypt i915 drm_kms_helper drm i2c_algo_bit i2c_core video output
[last unloaded: scsi_wait_scan]
[  401.432256] Pid: 2074, comm: find Not tainted 2.6.32-rc2 #7 7465CTO
[  401.432256] RIP: 0010:[<ffffffff8112eafb>]  [<ffffffff8112eafb>]
generic_fillattr+0x23/0xcb
[  401.432256] RSP: 0018:ffff880136b7fe38  EFLAGS: 00010246
[  401.432256] RAX: 0000000000000000 RBX: ffff880137408b40 RCX: 0000000000000000
[  401.432256] RDX: ffff880136b7fef8 RSI: ffff880136b7fef8 RDI: ffff88013754f280
[  401.432256] RBP: ffff880136b7fe48 R08: ffff880136b7fc78 R09: 0000000000000000
[  401.432256] R10: 0000000000000035 R11: 0000000000000010 R12: ffff880136527d00
[  401.432256] R13: ffff88013754f280 R14: 0000000000000000 R15: 0000000001dfc260
[  401.432256] FS:  00007f6b0e5e0790(0000) GS:ffff880028300000(0000)
knlGS:0000000000000000
[  401.432256] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  401.432256] CR2: 0000000000000010 CR3: 000000013673e000 CR4: 00000000000006e0
[  401.446016] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  401.446016] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  401.446016] Process find (pid: 2074, threadinfo ffff880136b7e000,
task ffff880135f48000)
[  401.446016] Stack:
[  401.446016]  ffff880136527d00 000000003e5990f6 ffff880136b7fe98
ffffffff8112f160
[  401.446016] <0> ffff880136b7fe88 ffff880100000000 ffff880135504a80
000000003e5990f6
[  401.446016] <0> ffff88013756b970 ffff880136b7feb8 ffff880136b7fef8
0000000001dfabb0
[  401.446016] Call Trace:
[  401.446016]  [<ffffffff8112f160>] vfs_getattr+0x67/0x89
[  401.446016]  [<ffffffff8112f1dc>] vfs_fstatat+0x5a/0x85
[  401.446016]  [<ffffffff8112f235>] sys_newfstatat+0x2e/0x60
[  401.446016]  [<ffffffff814f0d6d>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[  401.446016]  [<ffffffff8100bfab>] system_call_fastpath+0x16/0x1b
[  401.446016] Code: 41 5e 41 5f c9 c3 90 90 55 48 89 e5 48 83 ec 10
0f 1f 44 00 00 65 48 8b 04 25 28 00 00 00 48 89 45 f8 31 c0 48 8b 87
00 01 00 00 <8b> 40 10 89 46 08 48 8b 47 40 48 89 06 66 8b 87 ae 00 00
00 66
[  401.446016] RIP  [<ffffffff8112eafb>] generic_fillattr+0x23/0xcb
[  401.446016]  RSP <ffff880136b7fe38>
[  401.446016] CR2: 0000000000000010
[  401.446350] ---[ end trace c22a0e5c9eb12b8b ]---
