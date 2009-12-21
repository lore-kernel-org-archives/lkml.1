Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZLUA2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZLUA2x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 19:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbZLUA2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 19:28:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161AbZLUA2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 19:28:52 -0500
Subject: Re: OOPS in inotify code, kernel 2.6.31.6-162.fc12.i686.PAE
From: Eric Paris <eparis@redhat.com>
To: Frantisek Hanzlik <franta@hanzlici.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4B2E7841.6020203@hanzlici.cz>
References: <4B2E1F1C.7000105@hanzlici.cz>  <4B2E7841.6020203@hanzlici.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Dec 2009 19:28:47 -0500
Message-Id: <1261355327.2782.0.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-20 at 20:17 +0100, Frantisek Hanzlik wrote:
> Frantisek Hanzlik wrote:
> > Hello, when I tried incrond inotify daemon, I found this in system log:
> >
> > Dec 20 05:20:03 franta kernel: ------------[ cut here ]------------
> > Dec 20 05:20:03 franta kernel: WARNING: at
> > fs/notify/inotify/inotify_fsnotify.c:129 idr_callback+0x32/0x56() (Not
> > tainted)
> > Dec 20 05:20:03 franta kernel: Hardware name: P5E-VM HDMI
> > Dec 20 05:20:03 franta kernel: inotify closing but id=0 for
> > entry=ed0b8900 in group=d657d600 still in idr. Probably leaking memory
> > Dec 20 05:20:03 franta kernel: Modules linked in: bluetooth rfkill hfs
> > hfsplus nls_utf8 fuse ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs
> > autofs4 nfs lock
> > d fscache nfs_acl auth_rpcgss sunrpc bridge stp llc cpufreq_ondemand
> > acpi_cpufreq dm_multipath kvm_intel kvm uinput snd_hda_codec_intelhdmi
> > snd_hda_codec_rea
> > ltek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device
> > snd_pcm snd_timer firewire_ohci snd firewire_core crc_itu_t iTCO_wdt
> > soundcore iTCO_vendor_
> > support asus_atk0110 i2c_i801 snd_page_alloc atl1 serio_raw e100 mii
> > ata_generic pata_acpi pata_jmicron i915 drm_kms_helper drm i2c_algo_bit
> > i2c_core video o
> > utput [last unloaded: microcode]
> > Dec 20 05:20:03 franta kernel: Pid: 7426, comm: incrond Not tainted
> > 2.6.31.6-162.fc12.i686.PAE #1
> > Dec 20 05:20:03 franta kernel: Call Trace:
> > Dec 20 05:20:03 franta kernel: [<c043db1b>] warn_slowpath_common+0x70/0x87
> > Dec 20 05:20:03 franta kernel: [<c04edbfc>] ? idr_callback+0x32/0x56
> > Dec 20 05:20:03 franta kernel: [<c043db70>] warn_slowpath_fmt+0x29/0x2c
> > Dec 20 05:20:03 franta kernel: [<c04edbfc>] idr_callback+0x32/0x56
> > Dec 20 05:20:03 franta kernel: [<c059ce18>] idr_for_each+0x5c/0x97
> > Dec 20 05:20:03 franta kernel: [<c04edbca>] ? idr_callback+0x0/0x56
> > Dec 20 05:20:03 franta kernel: [<c04ec2b0>] ? fsnotify_put_event+0x48/0x4b
> > Dec 20 05:20:03 franta kernel: [<c04edbb9>]
> > inotify_free_group_priv+0x1a/0x2b
> > Dec 20 05:20:03 franta kernel: [<c04ec38f>]
> > fsnotify_final_destroy_group+0x1e/0x28
> > Dec 20 05:20:03 franta kernel: [<c04ec453>] fsnotify_put_group+0x75/0x78
> > Dec 20 05:20:03 franta kernel: [<c04edd71>] inotify_release+0x1e/0x28
> > Dec 20 05:20:03 franta kernel: [<c04c9bd7>] __fput+0xed/0x184
> > Dec 20 05:20:03 franta kernel: [<c04c9c86>] fput+0x18/0x1a
> > Dec 20 05:20:03 franta kernel: [<c04c7129>] filp_close+0x56/0x60
> > Dec 20 05:20:03 franta kernel: [<c043f480>] put_files_struct+0x5d/0xa1
> > Dec 20 05:20:03 franta kernel: [<c043f4f7>] exit_files+0x33/0x37
> > Dec 20 05:20:03 franta kernel: [<c0440c60>] do_exit+0x1cb/0x5da
> > Dec 20 05:20:03 franta kernel: [<c04410d5>] do_group_exit+0x66/0x8d
> > Dec 20 05:20:03 franta kernel: [<c0441114>] sys_exit_group+0x18/0x1c
> > Dec 20 05:20:03 franta kernel: [<c0408f9b>] sysenter_do_call+0x12/0x28
> > Dec 20 05:20:03 franta kernel: ---[ end trace bf2ba6f50ae90f71 ]---
> > Dec 20 05:20:03 franta kernel: entry->group=(null) inode=(null) wd=1024
> > Dec 20 05:20:08 franta abrt: Kerneloops: Reported 1 kernel oopses to Abrt
> > Dec 20 05:20:08 franta abrtd: Directory 'kerneloops-1261282808-1'
> > creation detected
> > Dec 20 05:20:08 franta abrtd: Getting local universal unique identification
> > Dec 20 05:20:08 franta abrtd: New crash, saving
> > Dec 20 05:20:08 franta abrtd: Activation of plugin 'RunApp' was not
> > successful: Plugin 'RunApp' is not registered
> >
> >
> > In addition to things above: System is Fedora 12 i686 linux, Core2 Duo
> > E8200, 4GB RAM,
> > ext4 fs on root (where I had inotify paths - they was somewhere under
> > /home/).
> >
> > Or report to Fedora's bugzilla is more appropriate?
> >
> > Thanks, Franta Hanzlik
> 
> Sorry for noise, as I just see this bug is probably already reported by Tim Blechmann's
> mail "WARNING: at fs/notify/inotify/inotify_fsnotify.c:129" from 10 Dec 2009 21:39:00
> and hope solving by Eric Paris.

I did manage to get it set up and reproduced today.  I'll work on
debugging it tomorrow.  Races are always so fun to find....

-Eric

