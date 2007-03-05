Return-Path: <linux-kernel-owner+w=401wt.eu-S1751220AbXCESJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbXCESJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbXCESJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:09:33 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:3936 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXCESJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:09:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=dQvs9OazPTGLOjeeyHvxeB1QZcnqIegBz1db22Hr2FRGSSUhqJ6zEt7Klf0cpBcMO6VZW6mj6/vbV5vk4BJ8MTHwR5NvtohHI76oUIfnpl0xmkTdEcPbdgTDCNxKosRNOotSmg3lttFTCBdMSOE8Ue2ltKIPMSDkmkZVZUEEfL8=
Message-ID: <45EC5C76.3040703@googlemail.com>
Date: Mon, 05 Mar 2007 19:07:50 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, perex@suse.cz, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: 2.6.21-rc2-git3 oops snd_intel8x0_interrupt+0x104/0x1dc [snd_intel8x0]
 (crashdump kernel)
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I hit this bug on crashdump kernel

[ 8450.127374] divide error: 0000 [#1]
[ 8450.130876] PREEMPT 
[ 8450.133098] Modules linked in: snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd evdev intel_agp soundcore agpgart snd_page_alloc i2c_i801 skge rtc_cmos rtc_core rtc_lib ide_cd cdrom rtc unix
[ 8450.159726] CPU:    0
[ 8450.159727] EIP:    0060:[<ca903276>]    Not tainted VLI
[ 8450.159728] EFLAGS: 00010046   (2.6.21-rc2-git3 #12)
[ 8450.172304] EIP is at snd_intel8x0_interrupt+0x104/0x1dc [snd_intel8x0]
[ 8450.178921] eax: 00000000   ebx: c22f3590   ecx: 0000000e   edx: 00000000
[ 8450.185707] esi: c22f34f8   edi: 00700140   ebp: c2b47ce8   esp: c2b47cc0
[ 8450.192501] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[ 8450.198338] Process modprobe (pid: 1336, ti=c2b47000 task=c1e12070 task.ti=c2b47000)
[ 8450.205900] Stack: 00000001 c3197ab4 0000000e c165e6b6 0000000f 00000010 c22f37c0 00000202 
[ 8450.214466]        c3197ab8 00000020 c2b47d08 c1643230 ca903172 0000000a 012f37f8 c22f34f8 
[ 8450.223032]        070000e0 00000001 c2b47dd4 ca902144 c26b44ac c22f34f8 c1e125f8 c1e12070 
[ 8450.231590] Call Trace:
[ 8450.234252]  [<c1604556>] show_trace_log_lvl+0x1a/0x2f
[ 8450.239430]  [<c1604608>] show_stack_log_lvl+0x9d/0xa5
[ 8450.244600]  [<c16047fd>] show_registers+0x1ed/0x32c
[ 8450.249597]  [<c1604a43>] die+0x107/0x21e
[ 8450.253640]  [<c1604bd3>] do_trap+0x79/0x91
[ 8450.257860]  [<c160523a>] do_divide_error+0x94/0x9e
[ 8450.262769]  [<c17fb54c>] error_code+0x74/0x7c
[ 8450.267247]  [<c1643230>] request_irq+0xac/0xf4
[ 8450.271811]  [<ca902144>] snd_intel8x0_probe+0x482/0xffb [snd_intel8x0]
[ 8450.278459]  [<c16e78c5>] pci_device_probe+0x39/0x5b
[ 8450.283455]  [<c173e633>] really_probe+0xbd/0x145
[ 8450.288193]  [<c173e750>] driver_probe_device+0x95/0xa1
[ 8450.293448]  [<c173e865>] __driver_attach+0x6a/0xa1
[ 8450.298358]  [<c173dc61>] bus_for_each_dev+0x36/0x5b
[ 8450.303354]  [<c173e4a7>] driver_attach+0x19/0x1b
[ 8450.308091]  [<c173df0e>] bus_add_driver+0x6a/0x170
[ 8450.313001]  [<c173ea70>] driver_register+0x79/0x7e
[ 8450.317910]  [<c16e7a43>] __pci_register_driver+0x7c/0xa9
[ 8450.323338]  [<ca909017>] alsa_card_intel8x0_init+0x17/0x19 [snd_intel8x0]
[ 8450.330246]  [<c16366ad>] sys_init_module+0x11b0/0x12f0
[ 8450.335502]  [<c1603e72>] sysenter_past_esp+0x5f/0x99
[ 8450.340584]  =======================
[ 8450.344172] Code: 29 c1 89 c8 83 c0 20 83 f9 ff 0f 4f c1 89 45 e0 89 53 38 8b 45 e0 0f af 43 20 03 43 24 89 43 24 f6 86 8c 02 00 00 40 75 08 31 d2 <f7> 73 18 89 53 24 8b 45 e0 03 43 30 83 e0 1f 89 43 30 8b 55 ec 
[ 8450.364659] EIP: [<ca903276>] snd_intel8x0_interrupt+0x104/0x1dc [snd_intel8x0] SS:ESP 0068:c2b47cc0
[ 8450.373849] note: modprobe[1336] exited with preempt_count 1
[ 8450.379518] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
[ 8450.387175] in_atomic():1, irqs_disabled():1
[ 8450.391455] 1 lock held by modprobe/1336:
[ 8450.395474]  #0:  (&chip->reg_lock){....}, at: [<ca9031fe>] snd_intel8x0_interrupt+0x8c/0x1dc [snd_intel8x0]
[ 8450.405416] irq event stamp: 15590
[ 8450.408828] hardirqs last  enabled at (15589): [<c165e6a2>] kmem_cache_alloc+0x89/0xa9
[ 8450.416798] hardirqs last disabled at (15590): [<c1643227>] request_irq+0xa3/0xf4
[ 8450.424329] softirqs last  enabled at (15566): [<c161a81e>] __do_softirq+0xa5/0xaa
[ 8450.431943] softirqs last disabled at (15561): [<c1605cb7>] do_softirq+0x5b/0xc8
[ 8450.439386]  [<c1604556>] show_trace_log_lvl+0x1a/0x2f
[ 8450.444555]  [<c1604c2c>] show_trace+0x12/0x14
[ 8450.449032]  [<c1604cde>] dump_stack+0x16/0x18
[ 8450.453511]  [<c1612a6c>] __might_sleep+0xc9/0xcf
[ 8450.458248]  [<c1629a0e>] down_read+0x18/0x4b
[ 8450.462640]  [<c163b8fd>] acct_collect+0x3b/0x146
[ 8450.467376]  [<c1618c96>] do_exit+0x1b6/0x6fd
[ 8450.471768]  [<c1604b34>] die+0x1f8/0x21e
[ 8450.475813]  [<c1604bd3>] do_trap+0x79/0x91
[ 8450.480031]  [<c160523a>] do_divide_error+0x94/0x9e
[ 8450.484942]  [<c17fb54c>] error_code+0x74/0x7c
[ 8450.489418]  [<c1643230>] request_irq+0xac/0xf4
[ 8450.493984]  [<ca902144>] snd_intel8x0_probe+0x482/0xffb [snd_intel8x0]
[ 8450.500631]  [<c16e78c5>] pci_device_probe+0x39/0x5b
[ 8450.505626]  [<c173e633>] really_probe+0xbd/0x145
[ 8450.510364]  [<c173e750>] driver_probe_device+0x95/0xa1
[ 8450.515619]  [<c173e865>] __driver_attach+0x6a/0xa1
[ 8450.520529]  [<c173dc61>] bus_for_each_dev+0x36/0x5b
[ 8450.525526]  [<c173e4a7>] driver_attach+0x19/0x1b
[ 8450.530263]  [<c173df0e>] bus_add_driver+0x6a/0x170
[ 8450.535171]  [<c173ea70>] driver_register+0x79/0x7e
[ 8450.540082]  [<c16e7a43>] __pci_register_driver+0x7c/0xa9
[ 8450.545511]  [<ca909017>] alsa_card_intel8x0_init+0x17/0x19 [snd_intel8x0]
[ 8450.552418]  [<c16366ad>] sys_init_module+0x11b0/0x12f0
[ 8450.557672]  [<c1603e72>] sysenter_past_esp+0x5f/0x99
[ 8450.562756]  =======================
[ 8450.566397] BUG: scheduling while atomic: modprobe/0x10000001/1336
[ 8450.572596] 1 lock held by modprobe/1336:
[ 8450.576623]  #0:  (&chip->reg_lock){....}, at: [<ca9031fe>] snd_intel8x0_interrupt+0x8c/0x1dc [snd_intel8x0]
[ 8450.586643]  [<c1604556>] show_trace_log_lvl+0x1a/0x2f
[ 8450.591838]  [<c1604c2c>] show_trace+0x12/0x14
[ 8450.596333]  [<c1604cde>] dump_stack+0x16/0x18
[ 8450.600826]  [<c17f8521>] __sched_text_start+0x71/0x5fb
[ 8450.606108]  [<c161351b>] __cond_resched+0x21/0x3b
[ 8450.610950]  [<c17f8ca4>] cond_resched+0x26/0x31
[ 8450.615617]  [<c16507e2>] unmap_vmas+0x330/0x413
[ 8450.620294]  [<c1653014>] exit_mmap+0x68/0xec
[ 8450.624703]  [<c1614495>] mmput+0x2e/0x7b
[ 8450.628765]  [<c161798e>] exit_mm+0xbb/0xc1
[ 8450.633001]  [<c1618cc7>] do_exit+0x1e7/0x6fd
[ 8450.637410]  [<c1604b34>] die+0x1f8/0x21e
[ 8450.641489]  [<c1604bd3>] do_trap+0x79/0x91
[ 8450.645725]  [<c160523a>] do_divide_error+0x94/0x9e
[ 8450.650660]  [<c17fb54c>] error_code+0x74/0x7c
[ 8450.655164]  [<c1643230>] request_irq+0xac/0xf4
[ 8450.659755]  [<ca902144>] snd_intel8x0_probe+0x482/0xffb [snd_intel8x0]
[ 8450.666420]  [<c16e78c5>] pci_device_probe+0x39/0x5b
[ 8450.671441]  [<c173e633>] really_probe+0xbd/0x145
[ 8450.676194]  [<c173e750>] driver_probe_device+0x95/0xa1
[ 8450.681476]  [<c173e865>] __driver_attach+0x6a/0xa1
[ 8450.686412]  [<c173dc61>] bus_for_each_dev+0x36/0x5b
[ 8450.691434]  [<c173e4a7>] driver_attach+0x19/0x1b
[ 8450.696188]  [<c173df0e>] bus_add_driver+0x6a/0x170
[ 8450.701124]  [<c173ea70>] driver_register+0x79/0x7e
[ 8450.706052]  [<c16e7a43>] __pci_register_driver+0x7c/0xa9
[ 8450.711506]  [<ca909017>] alsa_card_intel8x0_init+0x17/0x19 [snd_intel8x0]
[ 8450.718430]  [<c16366ad>] sys_init_module+0x11b0/0x12f0
[ 8450.723712]  [<c1603e72>] sysenter_past_esp+0x5f/0x99
[ 8450.728821]  =======================

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-git3-kdump/kdump-config2

serial console log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-03-05-02-22/mm_snaps2.txt

Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
