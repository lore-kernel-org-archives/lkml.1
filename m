Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbYE3UhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbYE3UhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYE3Ug6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:36:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:50026 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYE3Ugz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:36:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jrqMU5ihgvjDAwi96RjOK/TTv4GUthVbQM3pqE3oTqicX6YWmipayb7uA169NIl7tbLOVWdEzPSMlrLuNI7Dg3Bmwi+TW92Qz5hoBlyBXMWRnvK20OPmpmykWislPD2Kh6DQf5d7iacEQ5QeuHJ9vBa7tPeSevbnTYI9/2HD+8E=
Message-ID: <69e28c910805301336m319f6134i11f999d56b740314@mail.gmail.com>
Date: Fri, 30 May 2008 22:36:52 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: "BUG: unable to handle kernel paging request" on shutdown or killing NetworkManager in latest wireless-testing (with rt73usb wireless adapter)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have just compiled a kernel from wireless-testing (32-bit x86), and
I get this during shutdown or if I kill NetworkManager (blacklisting
rt73usb fixes it):

BUG: unable to handle kernel paging request at 0000759d
IP: [<f8ac8f77>] :usbcore:usb_kill_urb+0x17/0xd0
*pdpt = 00000000354d2001 *pde = 0000000000000000
Oops: 0000 [#1] SMP
Modules linked in: ocfs2_dlmfs ocfs2_dlm ocfs2_nodemanager configfs
ipv6 af_packet microcode rfkill_input binfmt_misc snd_pcm_oss
snd_mixer_oss snd_seq snd_seq_device fuse ext3 jbd mbcache loop dm_mod
b43 arc4 ecb crypto_blkcipher rt73usb crc_itu_t ssb rt2x00usb pcmcia
rt2x00lib zd1211rw pcmcia_core sata_nv nvidia(P) forcedeth isp1760
sr_mod firmware_class ohci1394 button agpgart cdrom rfkill led_class
ieee1394 snd_hda_intel snd_aw2 i2c_nforce2 snd_hwdep snd_pcm snd_timer
i2c_core snd snd_page_alloc input_polldev mac80211 soundcore joydev
cfg80211 sg usbhid hid ff_memless ehci_hcd ohci_hcd sd_mod usbcore edd
reiserfs fan pata_amd libata scsi_mod dock thermal processor [last
unloaded: speedstep_lib]

Pid: 2280, comm: NetworkManager Tainted: P          (2.6.26-rc4-wl-wireless6 #8)
EIP: 0060:[<f8ac8f77>] EFLAGS: 00010202 CPU: 0
EIP is at usb_kill_urb+0x17/0xd0 [usbcore]
EAX: 00000000 EBX: 00007575 ECX: f8ae2e18 EDX: f7dce8c8
ESI: 00000002 EDI: f5668e60 EBP: f786bab4 ESP: f786ba98
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process NetworkManager (pid: 2280, ti=f786a000 task=f6162550 task.ti=f786a000)
Stack: 00000000 f6162550 c0143650 f786baa4 f786baa4 00000028 00000002 f786badc
       f8b2ac73 00000000 00000000 00000000 00000000 000001f4 f786bb40 f5471500
       f5668e60 f786bb50 f8bd1998 00003064 f786bb40 00000004 000001f4 c01403a9
Call Trace:
 [<c0143650>] ? autoremove_wake_function+0x0/0x50
 [<f8b2ac73>] ? rt2x00usb_disable_radio+0xa3/0xc0 [rt2x00usb]
 [<f8bd1998>] ? rt73usb_set_device_state+0x7d8/0x10c0 [rt73usb]
 [<c01403a9>] ? __cancel_work_timer+0x79/0x180
 [<c034d16d>] ? _spin_unlock_bh+0xd/0x10
 [<f8d42265>] ? fib6_run_gc+0x85/0xf0 [ipv6]
 [<f8b15a6c>] ? rt2x00lib_disable_radio+0x4c/0xa0 [rt2x00lib]
 [<f8b15ec4>] ? rt2x00lib_stop+0x14/0x50 [rt2x00lib]
 [<f8b168ad>] ? rt2x00mac_stop+0x1d/0x30 [rt2x00lib]
 [<f89cb5e6>] ? ieee80211_stop+0x106/0x3b0 [mac80211]
 [<c02d5a07>] ? dev_close+0x57/0xa0
 [<c02d3ec0>] ? dev_set_rx_mode+0x40/0x50
 [<c02d5655>] ? dev_change_flags+0x85/0x1b0
 [<c02ee071>] ? __nla_reserve+0x21/0x60
 [<c02dd695>] ? do_setlink+0x1c5/0x360
 [<c02ddd2e>] ? rtnl_fill_ifinfo+0x26e/0x4d0
 [<c02dd911>] ? rtnl_setlink+0xe1/0x120
 [<c02ec740>] ? netlink_dump_start+0x130/0x170
 [<c02dd830>] ? rtnl_setlink+0x0/0x120
 [<c02de835>] ? rtnetlink_rcv_msg+0x165/0x200
 [<c02d5411>] ? netdev_run_todo+0x181/0x260
 [<c0219fc6>] ? copy_to_user+0x36/0x120
 [<c02de6d0>] ? rtnetlink_rcv_msg+0x0/0x200
 [<c02edd66>] ? netlink_rcv_skb+0x76/0xa0
 [<c02de6bc>] ? rtnetlink_rcv+0x1c/0x30
 [<c02ed7fb>] ? netlink_unicast+0x25b/0x270
 [<c02ed9db>] ? netlink_sendmsg+0x1cb/0x2d0
 [<c02c86af>] ? sock_sendmsg+0xff/0x120
 [<c0143650>] ? autoremove_wake_function+0x0/0x50
 [<c0143650>] ? autoremove_wake_function+0x0/0x50
 [<c0219e95>] ? copy_from_user+0x35/0x130
 [<c02d0240>] ? verify_iovec+0x30/0xb0
 [<c02c87e1>] ? sys_sendmsg+0x111/0x230
 [<c02c91a5>] ? sys_sendto+0xa5/0xd0
 [<c01a244c>] ? path_walk+0x9c/0xb0
 [<c012377a>] ? __dequeue_entity+0x2a/0xb0
 [<c0123b56>] ? set_next_entity+0x126/0x160
 [<c010273e>] ? __switch_to+0x9e/0x150
 [<c0126308>] ? hrtick_set+0x68/0x110
 [<c034af28>] ? schedule+0x3f8/0x850
 [<c02c9a51>] ? sys_socketcall+0xb1/0x290
 [<c0103e57>] ? sysenter_past_esp+0x78/0xb1
 =======================
Code: 1f 84 00 00 00 00 00 90 5b 5e 5d c3 90 8d b4 26 00 00 00 00 55
89 e5 56 53 89 c3 83 ec 14 e8 01 25 88 c7 85 db 0f 84 aa 00 00 00 <8b>
43 28 85 c0 0f 84 9f 00 00 00 8b 43 2c 85 c0 0f 84 94 00 00
EIP: [<f8ac8f77>] usb_kill_urb+0x17/0xd0 [usbcore] SS:ESP 0068:f786ba98
---[ end trace 0d4bdd5ddcc65275 ]---
