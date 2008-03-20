Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYCTDtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYCTDtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 23:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYCTDtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 23:49:07 -0400
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:54580
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752319AbYCTDtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 23:49:05 -0400
X-Authority-Analysis: v=1.0 c=1 a=s-HCJz5qoZoA:10 a=g_seVL95pCE8yyz_0cIA:9
 a=jj4jvjSejmHj_aZsSrwO_rmIeSgA:4 a=CWfAmLVWKswA:10 a=niGgr9QyNRAZ6soqq-UA:9
 a=OnepgINI6_CckQsvwtHI9GGO6SoA:4 a=vNGxQsTWjH8A:10 a=gkO0NoxwMhc2Q_-iLPIA:9
 a=ZnL4nbcXHK31ONxcMZ4A:7 a=nJB_ELdrnoggLJu2DJinJHcMRxwA:4 a=HOt-SvZ3x1UA:10
From: Scott Simpson <Scott.Simpson@computer.org>
Reply-To: Scott.Simpson@computer.org
To: linux-kernel@vger.kernel.org
Subject: Kernel stack trace in 2.6.24.3-34.fc8
Date: Wed, 19 Mar 2008 20:49:02 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_u6d4HZcVvY9sTu8"
Message-Id: <200803192049.02720.Scott.Simpson@computer.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_u6d4HZcVvY9sTu8
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I'm running Fedora 8 (MythTV) using 2.6.24.3-34.fc8 and I'm getting a stack 
trace in the ivtv driver (not tainted!). My system was working fine under 
2.6.23.15-137.fc8. I'm enclosing the stack trace in ivtv. The exact system 
setup is

vmlinuz-2.6.24.3-34.fc8
ivtv-kmdl-2.6.24.3-34.fc8-1.0.3-136.fc8.i686.rpm (from ATRPMs)


Also, if I add the wifi drivers (which I know taints the kernel), I get the 
madwifi stack traces listed. This is using

madwifi-hal-kmdl-2.6.24.3-34.fc8-0.9.3.3-39.fc8.i686.rpm
madwifi-kmdl-2.6.24.3-34.fc8-0.9.3.3-39.fc8.i686.rpm

from ATRPMs. I realize this is a tainted kernel and I'm on my own, but 
hopefully someone has something insightful.

--Boundary-00=_u6d4HZcVvY9sTu8
Content-Type: application/octet-stream;
  name="ivtv_stack_trace.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ivtv_stack_trace.txt"

Mar 18 20:50:41 mythtv kernel: 
Mar 18 20:50:41 mythtv kernel: Pid: 2513, comm: modprobe Not tainted (2.6.24.3-34.fc8 #1)
Mar 18 20:50:41 mythtv kernel: EIP: 0060:[<e1ca7319>] EFLAGS: 00210216 CPU: 0
Mar 18 20:50:41 mythtv kernel: EIP is at ivtvfb_init_card+0x1c1/0x648 [ivtvfb]
Mar 18 20:50:41 mythtv kernel: EAX: 00000000 EBX: ffe00000 ECX: 00068100 EDX: 001a0400
Mar 18 20:50:41 mythtv kernel: ESI: df9c0000 EDI: 00510000 EBP: e1ca9400 ESP: d786ae38
Mar 18 20:50:41 mythtv kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Mar 18 20:50:41 mythtv kernel: Process modprobe (pid: 2513, ti=d786a000 task=d79ee000 task.ti=d786a000)
Mar 18 20:50:41 mythtv kernel: Stack: e1ca836b 00000000 01400000 01800000 00000681 00000137 00000000 00510000 
Mar 18 20:50:41 mythtv kernel:        002c0800 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
Mar 18 20:50:41 mythtv kernel:        00000000 00000000 00000000 00000000 00000000 00000000 00000000 df9c0000 
Mar 18 20:50:41 mythtv kernel: Call Trace:
Mar 18 20:50:41 mythtv kernel:  [<e088705a>] ivtvfb_init+0x5a/0xcc [ivtvfb]
Mar 18 20:50:41 mythtv kernel:  [<c044d204>] sys_init_module+0x14d6/0x15f9
Mar 18 20:50:41 mythtv kernel:  [<e0a8e876>] ivtv_udma_setup+0x0/0x26c [ivtv]
Mar 18 20:50:41 mythtv kernel:  [<c04051da>] syscall_call+0x7/0xb
Mar 18 20:50:41 mythtv kernel:  =======================
Mar 18 20:50:41 mythtv kernel: Code: 89 4c 24 04 c7 04 24 6b 83 ca e1 89 54 24 0c 89 44 24 08 e8 54 84 78 de 8b 86 74 f4 00 00 8b 50 0c 8b 78 08 31 c0 89 d1 c1 e9 02 <f3> ab f6 c2 02 74 02 66 ab f6 c2 01 74 01 aa 83 3d 88 a5 ca e1 
Mar 18 20:50:41 mythtv kernel: EIP: [<e1ca7319>] ivtvfb_init_card+0x1c1/0x648 [ivtvfb] SS:ESP 0068:d786ae38
Mar 18 20:50:41 mythtv kernel: ---[ end trace df794ec1acd2a221 ]---

--Boundary-00=_u6d4HZcVvY9sTu8
Content-Type: application/octet-stream;
  name="madwifi_stack_trace.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="madwifi_stack_trace.txt"

sysctl table check failed: /dev/ath .7.9 Unknown sysctl binary path
Pid: 886, comm: modprobe Tainted: P        2.6.24.3-34.fc8 #1
 [<c0442e43>] set_fail+0x3b/0x43
 [<c044325a>] sysctl_check_table+0x40f/0x460
 [<c04352d5>] sysctl_head_finish+0x18/0x22
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c0435536>] register_sysctl_table+0x45/0x7e
 [<e09fa86b>] ath_sysctl_register+0x1d/0x2d [ath_pci]
 [<e0887051>] init_ath_pci+0x51/0x57 [ath_pci]
 [<c044d204>] sys_init_module+0x14d6/0x15f9
 [<c0488e3b>] do_sync_read+0xc7/0x10a
 [<c0434db9>] proc_dointvec_minmax+0x0/0x45
 [<c04051da>] syscall_call+0x7/0xb
 =======================
sysctl table check failed: /dev/ath/debug .7.9.-2 Unknown sysctl binary path
Pid: 886, comm: modprobe Tainted: P        2.6.24.3-34.fc8 #1
 [<c0442e43>] set_fail+0x3b/0x43
 [<c044325a>] sysctl_check_table+0x40f/0x460
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c04352d5>] sysctl_head_finish+0x18/0x22
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c0435536>] register_sysctl_table+0x45/0x7e
 [<e09fa86b>] ath_sysctl_register+0x1d/0x2d [ath_pci]
 [<e0887051>] init_ath_pci+0x51/0x57 [ath_pci]
 [<c044d204>] sys_init_module+0x14d6/0x15f9
 [<c0488e3b>] do_sync_read+0xc7/0x10a
 [<c0434db9>] proc_dointvec_minmax+0x0/0x45
 [<c04051da>] syscall_call+0x7/0xb
 =======================
sysctl table check failed: /dev/ath/countrycode .7.9.-2 Unknown sysctl binary path
Pid: 886, comm: modprobe Tainted: P        2.6.24.3-34.fc8 #1
 [<c0442e43>] set_fail+0x3b/0x43
 [<c044325a>] sysctl_check_table+0x40f/0x460
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c04352d5>] sysctl_head_finish+0x18/0x22
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c0435536>] register_sysctl_table+0x45/0x7e
 [<e09fa86b>] ath_sysctl_register+0x1d/0x2d [ath_pci]
 [<e0887051>] init_ath_pci+0x51/0x57 [ath_pci]
 [<c044d204>] sys_init_module+0x14d6/0x15f9
 [<c0488e3b>] do_sync_read+0xc7/0x10a
 [<c0434db9>] proc_dointvec_minmax+0x0/0x45
 [<c04051da>] syscall_call+0x7/0xb
 =======================
sysctl table check failed: /dev/ath/outdoor .7.9.-2 Unknown sysctl binary path
Pid: 886, comm: modprobe Tainted: P        2.6.24.3-34.fc8 #1
 [<c0442e43>] set_fail+0x3b/0x43
 [<c044325a>] sysctl_check_table+0x40f/0x460
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c04352d5>] sysctl_head_finish+0x18/0x22
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c0435536>] register_sysctl_table+0x45/0x7e
 [<e09fa86b>] ath_sysctl_register+0x1d/0x2d [ath_pci]
 [<e0887051>] init_ath_pci+0x51/0x57 [ath_pci]
 [<c044d204>] sys_init_module+0x14d6/0x15f9
 [<c0488e3b>] do_sync_read+0xc7/0x10a
 [<c0434db9>] proc_dointvec_minmax+0x0/0x45
 [<c04051da>] syscall_call+0x7/0xb
 =======================
sysctl table check failed: /dev/ath/xchanmode .7.9.-2 Unknown sysctl binary path
Pid: 886, comm: modprobe Tainted: P        2.6.24.3-34.fc8 #1
 [<c0442e43>] set_fail+0x3b/0x43
 [<c044325a>] sysctl_check_table+0x40f/0x460
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c04352d5>] sysctl_head_finish+0x18/0x22
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c0435536>] register_sysctl_table+0x45/0x7e
 [<e09fa86b>] ath_sysctl_register+0x1d/0x2d [ath_pci]
 [<e0887051>] init_ath_pci+0x51/0x57 [ath_pci]
 [<c044d204>] sys_init_module+0x14d6/0x15f9
 [<c0488e3b>] do_sync_read+0xc7/0x10a
 [<c0434db9>] proc_dointvec_minmax+0x0/0x45
 [<c04051da>] syscall_call+0x7/0xb
 =======================
sysctl table check failed: /dev/ath/calibrate .7.9.-2 Missing strategy
Pid: 886, comm: modprobe Tainted: P        2.6.24.3-34.fc8 #1
 [<c0442e43>] set_fail+0x3b/0x43
 [<c0443246>] sysctl_check_table+0x3fb/0x460
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c04352d5>] sysctl_head_finish+0x18/0x22
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c0435536>] register_sysctl_table+0x45/0x7e
 [<e09fa86b>] ath_sysctl_register+0x1d/0x2d [ath_pci]
 [<e0887051>] init_ath_pci+0x51/0x57 [ath_pci]
 [<c044d204>] sys_init_module+0x14d6/0x15f9
 [<c0488e3b>] do_sync_read+0xc7/0x10a
 [<c0434db9>] proc_dointvec_minmax+0x0/0x45
 [<c04051da>] syscall_call+0x7/0xb
 =======================
sysctl table check failed: /dev/ath/calibrate .7.9.-2 Unknown sysctl binary path
Pid: 886, comm: modprobe Tainted: P        2.6.24.3-34.fc8 #1
 [<c0442e43>] set_fail+0x3b/0x43
 [<c044325a>] sysctl_check_table+0x40f/0x460
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c04352d5>] sysctl_head_finish+0x18/0x22
 [<c044326e>] sysctl_check_table+0x423/0x460
 [<c0435536>] register_sysctl_table+0x45/0x7e
 [<e09fa86b>] ath_sysctl_register+0x1d/0x2d [ath_pci]
 [<e0887051>] init_ath_pci+0x51/0x57 [ath_pci]
 [<c044d204>] sys_init_module+0x14d6/0x15f9
 [<c0488e3b>] do_sync_read+0xc7/0x10a
 [<c0434db9>] proc_dointvec_minmax+0x0/0x45
 [<c04051da>] syscall_call+0x7/0xb
 =======================
ivtv:  End initialization
BUG: unable to handle kernel NULL pointer dereference at virtual address 0000005c
printing eip: e0a29344 *pde = 1f975067 *pte = 00000000 
Oops: 0000 [#1] SMP 
Modules linked in: ath5k mac80211 cfg80211 msp3400 saa7127 saa7115 tuner tea5767 tda8290 tuner_simple mt20xx tea5761 wlan_scan_sta(U) ath_rate_sample(U) snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq ivtv snd_seq_device i2c_algo_bit snd_pcm_oss cx2341x snd_mixer_oss ath_pci(U) tveeprom videodev wlan(U) v4l2_common snd_pcm ath_hal(P)(U) v4l1_compat snd_timer snd button soundcore forcedeth pcspkr i2c_nforce2 snd_page_alloc parport_pc parport i2c_core sr_mod sg cdrom sata_nv ata_generic pata_amd pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd

Pid: 1183, comm: udevd Tainted: P        (2.6.24.3-34.fc8 #1)
EIP: 0060:[<e0a29344>] EFLAGS: 00210246 CPU: 0
EIP is at ieee80211_sysctl_vdetach+0x92/0xc7 [wlan]
EAX: 00000000 EBX: 00000000 ECX: dec74c00 EDX: 0000001d
ESI: dede5480 EDI: 00000000 EBP: e0a0b294 ESP: ddb88e74
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process udevd (pid: 1183, ti=ddb88000 task=df03d3b0 task.ti=ddb88000)
Stack: dede5000 fffffff5 e0a29858 e0a39b80 c062dcc9 dede5000 0000000a dede5000 
       ffffffff dede5010 13fe96ac c0442a0c ffffffff 00000000 c05c7f68 c05bf3c7 
       dede5000 ddb88f30 ddb88ec8 c08480a0 00000000 30687461 00000000 00000000 
Call Trace:
 [<e0a29858>] ieee80211_rcv_dev_event+0x23/0x32 [wlan]
 [<c062dcc9>] notifier_call_chain+0x2a/0x47
 [<c0442a0c>] raw_notifier_call_chain+0x17/0x1a
 [<c05c7f68>] dev_change_name+0x1be/0x1fb
 [<c05bf3c7>] sk_prot_alloc+0x1c/0x86
 [<c05c86dd>] dev_ioctl+0x4b9/0x59e
 [<c0606fe0>] inet_create+0x202/0x290
 [<c0497d04>] d_instantiate+0x37/0x4b
 [<c05bce6a>] sock_attach_fd+0x71/0x9c
 [<c05bc796>] sock_ioctl+0x0/0x1d7
 [<c0493253>] do_ioctl+0x1f/0x62
 [<c04934cd>] vfs_ioctl+0x237/0x249
 [<c0493524>] sys_ioctl+0x45/0x5d
 [<c04051da>] syscall_call+0x7/0xb
 =======================
Code: a3 e0 01 75 1a 8b 15 c0 80 84 c0 b8 cc 08 a3 e0 e8 12 1b a9 df c7 05 b8 ae a3 e0 00 00 00 00 ff 0d b4 ae a3 e0 8b 86 9c 00 00 00 <8b> 40 5c 85 c0 74 12 e8 92 bf a5 df 8b 86 9c 00 00 00 c7 40 5c 
EIP: [<e0a29344>] ieee80211_sysctl_vdetach+0x92/0xc7 [wlan] SS:ESP 0068:ddb88e74
---[ end trace 0080b38e92e6831a ]---

--Boundary-00=_u6d4HZcVvY9sTu8--
