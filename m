Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbYHDRIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbYHDRIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYHDRIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:08:05 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:43941 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbYHDRIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:08:04 -0400
X-Greylist: delayed 1340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2008 13:08:04 EDT
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: linux-kernel@vger.kernel.org
Subject: BUG: scheduling while atomic: ip/23212/0x00000102
Date: Mon, 4 Aug 2008 18:45:10 +0200
User-Agent: PLD Linux KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808041845.10893.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


git kernel, pulled around  Sat Aug 2 13:32:05 CEST,
i686, thinkpad z60m notebook

[119353.611650] usb 4-2: Manufacturer: STMicroelectronics
[119357.998202] BUG: scheduling while atomic: ip/23212/0x00000102
[119357.998209] Modules linked in: uhci_hcd ehci_hcd pl2303 usbserial nls_utf8 cifs radeon drm binfmt_misc deflate zlib_deflate zlib_inflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_i586 
aes_generic xcbc rmd160 sha1_generic crypto_null crypto_blkcipher af_key bridge stp llc bnep hidp nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ipv6 sch_sfq fuse lcd mmc_block rfcomm l2cap bluetooth ircomm_tty ircomm 
nsc_ircc irda crc_ccitt cpufreq_powersave cpufreq_userspace cpufreq_stats acpi_cpufreq freq_table hdaps input_polldev fan container tun pcmcia usbhid hid ff_memless joydev battery ac video output thinkpad_acpi rfkill backlight 
intel_agp agpgart led_class nvram yenta_socket rsrc_nonstatic sdhci_pci ohci1394 sdhci mmc_core ieee1394 thermal button pcmcia_core processor psmouse snd_hda_intel ipw2200 snd_pcm ieee80211 ieee80211_crypt snd_timer 
rtc_cmos rtc_core evdev i2c_i801 tg3 libphy snd_page_alloc snd_hwdep rtc_lib pcspkr i2c_core snd soundcore serio_raw usbcore iTCO_wdt iTCO_vendor_support sg sr_mod cdrom xfs scsi_wait_scan sd_mod ata_piix libata dock 
scsi_mod [last unloaded: uhci_hcd]
[119357.998401] Pid: 23212, comm: ip Not tainted 2.6.27-rc1 #29
[119357.998407]  [<c01171a3>] __schedule_bug+0x47/0x4c
[119357.998418]  [<c02ad09d>] schedule+0x72/0x440
[119357.998426]  [<c0124b84>] ? lock_timer_base+0x2a/0x5e
[119357.998436]  [<c02ad8bf>] schedule_timeout+0x73/0x91
[119357.998443]  [<c01250ea>] ? process_timeout+0x0/0xa
[119357.998450]  [<c02ad8f1>] schedule_timeout_uninterruptible+0x14/0x16
[119357.998458]  [<c01250b3>] msleep+0x10/0x16
[119357.998465]  [<c01e30ef>] pci_set_power_state+0x1be/0x295
[119357.998481]  [<f89b2ae9>] tg3_set_power_state+0x4e/0x7f8 [tg3]
[119357.998504]  [<f89bab37>] tg3_open+0x34/0x5e2 [tg3]
[119357.998520]  [<c024961b>] dev_open+0x69/0xa2
[119357.998528]  [<c024906a>] dev_change_flags+0x9c/0x14f
[119357.998535]  [<c024fef7>] do_setlink+0x242/0x2fe
[119357.998542]  [<c01172b7>] ? finish_task_switch+0x2b/0x91
[119357.998551]  [<c025101a>] rtnl_newlink+0x292/0x3fc
[119357.998558]  [<c0250de2>] ? rtnl_newlink+0x5a/0x3fc
[119357.998566]  [<c0250e22>] ? rtnl_newlink+0x9a/0x3fc
[119357.998575]  [<c0112203>] ? do_page_fault+0x0/0x609
[119357.998583]  [<c0250d88>] ? rtnl_newlink+0x0/0x3fc
[119357.998590]  [<c0250d6e>] rtnetlink_rcv_msg+0x196/0x1b0
[119357.998598]  [<c0250bd8>] ? rtnetlink_rcv_msg+0x0/0x1b0
[119357.998606]  [<c025d14e>] netlink_rcv_skb+0x30/0x76
[119357.998614]  [<c0250bd0>] rtnetlink_rcv+0x1c/0x24
[119357.998621]  [<c025ccb9>] netlink_unicast+0x1c6/0x226
[119357.998628]  [<c025cf59>] netlink_sendmsg+0x240/0x24d
[119357.998635]  [<c023e3db>] sock_sendmsg+0xdd/0xf8
[119357.998642]  [<c012db65>] ? autoremove_wake_function+0x0/0x33
[119357.998651]  [<c012db65>] ? autoremove_wake_function+0x0/0x33
[119357.998659]  [<c015ee5b>] ? __do_fault+0x288/0x2c0
[119357.998668]  [<c0244a4d>] ? verify_iovec+0x40/0x6f
[119357.998677]  [<c023e535>] sys_sendmsg+0x13f/0x192
[119357.998683]  [<c023f048>] ? sys_recvmsg+0x116/0x17b
[119357.998691]  [<c023ef1a>] ? move_addr_to_user+0x56/0x6e
[119357.998699]  [<c023f250>] ? sys_getsockname+0x59/0x76
[119357.998707]  [<c0240307>] ? lock_sock_nested+0xb5/0xbd
[119357.998714]  [<c0121cd5>] ? local_bh_enable+0x73/0x87
[119357.998722]  [<c024024a>] ? release_sock+0xa8/0xb0
[119357.998730]  [<c016296b>] ? __vma_link+0x58/0x5c
[119357.998738]  [<c01629c1>] ? vma_link+0x52/0xf6
[119357.998746]  [<c023f67d>] sys_socketcall+0x168/0x19f
[119357.998753]  [<c016399e>] ? sys_brk+0xd6/0xde
[119357.998761]  [<c0103871>] sysenter_do_call+0x12/0x21
[119357.998768]  [<c02a0000>] ? unix_inflight+0x21/0xc4
[119357.998776]  =======================
[119358.240113] ADDRCONF(NETDEV_UP): eth0: link is not ready


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
