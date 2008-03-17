Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYCQPY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYCQPY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbYCQPYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:24:51 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52352 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYCQPYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:24:50 -0400
Date: Mon, 17 Mar 2008 16:24:49 +0100
From: Jan Kara <jack@suse.cz>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at fs/buffer.c:1183 mark_buffer_dirty
Message-ID: <20080317152448.GA31183@atrey.karlin.mff.cuni.cz>
References: <c4e36d110803141550p1d39dd6q21346aeedcf0e969@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110803141550p1d39dd6q21346aeedcf0e969@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> During  unexpected  USB disk removement:
> 
> Not sure whether is a real problem which should be reported...
  Not a real problem. We tried to mark as dirty buffer, which did not
contain uptodate data (because the device has been removed). This is
harmless. Thanks for report anyway.

								Honza
> 
> 
> hald: unmounted /dev/sdb7 from '/media/disk-3' on behalf of uid 0
> hald[2404]: forcibly attempting to lazy unmount /dev/sdb6 as enclosing
> drive was disconnected
> Buffer I/O error on device sdb6, logical block 1545
> lost page write due to I/O error on sdb6
> ------------[ cut here ]------------
> WARNING: at fs/buffer.c:1183 mark_buffer_dirty+0x87/0xa0()
> Modules linked in: reiserfs usb_storage nls_iso8859_2 nls_cp852 vfat
> fat i915 drm ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
> xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables
> x_tables bridge llc nfsd lockd nfs_acl auth_rpcgss exportfs autofs4
> sunrpc binfmt_misc dm_multipath uinput kvm_intel kvm snd_hda_intel
> arc4 ecb crypto_blkcipher snd_seq_oss cryptomgr snd_seq_midi_event
> crypto_algapi snd_seq iwl3945 mac80211 snd_seq_device snd_pcm_oss
> snd_mixer_oss snd_pcm sr_mod snd_timer i2c_i801 e1000e psmouse
> serio_raw rtc_cmos mmc_block thinkpad_acpi sdhci mmc_core cdrom snd
> rtc_core backlight cfg80211 rtc_lib iTCO_wdt button soundcore
> snd_page_alloc intel_agp nvram evdev i2c_core iTCO_vendor_support
> battery ac dm_snapshot dm_zero dm_mirror dm_mod uhci_hcd ohci_hcd
> ehci_hcd usbcore [last unloaded: microcode]
> Pid: 9475, comm: umount Not tainted 2.6.25-rc5-replic-server #54
> 
> Call Trace:
>  [warn_on_slowpath+95/144] warn_on_slowpath+0x5f/0x90
>  [finish_wait+94/128] ? finish_wait+0x5e/0x80
>  [__wait_on_bit+123/144] ? __wait_on_bit+0x7b/0x90
>  [sync_buffer+0/80] ? sync_buffer+0x0/0x50
>  [__journal_remove_journal_head+200/352] ?
> __journal_remove_journal_head+0xc8/0x160
>  [journal_update_superblock+82/240] ? journal_update_superblock+0x52/0xf0
>  [mark_buffer_dirty+135/160] mark_buffer_dirty+0x87/0xa0
>  [journal_update_superblock+136/240] journal_update_superblock+0x88/0xf0
>  [cleanup_journal_tail+164/320] cleanup_journal_tail+0xa4/0x140
>  [log_do_checkpoint+298/1392] log_do_checkpoint+0x12a/0x570
>  [find_get_pages_tag+49/192] ? find_get_pages_tag+0x31/0xc0
>  [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
>  [lock_hrtimer_base+44/96] ? lock_hrtimer_base+0x2c/0x60
>  [_spin_unlock_irqrestore+69/144] ? _spin_unlock_irqrestore+0x45/0x90
>  [hrtimer_start+225/416] ? hrtimer_start+0xe1/0x1a0
>  [__reacquire_kernel_lock+90/105] ? __reacquire_kernel_lock+0x5a/0x69
>  [finish_wait+60/128] ? finish_wait+0x3c/0x80
>  [finish_wait+60/128] ? finish_wait+0x3c/0x80
>  [journal_destroy+304/512] ? journal_destroy+0x130/0x200
>  [journal_destroy+296/512] journal_destroy+0x128/0x200
>  [autoremove_wake_function+0/64] ? autoremove_wake_function+0x0/0x40
>  [ext3_put_super+48/528] ext3_put_super+0x30/0x210
>  [generic_shutdown_super+98/256] generic_shutdown_super+0x62/0x100
>  [kill_block_super+21/48] kill_block_super+0x15/0x30
>  [deactivate_super+86/128] deactivate_super+0x56/0x80
>  [mntput_no_expire+91/144] mntput_no_expire+0x5b/0x90
>  [sys_umount+102/688] sys_umount+0x66/0x2b0
>  [_spin_unlock_irqrestore+69/144] ? _spin_unlock_irqrestore+0x45/0x90
>  [sys_newstat+39/80] ? sys_newstat+0x27/0x50
>  [lockdep_sys_exit_thunk+53/103] ? lockdep_sys_exit_thunk+0x35/0x67
>  [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
>  [system_call_after_swapgs+123/128] system_call_after_swapgs+0x7b/0x80
> 
> ---[ end trace ca143223eefdc828 ]---
> Buffer I/O error on device sdb6, logical block 1545
> lost page write due to I/O error on sdb6
> hald: unmounted /dev/sdb6 from '/media/disk-4' on behalf of uid 0
> 
> 
> Zdenek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
