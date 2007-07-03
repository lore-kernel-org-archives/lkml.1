Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbXGCW7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbXGCW7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXGCW7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:59:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:6439 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbXGCW7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Y2+4JLxm/4/tpIxm5VyQiTZmAZJDNzba+pfvOsEdrTvH5n5CncCPdTSF5d3+l6Ln3Ti1ss0bmYlJswN/pYna1JB9yzxBM1ktfpkaO7iTwgXz9q98dV81456fg8JK2Hy1nnmyiEVYm3tf4VtVbYNGTIs66W8j9O2SWRNK1ee0BSI=
Message-ID: <a44ae5cd0707031559j3485d57dw58386ed837378d8e@mail.gmail.com>
Date: Tue, 3 Jul 2007 15:59:08 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.22-rc6-mm1 -- BUG - EIP: [<f8ac1350>] drm_vma_info+0x2a5/0x310 [drm] SS:ESP 0068:c80cde9c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I ran the command:
          find /proc | xargs grep a

BUG: unable to handle kernel NULL pointer dereference at virtual
address 00000000
 printing eip:
f8ac1350
*pde = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: arc4 ecb blkcipher cryptomgr crypto_algapi
ieee80211_crypt_wep bluetooth i915 drm acpi_cpufreq
cpufreq_conservative cpufreq_powersave cpufreq_performance ac battery
video output button processor container firewire_sbp2 parport_pc lp
parport pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss yenta_socket
rsrc_nonstatic sdhci snd_seq_midi_event ipw2200 tifm_7xx1 mmc_core
pcmcia_core ieee80211 ieee80211_crypt tifm_core snd_seq snd_timer
snd_seq_device evdev shpchp snd iTCO_wdt iTCO_vendor_support
pci_hotplug soundcore snd_page_alloc firewire_ohci firewire_core
crc_itu_t 8139too ehci_hcd uhci_hcd usbcore fan
CPU:    0
EIP:    0060:[<f8ac1350>]    Not tainted VLI
EFLAGS: 00010283   (2.6.22-rc6-mm1 #5)
EIP is at drm_vma_info+0x2a5/0x310 [drm]
eax: 00000000   ebx: c80cdf38   ecx: 00000000   edx: 00000000
esi: 00008000   edi: c467e000   ebp: c80cdf0c   esp: c80cde9c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process grep (pid: 5172, ti=c80cd000 task=c7e9ed60 task.ti=c80cd000)
Stack: c467e000 f8ac595a 00000000 f8000000 38000000 00000000 c0526e9c c80cdefc
       c0165700 00000044 00000001 00000000 c7e9ed60 00000000 c467e000 c63b68e0
       c1195548 00000000 00000035 c7e9f328 00000001 000800d0 00000000 00000000
Call Trace:
 [<c01b514d>] proc_file_read+0x108/0x222
 [<c01b19ed>] proc_reg_read+0x63/0x76
 [<c01834aa>] vfs_read+0xb0/0x139
 [<c018390e>] sys_read+0x3d/0x72
 [<c0108162>] sysenter_past_esp+0x6b/0xb5
 [<ffffe410>] 0xffffe410
 =======================
INFO: lockdep is turned off.
Code: 24 04 c9 59 ac f8 8b 45 c8 01 d8 89 04 24 e8 3c 66 74 c7 01 c3
89 5d d8 81 fb b0 0f 00 00 77 4a 8b 45 d4 8b 00 89 45 d4 8b 55 d4 <8b>
02 0f 18 00 90 8b 45 10 05 98 01 00 00 39 c2 0f 85 e7 fd ff
EIP: [<f8ac1350>] drm_vma_info+0x2a5/0x310 [drm] SS:ESP 0068:c80cde9c
