Return-Path: <linux-kernel-owner+w=401wt.eu-S1751410AbXBCTy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbXBCTy2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 14:54:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbXBCTy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 14:54:28 -0500
Received: from vms046pub.verizon.net ([206.46.252.46]:41657 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbXBCTy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 14:54:27 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Feb 2007 14:54:27 EST
Date: Sat, 03 Feb 2007 13:54:17 -0500
From: Eric Buddington <ebuddington@verizon.net>
Subject: 2.6.20-rc6-mm3 BUG in drm_ioctl with Rage 128 card
To: linux-kernel@vger.kernel.org
Reply-to: ebuddington@wesleyan.edu
Message-id: <20070203185407.GA5256@pool-70-109-243-148.wma.east.verizon.net>
Organization: ECS Labs
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-Eric-conspiracy: there is no conspiracy
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While repeatedly recompiling and restarting xorg-server-1.1.1, I
managed to generate the following BUG. Kernel is 2.6.20-rc6-mm3, video card is

01:00.0 VGA compatible controller: ATI Technologies Inc Rage 128 Pro Ultra TF (prog-if 00 [VGA])

-Eric

----------------------------------
BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000
0
 printing eip:
00000000
*pde = 18cdb067
*pte = 00000000
Oops: 0000 [#1]
last sysfs file: /devices/pci0000:00/0000:00:00.0/class
Modules linked in: ppp_synctty ppp_async crc_ccitt ppp_generic slhc r128 drm sof
tdog keyspan_pda usbserial sch_tbf raw1394 dv1394 ohci1394 ieee1394 snd_ice1712 
snd_ice17xx_ak4xxx snd_ak4xxx_adda snd_cs8427 snd_i2c snd_mpu401_uart snd_rawmid
i usbnet snd_intel8x0 snd_ac97_codec ac97_bus ipt_tos ipt_owner iptable_nat nf_c
onntrack_ipv4 ipt_MASQUERADE nf_nat nf_conntrack nfnetlink ipt_TOS iptable_filte
r iptable_mangle ip_tables x_tables 8139too sis900 sis5595 hwmon i2c_isa i2c_cor
e sis_agp agpgart ide_scsi
CPU:    0
EIP:    0060:[<00000000>]    Tainted: G   M   VLI
EFLAGS: 00013246   (2.6.20-rc6-mm3 #1)
EIP is at 0x0
eax: f7a3ec60   ebx: 00000000   ecx: f928eda0   edx: 00000000
esi: f7a3ec60   edi: c3c399e0   ebp: 00004000   esp: f355feb0
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process X (pid: 30162, ti=f355e000 task=f7932030 task.ti=f355e000)
Stack: f9299ccc 00000800 000006d0 00000003 c1b36570 00000000 00000000 0040ee73 
       f928eda0 c3c399e0 00000000 f56d2800 f929928c bf94831c 00000000 f52bf1e0 
       00000000 f51c8860 f93e77bf f93f1800 c029926f 00000000 f93f1810 f56d2800 
Call Trace:
 [<f9299ccc>] agp_generic_insert_memory+0x5f/0x147 [agpgart]
 [<f929928c>] agp_bind_memory+0x53/0x64 [agpgart]
 [<f93e77bf>] drm_agp_bind+0x49/0x9f [drm]
 [<c029926f>] copy_to_user+0x2d/0x42
 [<f93e7845>] drm_agp_bind_ioctl+0x30/0x39 [drm]
 [<f93e7815>] drm_agp_bind_ioctl+0x0/0x39 [drm]
 [<f93e3f10>] drm_ioctl+0x14b/0x193 [drm]
 [<f93e3dc5>] drm_ioctl+0x0/0x193 [drm]
 [<c015b94a>] do_ioctl+0x3e/0x4d
 [<c015bb60>] vfs_ioctl+0x207/0x21e
 [<c015bbaa>] sys_ioctl+0x33/0x4d
 [<c0104b30>] sysenter_past_esp+0x5d/0x81
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] 0x0 SS:ESP 0068:f355feb0
[drm:drm_release] *ERROR* Device busy: 1 0
