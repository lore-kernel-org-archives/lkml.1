Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZJCDRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZJCDRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 23:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbZJCDRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 23:17:15 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:40648 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZJCDRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 23:17:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        b=GPn3DZ0pHZ1UDBDAcOUSGM+xtVouaBURj2UAMK1Bm2EfbDB+XIzsaaj78uiRb26GW8
         A+34sHbmcPgz+trukMh1P+JkB0idjrJ6GKWg3xIdPopPikx8clGBMDyYFJQ4cWJSox3l
         ajAUXsAKjOZO954Me7d6a+wPpt4CZgb6RIYeg=
Date: Fri, 2 Oct 2009 22:17:03 -0500 (CDT)
From: kevin.granade@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: WARN_ON: fs/buffer.c:1152 mark_buffer_dirty in 2.6.31-rc8-git
In-Reply-To: <alpine.LFD.2.00.0909021113330.2797@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0910022200110.14886@pc9406>
References: <alpine.LFD.2.00.0909021113330.2797@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Sep 2009, Thomas Gleixner wrote:

> The warning in fs/buffer.c 1152 triggers with the latest git on my
> laptop when I remove an USB stick. Never seen that before.
> 
> Thanks,
> 
> 	tglx
> ---
> 
> WARNING: at /home/tglx/work/kernel/git/linux-2.6/fs/buffer.c:1152 mark_buffer_dirty+0x3f/0xa5()
> Hardware name: 7661W1P
> Modules linked in: ext2 option usbserial usb_storage fuse ipt_MASQUERADE iptable_nat nf_nat sco bridge stp llc bnep l2cap bluetooth sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table dm_multipath kvm_intel kvm uinput snd_hda_codec_analog arc4 ecb iwlagn firewire_ohci firewire_core snd_hda_intel yenta_socket iwlcore crc_itu_t joydev snd_hda_codec rsrc_nonstatic mac80211 snd_hwdep snd_pcm iTCO_wdt i2c_i801 pcspkr snd_timer iTCO_vendor_support snd thinkpad_acpi cfg80211 soundcore hwmon snd_page_alloc e1000e rfkill wmi i915 drm i2c_algo_bit i2c_core video output [last unloaded: microcode]
> Pid: 26, comm: khubd Not tainted 2.6.31-rc8 #1
> Call Trace:
>  [<ffffffff810610ff>] warn_slowpath_common+0x8d/0xbb
>  [<ffffffff81061154>] warn_slowpath_null+0x27/0x3d
>  [<ffffffff81150c16>] mark_buffer_dirty+0x3f/0xa5
>  [<ffffffffa04420d5>] ext2_sync_fs+0x90/0xba [ext2]
>  [<ffffffff8114e383>] __sync_filesystem+0x65/0x90
>  [<ffffffff8114e5d0>] sync_filesystem+0x5a/0x75
>  [<ffffffff81157667>] fsync_bdev+0x37/0x6c
>  [<ffffffff8124b1aa>] invalidate_partition+0x34/0x65
>  [<ffffffff8118ad52>] del_gendisk+0x4a/0x10d
>  [<ffffffff81347465>] sd_remove+0x5f/0xb3
>  [<ffffffff81326db5>] __device_release_driver+0x79/0xd5
>  [<ffffffff81326f18>] device_release_driver+0x36/0x59
>  [<ffffffff81325e59>] bus_remove_device+0xc5/0x10a
>  [<ffffffff81323896>] device_del+0x141/0x1a6
>  [<ffffffff81342aba>] __scsi_remove_device+0x5c/0xb1
>  [<ffffffff8133f4cf>] scsi_forget_host+0x59/0x91
>  [<ffffffff813379b0>] scsi_remove_host+0x93/0x123
>  [<ffffffffa042b0d6>] quiesce_and_remove_host+0x72/0xcf [usb_storage]
>  [<ffffffffa042b241>] usb_stor_disconnect+0x2c/0x4f [usb_storage]
>  [<ffffffff8138ce3c>] usb_unbind_interface+0x7a/0x117
>  [<ffffffff81326db5>] __device_release_driver+0x79/0xd5
>  [<ffffffff81326f18>] device_release_driver+0x36/0x59
>  [<ffffffff81325e59>] bus_remove_device+0xc5/0x10a
>  [<ffffffff81323896>] device_del+0x141/0x1a6
>  [<ffffffff81389498>] usb_disable_device+0xdd/0x1fb
>  [<ffffffff81382b40>] usb_disconnect+0xfa/0x1ca
>  [<ffffffff813844bd>] hub_events+0x639/0x11e0
>  [<ffffffff813850aa>] hub_thread+0x46/0x1d0
>  [<ffffffff8107d6f3>] ? autoremove_wake_function+0x0/0x5f
>  [<ffffffff81385064>] ? hub_thread+0x0/0x1d0
>  [<ffffffff8107d270>] kthread+0xa0/0xa8
>  [<ffffffff8101409a>] child_rip+0xa/0x20
>  [<ffffffff810139fd>] ? restore_args+0x0/0x30
>  [<ffffffff8107d1d0>] ? kthread+0x0/0xa8
>  [<ffffffff81014090>] ? child_rip+0x0/0x20
> ---[ end trace ccd8dc4f063ddca9 ]---
> 

I'm not sure if this is related, but I ran into something that looks 
similar with 2.6.32-rc2 (acually rc1 of course).  It happened with my WD 
lifebook, possibly with the cable being jostled, possibly not.  It also 
seemed to have nuked the filesystem.  The following is the trace.

-Kevin Granade

[354244.308702] WARNING: at fs/buffer.c:1159 mark_buffer_dirty+0x20/0x73()
[354244.308705] Hardware name: HP Pavilion ze2000 (EA390UA#ABA)  
[354244.308708] Modules linked in: radeon ttm drm_kms_helper drm agpgart 
i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect binfmt_misc ipv6 fuse 
snd_atiixp snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_oss snd_seq_midi_event snd_seq arc4 pcmcia ecb b43 rng_core 
psmouse snd_timer yenta_socket rsrc_nonstatic evdev rtc_cmos 
snd_seq_device snd mac80211 cfg80211 rfkill rtc_core pcmcia_core rtc_lib 
led_class video soundcore snd_page_alloc i2c_piix4 i2c_core output battery 
processor ssb ac button usb_storage usb_libusual ohci_hcd ide_cd_mod 
8139too mii cdrom ehci_hcd usbcore thermal fan thermal_sys
[354244.308769] Pid: 12673, comm: btlaunchmanycur Not tainted 
2.6.32-rc2-custom1 #1
[354244.308773] Call Trace:
[354244.308781]  [<c012061c>] ? warn_slowpath_common+0x5e/0x8a
[354244.308786]  [<c0120652>] ? warn_slowpath_null+0xa/0xc
[354244.308791]  [<c0195207>] ? mark_buffer_dirty+0x20/0x73
[354244.308797]  [<c01bdb6e>] ? ext3_commit_super+0x3a/0x50
[354244.308801]  [<c01bea60>] ? ext3_handle_error+0x6e/0x8e
[354244.308805]  [<c01beac7>] ? __ext3_std_error+0x47/0x50
[354244.308810]  [<c01b78fe>] ? ext3_reserve_inode_write+0x56/0x5d
[354244.308814]  [<c01b791f>] ? ext3_mark_inode_dirty+0x1a/0x30
[354244.308819]  [<c01b7a33>] ? ext3_dirty_inode+0x4f/0x62
[354244.308823]  [<c0190d5f>] ? __mark_inode_dirty+0x20/0xea
[354244.308829]  [<c0189fc9>] ? file_update_time+0x99/0xb4
[354244.308838]  [<c015b9a8>] ? __generic_file_aio_write+0x28b/0x3e5
[354244.308843]  [<c01238f3>] ? current_fs_time+0x13/0x15
[354244.308848]  [<c015bb53>] ? generic_file_aio_write+0x51/0x93
[354244.308854]  [<c017c73d>] ? do_sync_write+0xbf/0x106
[354244.308860]  [<c01338f0>] ? hrtimer_forward+0x10c/0x124
[354244.308865]  [<c0131a78>] ? autoremove_wake_function+0x0/0x2d
[354244.308870]  [<c01108be>] ? lapic_next_event+0x13/0x16
[354244.308878]  [<c0139b4c>] ? clockevents_program_event+0xbb/0xc9
[354244.308882]  [<c017c67e>] ? do_sync_write+0x0/0x106
[354244.308886]  [<c017cf96>] ? vfs_write+0x80/0xe4
[354244.308890]  [<c017d092>] ? sys_write+0x3c/0x63
[354244.308895]  [<c0102748>] ? sysenter_do_call+0x12/0x26
[354244.308899] ---[ end trace c8043e12bd811ced ]---


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
