Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbYKPNEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbYKPNEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 08:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYKPNEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 08:04:25 -0500
Received: from ppp-111-253.adsl.restena.lu ([158.64.111.253]:43622 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750849AbYKPNEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 08:04:24 -0500
Date: Sun, 16 Nov 2008 14:04:21 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc5
Message-ID: <20081116140421.644e9ab2@neptune.home>
In-Reply-To: <alpine.LFD.2.00.0811151444090.3468@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0811151444090.3468@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 November 2008 Linus Torvalds wrote:
> 
> Hmm.. No clear pattern here, mostly random fixes, along with some
> file movement in the Documentation/ subdirectory. Bulk-wise, that's
> the biggest part if you see it as a traditional diff (because of the
> delete/create pairs), but with rename detection on the Doc patches
> are only about 10% of the changes.
> 
> The rest tends to be the ppc def_config updates (15%), and then
> random driver updates (65% - mostly due to some new hwmon and rtc
> drivers and the c2port driver).
> 
> But in number of commits, most of them are really just random small 
> changes all over. ACPI, DM, USB, V4L, ocfs..  Nothing really strikes
> me as standing out, but if I had to pick something, then the ACPI
> update in particular hopefully fixes a few regressions. Along with
> disabling tick_nohz_kick_tick.

With rc-5 I get the following trace while running acpitool, error which
did not happen on rc3-git6:

[   49.311377] Oops: 0000 [#1] 
[   49.311569] last sysfs file: /sys/module/acpi/parameters/acpica_version
[   49.311707] Modules linked in: snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc sg via_agp agpgart
[   49.312438] 
[   49.312552] Pid: 1823, comm: acpitool Not tainted (2.6.28-rc5 #1) CX700+W697HG
[   49.312736] EIP: 0060:[<c0292d22>] EFLAGS: 00010286 CPU: 0
[   49.312880] EIP is at acpi_system_wakeup_device_seq_show+0x96/0xdc
[   49.313019] EAX: 00000000 EBX: f7114400 ECX: f17cf03b EDX: 0000003b
[   49.313158] ESI: f7114418 EDI: f7031800 EBP: f3418f18 ESP: f3418f00
[   49.313296]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   49.313431] Process acpitool (pid: 1823, ti=f3418000 task=f71cca20 task.ti=f3418000)
[   49.313610] Stack:
[   49.313718]  f703188c f69f46c0 f7119018 f712c600 f69f46c0 00000001 f3418f54 c0181146
[   49.314240]  00001fff 095be170 f6928580 f69f46e0 00000000 00000000 00000000 f69ba9e0
[   49.314901]  00000000 00000000 f712c600 c0181090 fffffffb f3418f70 c019bebf f3418f9c
[   49.315797] Call Trace:
[   49.315908]  [<c0181146>] ? seq_read+0xb6/0x2d0
[   49.316097]  [<c0181090>] ? seq_read+0x0/0x2d0
[   49.316279]  [<c019bebf>] ? proc_reg_read+0x3f/0x60
[   49.316468]  [<c016c9a0>] ? vfs_read+0x90/0x110
[   49.316659]  [<c019be80>] ? proc_reg_read+0x0/0x60
[   49.316846]  [<c016ce8d>] ? sys_read+0x3d/0x70
[   49.317034]  [<c0103bc1>] ? sysenter_do_call+0x12/0x25
[   49.317227] Code: ff b3 8c 01 00 00 8d 46 18 50 68 a2 fb 4b c0 ff 75 ec e8 e2 dc ee ff 83 c4 18 85 ff 74 1f 8d 87 8c 00 00 00 50 8b 87 b8 00 00 00 <ff> 30 68 b4 fb 4b c0 ff 75 ec e8 bf dc ee ff 83 c4 10 68 3d 79 
[   49.320020] EIP: [<c0292d22>] acpi_system_wakeup_device_seq_show+0x96/0xdc SS:ESP 0068:f3418f00
[   49.321475] ---[ end trace 86a9b6669d58e134 ]---


[   49.343939] BUG: unable to handle kernel NULL pointer dereference at 00000000
[   49.344244] IP: [<c0292d22>] acpi_system_wakeup_device_seq_show+0x96/0xdc
[   49.344478] *pde = 00000000 
[   49.344665] Oops: 0000 [#2] 
[   49.344831] last sysfs file: /sys/module/acpi/parameters/acpica_version
[   49.344967] Modules linked in: snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc sg via_agp agpgart
[   49.345696] 
[   49.345813] Pid: 1825, comm: acpitool Tainted: G      D    (2.6.28-rc5 #1) CX700+W697HG
[   49.346001] EIP: 0060:[<c0292d22>] EFLAGS: 00010286 CPU: 0
[   49.346144] EIP is at acpi_system_wakeup_device_seq_show+0x96/0xdc
[   49.346283] EAX: 00000000 EBX: f7114400 ECX: f17cf03b EDX: 0000003b
[   49.346422] ESI: f7114418 EDI: f7031800 EBP: f341df18 ESP: f341df00
[   49.346560]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   49.346695] Process acpitool (pid: 1825, ti=f341d000 task=f71cd0e0 task.ti=f341d000)
[   49.346873] Stack:
[   49.346982]  f703188c f69f4e40 f7119018 f712c600 f69f4e40 00000001 f341df54 c0181146
[   49.347499]  00001fff 084ce170 f6928280 f69f4e60 00000000 00000000 00000000 f69baa40
[   49.348163]  00000000 00000000 f712c600 c0181090 fffffffb f341df70 c019bebf f341df9c
[   49.349047] Call Trace:
[   49.349158]  [<c0181146>] ? seq_read+0xb6/0x2d0
[   49.349347]  [<c0181090>] ? seq_read+0x0/0x2d0
[   49.349528]  [<c019bebf>] ? proc_reg_read+0x3f/0x60
[   49.349718]  [<c016c9a0>] ? vfs_read+0x90/0x110
[   49.349908]  [<c019be80>] ? proc_reg_read+0x0/0x60
[   49.350035]  [<c016ce8d>] ? sys_read+0x3d/0x70
[   49.350035]  [<c0103bc1>] ? sysenter_do_call+0x12/0x25
[   49.350035] Code: ff b3 8c 01 00 00 8d 46 18 50 68 a2 fb 4b c0 ff 75 ec e8 e2 dc ee ff 83 c4 18 85 ff 74 1f 8d 87 8c 00 00 00 50 8b 87 b8 00 00 00 <ff> 30 68 b4 fb 4b c0 ff 75 ec e8 bf dc ee ff 83 c4 10 68 3d 79 
[   49.350035] EIP: [<c0292d22>] acpi_system_wakeup_device_seq_show+0x96/0xdc SS:ESP 0068:f341df00
[   49.354712] ---[ end trace 86a9b6669d58e134 ]---


The following change is guilty on my machine (though I could not find
the matching commit on git.kernel.org :( )
Reverting the change below makes the error go away.

Bruno

---
--- linux-2.6.28-rc3-git6/drivers/acpi/sleep/proc.c	2008-11-09 11:53:21.000000000 +0100
+++ linux-2.6.28-rc5/drivers/acpi/sleep/proc.c	2008-11-16 12:14:57.000000000 +0100
@@ -366,8 +366,8 @@ acpi_system_wakeup_device_seq_show(struc
 			   dev->wakeup.state.enabled ? "enabled" : "disabled");
 		if (ldev)
 			seq_printf(seq, "%s:%s",
-				   ldev->bus ? ldev->bus->name : "no-bus",
-				   ldev->bus_id);
+				   dev_name(ldev) ? ldev->bus->name : "no-bus",
+				   dev_name(ldev));
 		seq_printf(seq, "\n");
 		put_device(ldev);
 
