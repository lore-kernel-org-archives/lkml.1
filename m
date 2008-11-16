Return-Path: <linux-kernel-owner+w=401wt.eu-S1752922AbYKPOAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922AbYKPOAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 09:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYKPOAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 09:00:06 -0500
Received: from cpsmtpo-eml06.KPNXCHANGE.COM ([213.75.38.155]:55524 "EHLO
	cpsmtpo-eml06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620AbYKPOAF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 09:00:05 -0500
From: Frans Pop <elendil@planet.nl>
To: Bruno =?utf-8?q?Pr=E9mont?= <bonbons@linux-vserver.org>
Subject: Re: Linux 2.6.28-rc5
Date: Sun, 16 Nov 2008 14:59:59 +0100
User-Agent: KMail/1.9.9
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
References: <alpine.LFD.2.00.0811151444090.3468@nehalem.linux-foundation.org> <alpine.LFD.2.00.0811151444090.3468@nehalem.linux-foundation.org> <20081116140421.644e9ab2@neptune.home>
In-reply-To: <20081116140421.644e9ab2@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200811161459.59838.elendil@planet.nl>
X-OriginalArrivalTime: 16 Nov 2008 14:00:00.0242 (UTC) FILETIME=[9D895D20:01C947F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont wrote:
> With rc-5 I get the following trace while running acpitool, error which
> did not happen on rc3-git6:
> 
> [   49.311377] Oops: 0000 [#1]
> [   49.311569] last sysfs file: /sys/module/acpi/parameters/acpica_version
> [   49.311707] Modules linked in: snd_hda_intel snd_pcm snd_timer snd
> [   soundcore snd_page_alloc sg via_agp agpgart 49.312438]
> [   49.312552] Pid: 1823, comm: acpitool Not tainted (2.6.28-rc5 #1)
> [   CX700+W697HG 49.312736] EIP: 0060:[<c0292d22>] EFLAGS: 00010286 CPU: 0
> [   49.312880] EIP is at acpi_system_wakeup_device_seq_show+0x96/0xdc
> [   49.313019] EAX: 00000000 EBX: f7114400 ECX: f17cf03b EDX: 0000003b
> [   49.313158] ESI: f7114418 EDI: f7031800 EBP: f3418f18 ESP: f3418f00
> [   49.313296]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [   49.313431] Process acpitool (pid: 1823, ti=f3418000 task=f71cca20
> [   task.ti=f3418000) 49.313610] Stack:
> [   49.313718]  f703188c f69f46c0 f7119018 f712c600 f69f46c0 00000001
> [   f3418f54 c0181146
> [   49.314240]  00001fff 095be170 f6928580 f69f46e0 00000000 00000000
> [   00000000 f69ba9e0
> [   49.314901]  00000000 00000000 f712c600 c0181090 fffffffb f3418f70
> [   c019bebf f3418f9c 49.315797] Call Trace:
> [   49.315908]  [<c0181146>] ? seq_read+0xb6/0x2d0
> [   49.316097]  [<c0181090>] ? seq_read+0x0/0x2d0
> [   49.316279]  [<c019bebf>] ? proc_reg_read+0x3f/0x60
> [   49.316468]  [<c016c9a0>] ? vfs_read+0x90/0x110
> [   49.316659]  [<c019be80>] ? proc_reg_read+0x0/0x60
> [   49.316846]  [<c016ce8d>] ? sys_read+0x3d/0x70
> [   49.317034]  [<c0103bc1>] ? sysenter_do_call+0x12/0x25
> [   49.317227] Code: ff b3 8c 01 00 00 8d 46 18 50 68 a2 fb 4b c0 ff 75 ec
> [   e8 e2 dc ee ff 83 c4 18 85 ff 74 1f 8d 87 8c 00 00 00 50 8b 87 b8 00
> [   00 00 <ff> 30 68 b4 fb 4b c0 ff 75 ec e8 bf dc ee ff 83 c4 10 68 3d 79
> [   49.320020] EIP: [<c0292d22>]
> [   acpi_system_wakeup_device_seq_show+0x96/0xdc SS:ESP 0068:f3418f00
> [   49.321475] ---[ end trace 86a9b6669d58e134 ]---
> 
> 
> [   49.343939] BUG: unable to handle kernel NULL pointer dereference at
> [   00000000 49.344244] IP: [<c0292d22>]
> [   acpi_system_wakeup_device_seq_show+0x96/0xdc 49.344478] *pde =
> [   00000000 49.344665] Oops: 0000 [#2]
> [   49.344831] last sysfs file: /sys/module/acpi/parameters/acpica_version
> [   49.344967] Modules linked in: snd_hda_intel snd_pcm snd_timer snd
> [   soundcore snd_page_alloc sg via_agp agpgart 49.345696]
> [   49.345813] Pid: 1825, comm: acpitool Tainted: G      D    (2.6.28-rc5
> [   #1) CX700+W697HG 49.346001] EIP: 0060:[<c0292d22>] EFLAGS: 00010286
> [   CPU: 0 49.346144] EIP is at
> [   acpi_system_wakeup_device_seq_show+0x96/0xdc 49.346283] EAX: 00000000
> [   EBX: f7114400 ECX: f17cf03b EDX: 0000003b 49.346422] ESI: f7114418
> [   EDI: f7031800 EBP: f341df18 ESP: f341df00
> [   49.346560]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [   49.346695] Process acpitool (pid: 1825, ti=f341d000 task=f71cd0e0
> [   task.ti=f341d000) 49.346873] Stack:
> [   49.346982]  f703188c f69f4e40 f7119018 f712c600 f69f4e40 00000001
> [   f341df54 c0181146
> [   49.347499]  00001fff 084ce170 f6928280 f69f4e60 00000000 00000000
> [   00000000 f69baa40
> [   49.348163]  00000000 00000000 f712c600 c0181090 fffffffb f341df70
> [   c019bebf f341df9c 49.349047] Call Trace:
> [   49.349158]  [<c0181146>] ? seq_read+0xb6/0x2d0
> [   49.349347]  [<c0181090>] ? seq_read+0x0/0x2d0
> [   49.349528]  [<c019bebf>] ? proc_reg_read+0x3f/0x60
> [   49.349718]  [<c016c9a0>] ? vfs_read+0x90/0x110
> [   49.349908]  [<c019be80>] ? proc_reg_read+0x0/0x60
> [   49.350035]  [<c016ce8d>] ? sys_read+0x3d/0x70
> [   49.350035]  [<c0103bc1>] ? sysenter_do_call+0x12/0x25
> [   49.350035] Code: ff b3 8c 01 00 00 8d 46 18 50 68 a2 fb 4b c0 ff 75 ec
> [   e8 e2 dc ee ff 83 c4 18 85 ff 74 1f 8d 87 8c 00 00 00 50 8b 87 b8 00
> [   00 00 <ff> 30 68 b4 fb 4b c0 ff 75 ec e8 bf dc ee ff 83 c4 10 68 3d 79
> [   49.350035] EIP: [<c0292d22>]
> [   acpi_system_wakeup_device_seq_show+0x96/0xdc SS:ESP 0068:f341df00
> [   49.354712] ---[ end trace 86a9b6669d58e134 ]---
> 
> 
> The following change is guilty on my machine (though I could not find
> the matching commit on git.kernel.org :( )

That would be:
commit 0794469da3f7b2093575cbdfc1108308dd3641ce
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Thu Oct 30 01:18:59 2008 +0100
    ACPI: struct device - replace bus_id with dev_name(), dev_set_name()

> Reverting the change below makes the error go away.

Cheers,
FJP
