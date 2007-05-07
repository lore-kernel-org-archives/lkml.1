Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbXEGHmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbXEGHmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 03:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbXEGHmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 03:42:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbXEGHmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 03:42:46 -0400
Date: Mon, 7 May 2007 09:40:45 +0200
From: Stefan Seyfried <seife@suse.de>
To: BlueZ users <bluez-users@lists.sourceforge.net>
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.de
Subject: Re: [Bluez-users] OOPS when swsusp/resume when connected to the internet via BT and GPRS
Message-ID: <20070507074045.GA1308@suse.de>
References: <200705070005.33834.cijoml@volny.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <200705070005.33834.cijoml@volny.cz>
X-Operating-System: openSUSE 10.3 (i586) Alpha3plus, Kernel 2.6.21-2-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 12:05:33AM +0200, CIJOML wrote:
> Hi all,
> 
> today I experienced OOPS when connected via BT/GPRS to the internet, then 
> swsup and resumed with dongle in HID proxy mode. Please see details in dmesg 
> log:

I got two similar looking oopsen when my mobile phone crashed and thus
went away while i was connected via BT/3G.
The second oops happend when trying to reconnect.

 BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000c
 printing eip:
c01a0dce
*pde = 00000000
Oops: 0000 [#1]
SMP 
last sysfs file: devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
Modules linked in: xfrm_user xfrm4_tunnel af_key ppp_deflate bsd_comp ppp_async crc_ccitt rfcomm hidp l2cap hci_usb button r8169 pcmcia firmware_class yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd ehci_hcd kqemu nfs lockd nfs_acl sunrpc nls_iso8859_1 nls_cp437 vfat fat usb_storage xfrm4_mode_tunnel deflate zlib_deflate camellia serpent blowfish xcbc crypto_null tunnel4 ipcomp esp4 ah4 aes des md5 sha1 sha256 autofs4 michael_mic arc4 ecb ieee80211_crypt_tkip bluetooth i915 drm ppp_generic slhc af_packet ipv6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib freq_table bay dock pcc_acpi battery ac apparmor cbc blkcipher twofish twofish_common usbhid hid ff_memless ohci_hcd dm_crypt ext2 loop dm_mod fuse generic rtc_cmos piix ieee80211 ieee80211_crypt rtc_core rtc_lib ide_core ohci1394 ieee1394 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore iTCO_wdt iTCO_vendor_support snd_page_alloc i2c_i801 i2c_core usbcore joydev shpchp pci_hotplug intel_agp agpgart parport_pc lp parport ext3 mbcache jbd sr_mod cdrom sg edd fan ata_piix libata thermal processor sd_mod scsi_mod
CPU:    0
EIP:    0060:[<c01a0dce>]    Tainted: G      N VLI
EFLAGS: 00010282   (2.6.21-2-default #1)
EIP is at sysfs_move_dir+0x3e/0x117
eax: 00000000   ebx: f1e3db40   ecx: c6573e74   edx: dff9b840
esi: dfc01cf0   edi: 00000000   ebp: dff9b840   esp: c6573e48
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process pppd (pid: 30673, ti=c6572000 task=dfe3da90 task.ti=c6572000)
Stack: c0300758 e54ff878 00000000 fffffff4 f1e3db40 e54ff878 fffffff4 dff9b840 
       c01c4481 dff353c0 c030074a f1e3db40 dff353c0 dff353c0 00000000 00000000 
       e54ff800 00000000 dff9b840 c02291a7 e54ff878 f1e3ddc0 f3caa800 00000000 
Call Trace:
 [<c01c4481>] kobject_move+0xad/0xf8
 [<c02291a7>] device_move+0x49/0xd7
 [<f930048e>] rfcomm_tty_close+0x23/0x76 [rfcomm]
 [<c021202d>] release_dev+0x1df/0x5d4
 [<c01048fb>] do_notify_resume+0x4e3/0x5da
 [<c0212431>] tty_release+0xf/0x18
 [<c01695ef>] __fput+0xac/0x162
 [<c016718d>] filp_close+0x51/0x58
 [<c0168136>] sys_close+0x6e/0xa5
 [<c0104d14>] sysenter_past_esp+0x5d/0x89
 =======================
Code: 40 30 eb 0b a1 84 27 3e c0 8b 40 14 8b 40 38 85 d2 89 44 24 08 74 05 8b 72 30 eb 0b a1 84 27 3e c0 8b 40 14 8b 70 38 8b 7c 24 08 <8b> 47 0c 31 ff 3b 46 0c 0f 84 c1 00 00 00 8b 54 24 08 8b 42 0c 
EIP: [<c01a0dce>] sysfs_move_dir+0x3e/0x117 SS:ESP 0068:c6573e48
NET: Unregistered protocol family 15
BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000c
 printing eip:
c01a0dce
*pde = 00000000
Oops: 0000 [#2]
SMP 
last sysfs file: devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
Modules linked in: ppp_deflate bsd_comp ppp_async crc_ccitt rfcomm hidp l2cap hci_usb button r8169 pcmcia firmware_class yenta_socket rsrc_nonstatic pcmcia_core uhci_hcd ehci_hcd kqemu nfs lockd nfs_acl sunrpc nls_iso8859_1 nls_cp437 vfat fat usb_storage xfrm4_mode_tunnel deflate zlib_deflate camellia serpent blowfish xcbc crypto_null tunnel4 ipcomp esp4 ah4 aes des md5 sha1 sha256 autofs4 michael_mic arc4 ecb ieee80211_crypt_tkip bluetooth i915 drm ppp_generic slhc af_packet ipv6 snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib freq_table bay dock pcc_acpi battery ac apparmor cbc blkcipher twofish twofish_common usbhid hid ff_memless ohci_hcd dm_crypt ext2 loop dm_mod fuse generic rtc_cmos piix ieee80211 ieee80211_crypt rtc_core rtc_lib ide_core ohci1394 ieee1394 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd soundcore iTCO_wdt iTCO_vendor_support snd_page_alloc i2c_i801 i2c_core usbcore joydev shpchp pci_hotplug intel_agp agpgart parport_pc lp parport ext3 mbcache jbd sr_mod cdrom sg edd fan ata_piix libata thermal processor sd_mod scsi_mod
CPU:    0
EIP:    0060:[<c01a0dce>]    Tainted: G      N VLI
EFLAGS: 00010282   (2.6.21-2-default #1)
EIP is at sysfs_move_dir+0x3e/0x117
eax: 00000000   ebx: dfcda3c0   ecx: dde11e4c   edx: d05cc508
esi: d338f7c8   edi: 00000000   ebp: d05cc508   esp: dde11e20
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process pppd (pid: 32701, ti=dde10000 task=f7be9a90 task.ti=dde10000)
Stack: c0300758 e54ff878 00000000 fffffff4 dfcda3c0 e54ff878 fffffff4 d05cc508 
       c01c4481 dff35240 c030074a dfcda3c0 dff35240 dff35240 00000000 d05cc490 
       e54ff800 d05cc490 d05cc508 c02291a7 e54ff878 d35a6c00 d05cc400 f1e3ddc0 
Call Trace:
 [<c01c4481>] kobject_move+0xad/0xf8
 [<c02291a7>] device_move+0x49/0xd7
 [<f9300c68>] rfcomm_tty_open+0x1a8/0x1b4 [rfcomm]
 [<c011c58d>] default_wake_function+0x0/0xc
 [<c0213469>] tty_open+0x170/0x2be
 [<c016ae6c>] chrdev_open+0x120/0x13b
 [<c016ad4c>] chrdev_open+0x0/0x13b
 [<c016730d>] __dentry_open+0xc3/0x17a
 [<c016743e>] nameidata_to_filp+0x24/0x33
 [<c0167484>] do_filp_open+0x37/0x3e
 [<c01c3b5a>] _atomic_dec_and_lock+0x2a/0x44
 [<c01671e4>] get_unused_fd+0x50/0xb6
 [<c01674d1>] do_sys_open+0x46/0xc8
 [<c016758c>] sys_open+0x1c/0x1e
 [<c0104d14>] sysenter_past_esp+0x5d/0x89
 [<c02a0000>] ip_mroute_setsockopt+0x4ea/0x7cf
 =======================
Code: 40 30 eb 0b a1 84 27 3e c0 8b 40 14 8b 40 38 85 d2 89 44 24 08 74 05 8b 72 30 eb 0b a1 84 27 3e c0 8b 40 14 8b 70 38 8b 7c 24 08 <8b> 47 0c 31 ff 3b 46 0c 0f 84 c1 00 00 00 8b 54 24 08 8b 42 0c 
EIP: [<c01a0dce>] sysfs_move_dir+0x3e/0x117 SS:ESP 0068:dde11e20
-- 
Stefan Seyfried

"Any ideas, John?"
"Well, surrounding them's out." 
