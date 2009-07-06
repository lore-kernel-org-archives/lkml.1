Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbZGFQVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbZGFQVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbZGFQVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:21:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:45156 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750764AbZGFQVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:21:14 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/xVZVj1kbx1YrpXuvs3ha2JuCkHz56fNEyzbAZl2
	12+rMlPAKs8vpS
Message-ID: <4A52247B.4040204@fisher-privat.net>
Date: Mon, 06 Jul 2009 18:21:15 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090616)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: PM: resume devices took 9.176 seconds
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo all,
it testing a lot git tree especially suspend and resume. With my new 
Intel DG45ID board i get always this trace:

============================================
[  176.763922] PM: resume devices took 9.176 seconds
[  176.763924] ------------[ cut here ]------------
[  176.763930] WARNING: at kernel/power/suspend_test.c:52 
suspend_test_finish+0x7c/0x80()
[  176.763932] Hardware name:
[  176.763933] Component: resume devices
[  176.763934] Modules linked in: binfmt_misc kvm_intel kvm 
snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec 
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi 
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd 
psmouse iTCO_wdt iTCO_vendor_support serio_raw e1000e soundcore 
snd_page_alloc
[  176.763952] Pid: 4180, comm: bash Not tainted 
2.6.31-rc1-25446-g1ae8c0a-dirty #3
[  176.763953] Call Trace:
[  176.763958]  [<ffffffff8104a8e8>] warn_slowpath_common+0x78/0xb0
[  176.763961]  [<ffffffff8104a97c>] warn_slowpath_fmt+0x3c/0x40
[  176.763964]  [<ffffffff8107ce7c>] suspend_test_finish+0x7c/0x80
[  176.763966]  [<ffffffff8107cac1>] suspend_devices_and_enter+0xb1/0x210
[  176.763969]  [<ffffffff8107cd4a>] enter_state+0x12a/0x150
[  176.763971]  [<ffffffff8107c2a1>] state_store+0x91/0x100
[  176.763974]  [<ffffffff8121b177>] kobj_attr_store+0x17/0x20
[  176.763978]  [<ffffffff8115a250>] sysfs_write_file+0xe0/0x160
[  176.763981]  [<ffffffff810f8468>] vfs_write+0xb8/0x1a0
[  176.763984]  [<ffffffff810f63f8>] ? filp_close+0x58/0x90
[  176.763987]  [<ffffffff810f8f1c>] sys_write+0x4c/0x80
[  176.763991]  [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
[  176.763993] ---[ end trace 50ea4941e30c27fd ]---
[  176.766367] PM: Finishing wakeup.
[  176.766369] Restarting tasks ... done.
============================================================

this is related with the commit:
    commit 77437fd4e61f87cc94d9314baa5cbf50e3ccdf54
Author: David Brownell <dbrownell@users.sourceforge.net>
Date:   Wed Jul 23 21:28:33 2008 -0700

probobly it's depend  on this message:
[  173.076075] ata1: link is slow to respond, please be patient (ready=0)

so it's looks normal for this board and harddrive. I think it should be 
some way to change default TEST_SUSPEND_SECONDS by .config or 
kernel-parameter. I changed default settings to 10 in 
kernel/power/suspend_test.c but this is not the way it should be done.


Thenks
	Alexey
