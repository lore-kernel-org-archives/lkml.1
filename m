Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbYKPM30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbYKPM30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYKPM3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:29:14 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:27820 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYKPM3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:29:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZEUPMWn/bxYU/5J9A9LwRPDLEv/RP0Dn/7iQDaq96C0XoObv9NegVgSCR9C+6gnY1h
         sRyz6Da39lLtpk0lLSA7I3VBESXW6Njzl1woe7EtvERs7nEYAaCbWUHWmWj2ONVDzeSS
         gkc0oOQaNYxBlcYU/dd8rGj9jS6mG+BoAsfbg=
Message-ID: <1ba2fa240811160429ld8cc080s7e023b0398eeda08@mail.gmail.com>
Date: Sun, 16 Nov 2008 14:29:12 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: iwlagn driver segfault in 2.6.28-rc3
Cc: "reinette chatre" <reinette.chatre@intel.com>,
       "Lukas Hejtmanek" <xhejtman@ics.muni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20081116120621.GA3937@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081111143410.GA4401@ics.muni.cz>
	 <1226560041.1115.945.camel@rc-desk>
	 <20081116120621.GA3937@localhost.aei.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 2:06 PM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
> I just got (another) one of this too.
>
> The wireless connection suddenly lost the AP and I was waiting
> for ifplugd to reconnect to it again automatically, as it always
> does.
>
> After waiting for one or two minutes I decided to 'modprobe -r
> iwlagn' but this command never returned (it got stuck).
>
> Then I looked at the end of dmesg and found this:

Did you happen to have logs open so I can see what happen prior to that
We found out that this is due to double removal of an encryption key
but I still haven't see the exact flow.
Thanks
Tomas

>
> general protection fault: 0000 [#1] SMP
> last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
> CPU 1
> Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usb_storage xt_comment xt_policy xt_tcpmss xt_pkttype xt_owner xt_NFQUEUE xt_NFLOG xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_hashlimit xt_dscp xt_dccp xt_CLASSIFY snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nvram ohci1394 ieee1394 snd_hda_intel uvcvideo snd_pcm sg sky2 i2c_i801 sr_mod iwlagn compat_ioctl32 snd_timer evdev videodev snd_page_alloc v4l1_compat snd_hwdep ata_piix ahci libata sd_mod scsi_mod uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
> Pid: 3163, comm: ifplugd Not tainted 2.6.28-rc4-keypress-00322-g58e20d8 #14
> RIP: 0010:[<ffffffff803d844b>]  [<ffffffff803d844b>] iwl_eeprom_query16+0xb/0x20
> RSP: 0018:ffff88007b631a88  EFLAGS: 00010092
> RAX: 7fff88007dfd5400 RBX: ffff88007d81a000 RCX: 00000000800600f0
> RDX: 0000000000000cfc RSI: 0000000000000090 RDI: ffff88007dcc1940
> RBP: ffff88007b631a88 R08: 0000000000000002 R09: ffff88007b631a5c
> R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000080006
> R13: ffff88007dcc1940 R14: ffff88007dcc29f8 R15: ffff88007d81a740
> FS:  00007f7f93ef16f0(0000) GS:ffff88007f0686c0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00002ad88fdfd000 CR3: 000000007d935000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process ifplugd (pid: 3163, threadinfo ffff88007b630000, task ffff88007b5ba980)
> Stack:
>  ffff88007b631af8 ffffffffa0108526 ffff88007b631af8 ffffffffa00f3aaf
>  0000000000000000 ffff88007dcc2328 0000000000000292 0000000000000000
>  0143000000000000 ffff88007d81a000 ffff88007dcc1940 ffff88007dcc2328
> Call Trace:
>  [<ffffffffa0108526>] iwl4965_nic_config+0xa6/0x380 [iwlagn]
>  [<ffffffffa00f3aaf>] ? iwl4965_set_pwr_src+0x1cf/0x3d0 [iwlagn]
>  [<ffffffff803d5a9b>] iwl_hw_nic_init+0x11b/0x1d0
>  [<ffffffffa00fbe17>] __iwl4965_up+0x1a7/0x720 [iwlagn]
>  [<ffffffffa00fd0c8>] iwl4965_mac_start+0xd38/0x1570 [iwlagn]
>  [<ffffffff8022d365>] ? __wake_up_sync+0x55/0x70
>  [<ffffffff8043000f>] ? sock_def_readable+0x6f/0x80
>  [<ffffffff8049b893>] ? unix_dgram_sendmsg+0x463/0x4f0
>  [<ffffffff804b5cf8>] ieee80211_open+0x328/0x830
>  [<ffffffff8042bf5b>] ? sock_sendmsg+0xdb/0xf0
>  [<ffffffff8043cba4>] dev_open+0x64/0xc0
>  [<ffffffff8043ba71>] dev_change_flags+0x91/0x1b0
>  [<ffffffff8047fde3>] devinet_ioctl+0x5b3/0x750
>  [<ffffffff8048096d>] inet_ioctl+0x6d/0x90
>  [<ffffffff8042c4d5>] sock_ioctl+0xc5/0x240
>  [<ffffffff802a60f1>] vfs_ioctl+0x31/0x90
>  [<ffffffff802a647b>] do_vfs_ioctl+0x32b/0x460
>  [<ffffffff802a65fa>] sys_ioctl+0x4a/0x80
>  [<ffffffff8020c1fb>] system_call_fastpath+0x16/0x1b
> Code: 48 8b 47 18 55 48 89 e5 48 8b 40 18 48 8b 00 ff 90 00 01 00 00 c9 c3 66 0f 1f 84 00 00 00 00 00 48 8b 87 98 22 01 00 55 48 89 e5 <0f> b6 54 06 01 0f b6 04 30 c9 c1 e2 08 09 d0 0f b7 c0 c3 66 90
> RIP  [<ffffffff803d844b>] iwl_eeprom_query16+0xb/0x20
>  RSP <ffff88007b631a88>
> ---[ end trace 28eaede31d178563 ]---
>
>
> I tried to reboot but it got stuck too, so I had to SysRq+b.
>
> From now on I will apply Reinette's patch and wait for it to
> happen again (but it seldom happens).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
