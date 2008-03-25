Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYCYXJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYCYXJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760417AbYCYXIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:08:55 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:51455 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758023AbYCYXIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:08:54 -0400
Date: Wed, 26 Mar 2008 00:08:48 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.25-rc6: BUG: unable to handle kernel NULL pointer dereference
Message-ID: <alpine.DEB.1.00.0803252358340.22105@sheep.housecafe.de>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.25-rc6 is a strong beast :)
Another[0] BUG is printed and the box is still alive:

BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<c0179114>] __d_lookup+0x94/0x150
*pde = 00000000 
Oops: 0000 [#1] 
Modules linked in: fuse sha256_generic xt_tcpudp ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_nat_ftp nf_nat nf_conntrack_ftp xt_conntrack nf_conntrack iptable_filter ip_tables ipt_ULOG x_tables nfsd lockd nfs_acl auth_rpcgss exportfs tun sunrpc twofish_i586 twofish_common eeprom w83l785ts asb100 hwmon_vid usb_storage zd1211rw firmware_class mac80211 snd_intel8x0 snd_ac97_codec i2c_nforce2 cfg80211 ac97_bus snd_pcm snd_timer snd soundcore snd_page_alloc i2c_core [last unloaded: fuse]
Pid: 15705, comm: imap Not tainted (2.6.25-rc6 #5)
EIP: 0060:[<c0179114>] EFLAGS: 00010286 CPU: 0
EIP is at __d_lookup+0x94/0x150
EAX: 00000000 EBX: 0006bc44 ECX: 00000001 EDX: d60634e8
ESI: c2020a00 EDI: c56ebf30 EBP: c478ad6c ESP: c56ebd7c
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process imap (pid: 15705, ti=c56eb000 task=e153c000 task.ti=c56eb000)
Stack: 00000002 00000001 c0179080 f4826be0 00000246 c56ebe08 0000000b f66a800b
        d60634e8 c56ebe08 0000002f c56ebf30 c56ebe08 c016f388 c56ebe14 f7faff80
        c016ee97 01eb3b48 c56ebe08 0000002f c56ebe14 f66a8017 c0170a70 c56ebf30 
Call Trace:
  [<c0179080>] __d_lookup+0x0/0x150
  [<c016f388>] do_lookup+0x28/0x1a0
  [<c016ee97>] permission+0xb7/0x120
  [<c0170a70>] __link_path_walk+0x140/0xcd0
  [<c043f5e4>] _spin_unlock+0x14/0x20
  [<c02c3e1a>] _atomic_dec_and_lock+0x2a/0x40
  [<c0179855>] dput+0x65/0xf0
  [<c017163a>] link_path_walk+0x3a/0xa0
  [<c043f5e4>] _spin_unlock+0x14/0x20
  [<c01662bb>] get_unused_fd_flags+0xab/0xd0
  [<c017189e>] do_path_lookup+0x6e/0x180
  [<c0169088>] get_empty_filp+0xa8/0x120
  [<c01724b1>] __path_lookup_intent_open+0x51/0xa0
  [<c0172590>] path_lookup_open+0x20/0x30
  [<c0172686>] open_namei+0x66/0x5f0
  [<c01665ae>] do_filp_open+0x2e/0x60
  [<c043f5e4>] _spin_unlock+0x14/0x20
  [<c01662bb>] get_unused_fd_flags+0xab/0xd0
  [<c016662c>] do_sys_open+0x4c/0xe0
  [<c01666fc>] sys_open+0x1c/0x20
  [<c0102dee>] sysenter_past_esp+0x5f/0xa5
  =======================
Code: 53 c0 e8 20 08 fc ff c1 e3 02 8b 14 33 89 54 24 20 8b 44 24 20 85 c0 75 10 eb 51 8b 12 89 54 24 20 8b 44 24 20 85 c0 74 43 8b 02 <0f> 18 00 90 8d 5a d8 39 6b 34 75 e4 8b 7c 24 0c 39 7b 30 75 db 
EIP: [<c0179114>] __d_lookup+0x94/0x150 SS:ESP 0068:c56ebd7c
---[ end trace 274145890e21aa9a ]---


I've put some more details (.config, dmesg, some sysrq printouts) on:
http://nerdbynature.de/bits/2.6.25-rc6/Oops_d_lookup/

Please tell me not to worry :)
Christian.

[0] http://lkml.org/lkml/2008/3/23/245
-- 
BOFH excuse #85:

Windows 95 undocumented "feature"
