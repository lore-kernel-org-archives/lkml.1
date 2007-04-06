Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbXDFWiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbXDFWiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:38:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933176AbXDFWiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:38:10 -0400
Received: from www17.your-server.de ([213.133.104.17]:2333 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142AbXDFWiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:38:08 -0400
Message-ID: <4616CBF4.8020205@m3y3r.de>
Date: Sat, 07 Apr 2007 00:38:44 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG] unable to handle kernel paging request at virtual address 0800000e
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dmesg output:

pktcdvd: pkt_get_last_written failed
BUG: unable to handle kernel paging request at virtual address 0800000e
 printing eip:
c015cc98
*pde = 3741d067
*pte = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: nls_iso8859_15 nls_cp850 vfat fat appletouch dummy
genrtc binfmt_misc tun cpufreq_ondemand cpufreq_powersave
cpufreq_conservative pktcdvd loop video thermal fan button battery ac
msr cpuid acpi_cpufreq freq_table processor usbhid eeprom eth1394
uhci_hcd ehci_hcd usbcore ohci1394 evdev ieee1394 tpm_infineon tpm
tpm_bios rng_core iTCO_wdt sr_mod cdrom snd_hda_intel snd_hda_codec
snd_pcm snd_timer snd soundcore snd_page_alloc i2c_i801 i2c_core sg
CPU:    0
EIP:    0060:[<c015cc98>]    Not tainted VLI
EFLAGS: 00010203   (2.6.21-rc6 #295)
EIP is at do_sys_open+0x56/0xc3
eax: 08000002   ebx: 00008000   ecx: 00000000   edx: 00000000
esi: ffffff9c   edi: 08000002   ebp: 00000003   esp: f76baf90
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process vol_id (pid: 5142, ti=f76ba000 task=f76c9570 task.ti=f76ba000)
Stack: 00000000 c02ea31c f7548000 bfa82f64 00008000 b7ec6ff4 f76ba000
c015cd3e
       00000000 c0103d1e bfa82f64 00008000 00000000 00008000 b7ec6ff4
bfa81688
       00000005 0000007b 0000007b c02a0000 00000005 b7efa410 00000073
00000206
Call Trace:
 [<c015cd3e>] sys_open+0x1c/0x1e
 [<c0103d1e>] sysenter_past_esp+0x5f/0x85
 [<c02a0000>] xfrm_state_find+0x2cc/0x4a9
 =======================
Code: c5 78 7d 8b 44 24 20 89 d9 8b 54 24 08 89 04 24 89 f0 e8 85 ff ff
ff 3d 00 f0 ff ff 89 c7 76 0b 89 e8 89 fd e8 e0 fb ff ff eb 55 <8b> 40
0c bb 20 00 00 40 8b 70 0c 0f b7 56 6e 81 e2 00 f0 00 00
EIP: [<c015cc98>] do_sys_open+0x56/0xc3 SS:ESP 0068:f76baf90
appletouch: incomplete data package (first byte: 2, length: 4).
sky2 eth0: enabling interface
sky2 eth0: ram buffer 48K
cdrom: This disc doesn't have any tracks I recognize!

This happens while calling command pktsetup.

