Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbYCNWu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbYCNWu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 18:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbYCNWut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 18:50:49 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:7317 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbYCNWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 18:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=lhI5q5lfEBF0DoK/MiW45/oKZznoSyk6vyuVKmOccASOGH639aRN/i7T2mpXWe0p2FTzQ1CdXuLOc46LTl766nUlKZri1Nt4LwaQBy8o089sfmaSlFUGp9N3aoh3QtZ86qhrO7ZJkNCSP3/uG4LMMSWT/4/JeyipwbDJbN92jj0=
Message-ID: <c4e36d110803141550p1d39dd6q21346aeedcf0e969@mail.gmail.com>
Date: Fri, 14 Mar 2008 23:50:47 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: WARNING: at fs/buffer.c:1183 mark_buffer_dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

During  unexpected  USB disk removement:

Not sure whether is a real problem which should be reported...


hald: unmounted /dev/sdb7 from '/media/disk-3' on behalf of uid 0
hald[2404]: forcibly attempting to lazy unmount /dev/sdb6 as enclosing
drive was disconnected
Buffer I/O error on device sdb6, logical block 1545
lost page write due to I/O error on sdb6
------------[ cut here ]------------
WARNING: at fs/buffer.c:1183 mark_buffer_dirty+0x87/0xa0()
Modules linked in: reiserfs usb_storage nls_iso8859_2 nls_cp852 vfat
fat i915 drm ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables
x_tables bridge llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4
sunrpc binfmt_misc dm_multipath uinput kvm_intel kvm snd_hda_intel
arc4 ecb crypto_blkcipher snd_seq_oss cryptomgr snd_seq_midi_event
crypto_algapi snd_seq iwl3945 mac80211 snd_seq_device snd_pcm_oss
snd_mixer_oss snd_pcm sr_mod snd_timer i2c_i801 e1000e psmouse
serio_raw rtc_cmos mmc_block thinkpad_acpi sdhci mmc_core cdrom snd
rtc_core backlight cfg80211 rtc_lib iTCO_wdt button soundcore
snd_page_alloc intel_agp nvram evdev i2c_core iTCO_vendor_support
battery ac dm_snapshot dm_zero dm_mirror dm_mod uhci_hcd ohci_hcd
ehci_hcd usbcore [last unloaded: microcode]
Pid: 9475, comm: umount Not tainted 2.6.25-rc5-replic-server #54

Call Trace:
 [warn_on_slowpath+95/144] warn_on_slowpath+0x5f/0x90
 [finish_wait+94/128] ? finish_wait+0x5e/0x80
 [__wait_on_bit+123/144] ? __wait_on_bit+0x7b/0x90
 [sync_buffer+0/80] ? sync_buffer+0x0/0x50
 [__journal_remove_journal_head+200/352] ?
__journal_remove_journal_head+0xc8/0x160
 [journal_update_superblock+82/240] ? journal_update_superblock+0x52/0xf0
 [mark_buffer_dirty+135/160] mark_buffer_dirty+0x87/0xa0
 [journal_update_superblock+136/240] journal_update_superblock+0x88/0xf0
 [cleanup_journal_tail+164/320] cleanup_journal_tail+0xa4/0x140
 [log_do_checkpoint+298/1392] log_do_checkpoint+0x12a/0x570
 [find_get_pages_tag+49/192] ? find_get_pages_tag+0x31/0xc0
 [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
 [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
 [_spin_unlock_irqrestore+69/144] ? _spin_unlock_irqrestore+0x45/0x90
 [hrtimer_start+225/416] ? hrtimer_start+0xe1/0x1a0
 [__reacquire_kernel_lock+90/105] ? __reacquire_kernel_lock+0x5a/0x69
 [finish_wait+60/128] ? finish_wait+0x3c/0x80
 [finish_wait+60/128] ? finish_wait+0x3c/0x80
 [journal_destroy+304/512] ? journal_destroy+0x130/0x200
 [journal_destroy+296/512] journal_destroy+0x128/0x200
 [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
 [ext3_put_super+48/528] ext3_put_super+0x30/0x210
 [generic_shutdown_super+98/256] generic_shutdown_super+0x62/0x100
 [kill_block_super+21/48] kill_block_super+0x15/0x30
 [deactivate_super+86/128] deactivate_super+0x56/0x80
 [mntput_no_expire+91/144] mntput_no_expire+0x5b/0x90
 [sys_umount+102/688] sys_umount+0x66/0x2b0
 [_spin_unlock_irqrestore+69/144] ? _spin_unlock_irqrestore+0x45/0x90
 [sys_newstat+39/80] ? sys_newstat+0x27/0x50
 [lockdep_sys_exit_thunk+53/103] ? lockdep_sys_exit_thunk+0x35/0x67
 [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
 [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80

---[ end trace ca143223eefdc828 ]---
Buffer I/O error on device sdb6, logical block 1545
lost page write due to I/O error on sdb6
hald: unmounted /dev/sdb6 from '/media/disk-4' on behalf of uid 0


Zdenek
