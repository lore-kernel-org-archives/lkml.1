Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZHJU05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZHJU05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbZHJU04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:26:56 -0400
Received: from dd15922.kasserver.com ([85.13.137.18]:46126 "EHLO
	dd15922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZHJU04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:26:56 -0400
To: linux-kernel@vger.kernel.org
Subject: Oops w/ 2.6.31-rc5-git5
From: Matthias Dahl <ml_kernel@mortal-soul.de>
Date: Mon, 10 Aug 2009 22:26:53 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200908102226.53429.ml_kernel@mortal-soul.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I gave 2.6.31-rc5-git5 a whirl today for various reasons and ran into the 
following oops two times which both resulted in file corruption w/ ext4 (files 
getting mixed together) because the system crashed or behaved erratic and 
required some magic work. Both times, I had a few compile jobs running in the 
background and KDE 4.3 in the foreground with a widget that polls the CPU core 
temperatures.

BUG: unable to handle kernel paging request at 0000000208008fc6                                              
IP: [<ffffffff810ad0ae>] kmem_cache_alloc+0x4e/0xb0                                                          
PGD 224337067 PUD 0                                                                                          
Oops: 0000 [#1] PREEMPT SMP                                                                                  
last sysfs file: /sys/devices/platform/coretemp.0/temp1_label                                                
CPU 1                                                                                                        
Modules linked in: usblp xt_time xt_connlimit xt_realm iptable_raw xt_comment 
xt_policy ipt_ULOG ipt_REJECT ipt_LOG ipt_ECN ipt_ecn ipt_ah ipt_addrtype 
nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp 
nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink 
nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp 
xt_tcpmss xt_recent xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG 
nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length 
xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack 
xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp xt_state nf_conntrack_ipv4 
nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables 
x_tables coretemp tun it87 hwmon_vid snd_pcm_oss snd_mixer_oss aes_x86_64 
aes_generic xts gf128mul cx88_dvb mt352 dvb_pll s5h1411 videobuf_dvb or51132 
cx24116 nxt200x isl6421 stb6000 zl10353 cx24123 lgdt330x stv0299 dvb_core 
stv0288 cx22702 tuner tea5767 tda8290 tuner_xc2028 xc5000 tda9887 tuner_simple 
tuner_types mt20xx tea5761 cx8802 cx8800 cx88xx snd_hda_codec_realtek 
ir_common nvidia(P) i2c_algo_bit snd_virtuoso snd_hda_intel snd_oxygen_lib 
v4l2_common snd_mpu401_uart snd_hda_codec videodev snd_rawmidi 
v4l2_compat_ioctl32 tveeprom btcx_risc snd_pcm videobuf_dma_sg videobuf_core 
snd_timer snd soundcore snd_page_alloc fuse ext2 mbcache dm_snapshot dm_mirror 
dm_region_hash dm_log scsi_wait_scan usb_storage                                                                                 
Pid: 9822, comm: kded4 Tainted: P           2.6.31-rc5-git5 #1 X48-DQ6                                       
RIP: 0010:[<ffffffff810ad0ae>]  [<ffffffff810ad0ae>] 
kmem_cache_alloc+0x4e/0xb0                              
RSP: 0018:ffff880224351eb8  EFLAGS: 00010006                                                                 
RAX: 0000000000000000 RBX: 0000000208008fc6 RCX: ffffffff810e63e9                                            
RDX: ffff88002805cf00 RSI: 00000000000000d0 RDI: ffff88023f91cb00                                            
RBP: ffff880224351ed8 R08: 0000000000000000 R09: 0000000000000000                                            
R10: 00007f013082ce88 R11: 0000000000000206 R12: 00000000000000d0                                            
R13: 0000000000000202 R14: 0000000000000070 R15: 0000000000a35fc0                                            
FS:  00007f0134195740(0000) GS:ffff88002804e000(0000) knlGS:0000000000000000                                 
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                            
CR2: 0000000208008fc6 CR3: 0000000224334000 CR4: 00000000000006e0                                            
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                            
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400                                            
Process kded4 (pid: 9822, threadinfo ffff880224350000, task ffff8802395f0000)                                
Stack:                                                                                                       
00000000fffffff4 0000000000ce1b88 ffff880239470c00 00007fff6cad92e0                                          
<0> ffff880224351f78 ffffffff810e63e9 ffff8802242f02c0 02000fc600000000                                      
<0> ffff880220582e78 ffff88022305a480 ffff880224351f18 ffffffff810b36ad                                      
Call Trace:                                                                                                  
[<ffffffff810e63e9>] sys_inotify_add_watch+0xf9/0x380                                                        
[<ffffffff810b36ad>] ? fput+0x1d/0x30                                                                        
[<ffffffff810afe4b>] ? filp_close+0x5b/0x90                                                                  
[<ffffffff8100b3eb>] system_call_fastpath+0x16/0x1b                                                          
Code: 23 25 97 67 46 00 9c 41 5d fa 65 8b 04 25 10 cc 00 00 48 98 48 8b 94 c7 
e8 00 00 00 48 8b 1a 44 8b 72 18 48 85 db 74 45 8b 42 14 <48> 8b 04 c3 48 89 
02 41 55 9d 66 45 85 e4 79 12 48 85 db 74 0d                   
RIP  [<ffffffff810ad0ae>] kmem_cache_alloc+0x4e/0xb0
RSP <ffff880224351eb8>
CR2: 0000000208008fc6
---[ end trace 60de0982e598fb2d ]---
BUG: unable to handle kernel paging request at 0000000208008fc6
IP: [<ffffffff810ad0ae>] kmem_cache_alloc+0x4e/0xb0
PGD 2051cc067 PUD 0
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/platform/coretemp.0/temp1_label
CPU 0
Modules linked in: xt_time xt_connlimit xt_realm iptable_raw xt_comment 
xt_policy ipt_ULOG ipt_REJECT ipt_LOG ipt_ECN ipt_ecn ipt_ah ipt_addrtype 
nf_conntrack_sane nf_conntrack_tftp nf_conntrack_sip nf_conntrack_proto_sctp 
nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink 
nf_conntrack_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp 
xt_tcpmss xt_recent xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG 
nfnetlink_log xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length 
xt_iprange xt_helper xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack 
xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpudp xt_state nf_conntrack_ipv4 
nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink iptable_filter ip_tables 
x_tables coretemp it87 hwmon_vid tun snd_pcm_oss snd_mixer_oss aes_x86_64 
aes_generic xts gf128mul cx88_dvb mt352 dvb_pll s5h1411 videobuf_dvb or51132 
cx24116 nxt200x isl6421 stb6000 zl10353 cx24123 lgdt330x stv0299 dvb_core 
stv0288 cx22702 tuner tea5767 tda8290 tuner_xc2028 xc5000 tda9887 tuner_simple 
tuner_types mt20xx tea5761 cx8800 cx8802 cx88xx snd_hda_codec_realtek 
ir_common nvidia(P) i2c_algo_bit snd_hda_intel v4l2_common videodev 
snd_hda_codec v4l2_compat_ioctl32 tveeprom snd_virtuoso snd_oxygen_lib 
btcx_risc snd_pcm videobuf_dma_sg snd_mpu401_uart usblp videobuf_core 
snd_timer snd_rawmidi snd soundcore snd_page_alloc fuse ext2 mbcache 
dm_snapshot dm_mirror dm_region_hash dm_log scsi_wait_scan usb_storage
Pid: 9879, comm: kded4 Tainted: P           2.6.31-rc5-git5 #1 X48-DQ6
RIP: 0010:[<ffffffff810ad0ae>]  [<ffffffff810ad0ae>] 
kmem_cache_alloc+0x4e/0xb0
RSP: 0018:ffff8802051d1eb8  EFLAGS: 00010006
RAX: 0000000000000000 RBX: 0000000208008fc6 RCX: ffffffff810e63e9
RDX: ffff880028042f00 RSI: 00000000000000d0 RDI: ffff88023f91ab00
RBP: ffff8802051d1ed8 R08: 0000000000000000 R09: 0000000000000000
R10: 00007f8b7d8b8e88 R11: 0000000000000202 R12: 00000000000000d0
R13: 0000000000000202 R14: 0000000000000070 R15: 0000000001c4e100
FS:  00007f8b81224740(0000) GS:ffff880028034000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000208008fc6 CR3: 00000002051cb000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kded4 (pid: 9879, threadinfo ffff8802051d0000, task ffff88020507abc0)
Stack:
00000000fffffff4 0000000001c7a888 ffff88021e190700 00007fffd34ec060
<0> ffff8802051d1f78 ffffffff810e63e9 ffff8802051d1f78 02000fc6810b6091
<0> ffff880205957b98 ffff880205312540 0000000000000001 0000000000000000
Call Trace:
[<ffffffff810e63e9>] sys_inotify_add_watch+0xf9/0x380
[<ffffffff8100b3eb>] system_call_fastpath+0x16/0x1b
Code: 23 25 97 67 46 00 9c 41 5d fa 65 8b 04 25 10 cc 00 00 48 98 48 8b 94 c7 
e8 00 00 00 48 8b 1a 44 8b 72 18 48 85 db 74 45 8b 42 14 <48> 8b 04 c3 48 89 
02 41 55 9d 66 45 85 e4 79 12 48 85 db 74 0d
RIP  [<ffffffff810ad0ae>] kmem_cache_alloc+0x4e/0xb0
RSP <ffff8802051d1eb8>
CR2: 0000000208008fc6
---[ end trace 776a8a114a5a51d6 ]---

dreamgate ~ # uname -a ; gcc --version
Linux dreamgate 2.6.30.4 #3 SMP PREEMPT Sat Aug 8 09:32:00 CEST 2009 x86_64 
Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz GenuineIntel GNU/Linux
gcc (Gentoo 4.3.3-r2 p1.2, pie-10.1.5) 4.3.3
Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

If there is any more information I can provide, please let me know.

Best regards,
Matthias Dahl
