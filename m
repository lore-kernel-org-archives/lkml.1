Return-Path: <linux-kernel-owner+w=401wt.eu-S933817AbXCNElh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbXCNElh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 00:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933820AbXCNElh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 00:41:37 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:58200 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933817AbXCNElf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 00:41:35 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: linux-kernel@vger.kernel.org
Subject: Ooops with suspend to RAM
Date: Wed, 14 Mar 2007 06:42:28 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703140642.28390.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

With latest GIT tree I am getting the following oops when I try to suspend to 
RAM:

BUG: unable to handle kernel NULL pointer dereference at virtual address 
00000094
 printing eip:
c0222af4
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: i915 drm snd_pcm_oss snd_mixer_oss snd_seq_dummy 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device usbhid eth1394 ipw2200 
ieee80211 ieee80211_crypt snd_hda_intel snd_hda_codec snd_pcm snd_timer snd 
snd_page_alloc tifm_7xx1 tifm_core i2c_i801 i2c_core ehci_hcd uhci_hcd 
ohci1394 ieee1394 pcmcia usbcore yenta_socket rsrc_nonstatic pcmcia_core 
sony_laptop backlight
CPU:    0
EIP:    0060:[<c0222af4>]    Not tainted VLI
EFLAGS: 00010246   (2.6.21-rc3 #12)
EIP is at class_device_remove_attrs+0xa/0x30
eax: f7cb5b18   ebx: 00000000   ecx: f8bde010   edx: 00000000
esi: 00000000   edi: f7cb5b18   ebp: 00000000   esp: d93e7e1c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process modprobe (pid: 12200, ti=d93e6000 task=e5770a50 task.ti=d93e6000)
Stack: f7cb5b18 f7cb5b20 00000000 c0222bc3 f7cb5990 00000000 f7cb5b18 f7cb59c4
       f8bcdc0f 00000000 c0222bfb f7cb5990 f8bcdbf6 f8bd3275 04e2c100 0000000f
       000003c3 f8dcf05f 00000000 f7e3e000 00000000 f8bcdc17 c0220567 f7e3e0a4
Call Trace:
 [<c0222bc3>] class_device_del+0xa9/0xd9
 [<f8bcdc0f>] __nodemgr_remove_host_dev+0x0/0xb [ieee1394]
 [<c0222bfb>] class_device_unregister+0x8/0x10
 [<f8bcdbf6>] nodemgr_remove_ne+0x61/0x7a [ieee1394]
 [<f8dcf05f>] ether1394_mac_addr+0x0/0x12 [eth1394]
 [<f8bcdc17>] __nodemgr_remove_host_dev+0x8/0xb [ieee1394]
 [<c0220567>] device_for_each_child+0x1a/0x3c
 [<f8bcdf34>] nodemgr_remove_host+0x30/0x90 [ieee1394]
 [<f8bcb4b1>] __unregister_host+0x1a/0xac [ieee1394]
 [<c0125e1c>] flush_cpu_workqueue+0x98/0xb7
 [<f8bcb6da>] highlevel_remove_host+0x21/0x42 [ieee1394]
 [<f8bcb247>] hpsb_remove_host+0x37/0x58 [ieee1394]
 [<f8be1229>] ohci1394_pci_remove+0x47/0x1ec [ohci1394]
 [<c01877b9>] sysfs_hash_and_remove+0xfa/0x111
 [<c01ccc9c>] pci_device_remove+0x16/0x35
 [<c0222321>] __device_release_driver+0x6e/0x8b
 [<c022279b>] driver_detach+0x99/0xda
 [<c0221fa2>] bus_remove_driver+0x57/0x75
 [<c02227fd>] driver_unregister+0x8/0x13
 [<c01ccdfd>] pci_unregister_driver+0xc/0x67
 [<c0134133>] sys_delete_module+0x15c/0x19d
 [<c0149fc0>] remove_vma+0x31/0x36
 [<c014a946>] do_munmap+0x19b/0x1b4
 [<c0104cca>] sysenter_past_esp+0x5f/0x85
 [<c0300000>] packet_notifier+0xf3/0x157
 =======================
Code: ff c3 85 c0 74 08 83 c0 08 e9 83 6d f6 ff b8 ea ff ff ff c3 85 c0 74 08 
83 c0 08 e9 4c 51 f6 ff c3 57 89 c7 56 53 8b 70 44 31 db <83> be 94 00 00 00 
00 75 09 eb 17 89 f8 e8 d7 ff ff ff 89 da 83
EIP: [<c0222af4>] class_device_remove_attrs+0xa/0x30 SS:ESP 0068:d93e7e1c


Checking Google I see a similar oops was reported long ago: 
http://lkml.org/lkml/2006/11/16/147 .

Any ideas/patches to test? Please CC me in your replies.

Thanks.

-- 
Happiness in intelligent people is the rarest thing I know. (Ernest Hemingway)

Ismail Donmez ismail (at) pardus.org.tr
GPG Fingerprint: 7ACD 5836 7827 5598 D721 DF0D 1A9D 257A 5B88 F54C
Pardus Linux / KDE developer
