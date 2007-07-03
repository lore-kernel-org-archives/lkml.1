Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbXGCQcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbXGCQcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXGCQcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:32:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:55332 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbXGCQce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:32:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=cY7sUeTLtATXXUq5qPFELgYh/VJloC+8JUb4eEU43cB6s5ALc6/P5wAnVTqha8wdVStJoG8N7YwS2udjdu8nbs6Q6gL62SF44b4ED9pLPTTqW6l4oE8BXLTBc2uUScslj1qf93dVjZkmCjge0Rg1TyKM6/WydZ2AEXVR9XU+a6A=
Message-ID: <a44ae5cd0707030932h16a90ca3j8ad65b7a3ec64b03@mail.gmail.com>
Date: Tue, 3 Jul 2007 09:32:32 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.22-rc6-mm1 -- BUG - EIP: [<c01a77a1>] sysfs_addrm_finish+0x1c2/0x226 SS:ESP 0068:c5ff9db8
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to remove the ipw2200 module and hit this BUG.

kernel BUG at fs/sysfs/dir.c:271!
invalid opcode: 0000 [#1]
PREEMPT
Modules linked in: i915 drm cpufreq_conservative cpufreq_powersave
cpufreq_performance firewire_sbp2 parport_pc lp parport snd_intel8x0
snd_ac97_codec ac97_bus pcmcia snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy sdhci ipw2200 mmc_core yenta_socket rsrc_nonstatic
pcmcia_core ieee80211 ieee80211_crypt snd_seq_oss snd_seq_midi_event
snd_seq snd_timer snd_seq_device snd iTCO_wdt iTCO_vendor_support
soundcore snd_page_alloc firewire_ohci firewire_core crc_itu_t
ehci_hcd uhci_hcd usbcore
CPU:    0
EIP:    0060:[<c01a77a1>]    Not tainted VLI
EFLAGS: 00010202   (2.6.22-rc6-mm1 #2)
EIP is at sysfs_addrm_finish+0x1c2/0x226
eax: 00000001   ebx: c5ff9dc0   ecx: c058aa40   edx: 00000001
esi: c5ff9de8   edi: c37c3240   ebp: c5ff9e1c   esp: c5ff9db8
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process modprobe (pid: 3519, ti=c5ff9000 task=c5ef15e0 task.ti=c5ff9000)
Stack: c03a3eda c5ff9e24 00000000 00000001 dead4ead ffffffff ffffffff c0657cf0
       00000000 c046359d c5ff9de0 c5ff9de0 00000000 00000001 dead4ead ffffffff
       ffffffff c0657cf0 00000000 c046359d c5ff9de0 c5ff9de0 c37c3240 c5ff9e24
Call Trace:
 [<c01a7833>] remove_dir+0x2e/0x35
 [<c01a7894>] __sysfs_remove_dir+0x5a/0x61
 [<c01a78d1>] sysfs_remove_dir+0x2c/0x30
 [<c0239386>] kobject_del+0xf/0x19
 [<c02b76c6>] device_del+0x254/0x27a
 [<c0321215>] netdev_unregister_sysfs+0x1b/0x1e
 [<c03168af>] unregister_netdevice+0x1c3/0x1fe
 [<c03168fc>] unregister_netdev+0x12/0x1a
 [<f89b102f>] ipw_pci_remove+0x59/0x1c4 [ipw2200]
 [<c0252c28>] pci_device_remove+0x19/0x39
 [<c02b966e>] __device_release_driver+0x74/0x90
 [<c02b9b23>] driver_detach+0x9a/0xd7
 [<c02b91ef>] bus_remove_driver+0x5d/0x79
 [<c02b9b87>] driver_unregister+0x8/0xa
 [<c0252d92>] pci_unregister_driver+0x13/0x55
 [<f89b1c51>] ipw_exit+0x1c/0x1e [ipw2200]
 [<c0144427>] sys_delete_module+0x1bd/0x22a
 [<c01040be>] sysenter_past_esp+0x5f/0x99
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
Code: d8 e8 30 58 09 00 ba 01 00 00 00 83 7f 0c 00 75 0c 8b 57 1c 80
f6 01 c1 ea 08 83 e2 01 b8 40 aa 58 c0 e8 8f 5e 0a 00 85 c0 74 04 <0f>
0b eb fe 8d 55 a4 89 57 0c b8 00 00 00 80 0f c1 47 04 85 c0
EIP: [<c01a77a1>] sysfs_addrm_finish+0x1c2/0x226 SS:ESP 0068:c5ff9db8
