Return-Path: <linux-kernel-owner+w=401wt.eu-S934347AbZIDVzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934347AbZIDVzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 17:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934318AbZIDVzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 17:55:00 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:48251 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934305AbZIDVy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 17:54:58 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=w4iE+TBsmj5y1WloLYF40w==:17 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=8pif782wAAAA:8 a=IZJsKvADPo_RWKyuTagA:9 a=tOp2jdVdBuftAVgr8I8A:7
 a=qj7BNWlwccj9B9ZehIILsGp0D7AA:4 a=MSl-tDqOz04A:10
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: mvsas issues
Date: Fri, 4 Sep 2009 15:54:51 -0600
User-Agent: KMail/1.12.90 (Linux/2.6.31-rc8; KDE/4.3.64; x86_64; svn-1004284; 2009-07-29)
References: <200909031809.58107.tfjellstrom@shaw.ca> <72dbd3150909031732p76275c83hc43ca30601be3e53@mail.gmail.com> <ccdefeca5c690.4aa04e8e@shaw.ca>
In-Reply-To: <ccdefeca5c690.4aa04e8e@shaw.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909041554.51284.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu September 3 2009, Thomas Fjellstrom wrote:
> ----- Original Message -----
> From: David Rees <drees76@gmail.com>
> Date: Thursday, September 3, 2009 6:32 pm
> Subject: Re: mvsas issues
> To: tfjellstrom@shaw.ca
> Cc: linux-kernel@vger.kernel.org
>
> > On Thu, Sep 3, 2009 at 5:09 PM, Thomas
> >
> > Fjellstrom<tfjellstrom@shaw.ca> wrote:
> > > I just got a Marvell SAS card, And I've been trying to copy
> >
> > one set of disks
> >
> > > over to another before one of the drives dies for good...
> >
> > Have you tried using one of the rescue oriented versions of dd
> > to make
> > a copy of the failing disk?  Then copy the image to a good
> > disk and
> > recreate your array (do it in read-only mode!) and see what you can
> > recover.
>
> I haven't yet, with 2.6.30, there doesn't seem to be an mvsas driver, in
> 2.6.31-rc5 it OOPSes the kernel, and in 2.6.31.-rc8 it locks up the entire
> marvell controller (That is all ports start returning errors) so ALL drives
> on it are useless. One additional problem is the drive thats giving up the
> ghost is one of two 2TB disks thats in a temporary md raid0 array. The rest
> of my disks are all 1TB or smaller. Trying to backup one half of the raid0
> pair to a couple separate 1TB disks would be a pain to say the least. And
> last, but not least, today the drive was decideing to error out after 10
> minutes of any kind of actual use. It works after boot for a while no
> matter which controller its on, but after a bit of load it croaks.
>
> I've decided to give the system and the drive a rest for tonight and try to
> get it backed up in the morning. Its possible the temperature here was
> causing the drive to get a little too warm (60c+?). Its strange though. The
> drive can last 12 hours as long as the load is very light. I might get some
> ata errors, but nothing libata can't handle with a reset (it causes a brief
> pause, but stuff keeps going), but the more I try to do, the faster it
> decides to throw an error. The errors I got on the AMD sata controller was
> very similar to a recent report about high rate transfers causing
> libata/linux to somehow loose connection with the host. Also the same error
> I saw people attribute to possible power or interrupt issues. But the
> errors are completely different on the mvsas controller.
>
> > http://en.wikipedia.org/wiki/Dd_%28Unix%29#Recovery-
> > oriented_variants_of_dd
> > -Dave

Shutting down last night I got some strange errors, but could only see them 
flash by as the machine was shutting down, so I couldn't get them till now:

[  954.057076] ------------[ cut here ]------------
[  954.057110] WARNING: at drivers/ata/libata-core.c:5129 
ata_qc_issue+0x10a/0x347 [libata]()
[  954.057112] Hardware name: GA-MA790FXT-UD5P
[  954.057113] Modules linked in: fuse raid0 kvm_amd kvm powernow_k8 
cpufreq_conservative cpufreq_stats cpufreq_userspace cpufreq_powersave nfsd 
exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc bridge stp ext4 jbd2 
crc16 md_mod it87 hwmon_vid adt7473 firewire_sbp2 loop snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device 
evdev snd soundcore snd_page_alloc amd64_edac_mod edac_core i2c_piix4 i2c_core 
parport_pc wmi parport button processor ext3 jbd mbcache dm_mod usbhid sd_mod 
hid crc_t10dif ata_generic mvsas libsas ohci_hcd pata_jmicron firewire_ohci 
firewire_core crc_itu_t ahci atiixp ide_pci_generic libata scsi_transport_sas 
scsi_mod ehci_hcd ide_core r8169 mii floppy thermal fan thermal_sys [last 
unloaded: scsi_wait_scan]
[  954.057153] Pid: 3111, comm: hddtemp Not tainted 2.6.31-rc8 #1
[  954.057155] Call Trace:
[  954.057170]  [<ffffffffa00a2f90>] ? ata_qc_issue+0x10a/0x347 [libata]
[  954.057184]  [<ffffffffa00a2f90>] ? ata_qc_issue+0x10a/0x347 [libata]
[  954.057188]  [<ffffffff8104aca0>] ? warn_slowpath_common+0x77/0xa3
[  954.057202]  [<ffffffffa00a70ce>] ? ata_scsi_pass_thru+0x0/0x240 [libata]
[  954.057214]  [<ffffffffa00a2f90>] ? ata_qc_issue+0x10a/0x347 [libata]
[  954.057229]  [<ffffffffa006d1d6>] ? scsi_get_command+0x75/0x97 [scsi_mod]
[  954.057242]  [<ffffffffa00a70ce>] ? ata_scsi_pass_thru+0x0/0x240 [libata]
[  954.057254]  [<ffffffffa006c7aa>] ? scsi_done+0x0/0xc [scsi_mod]
[  954.057267]  [<ffffffffa00a84d5>] ? __ata_scsi_queuecmd+0x185/0x1dc 
[libata]
[  954.057279]  [<ffffffffa006c7aa>] ? scsi_done+0x0/0xc [scsi_mod]
[  954.057287]  [<ffffffffa0108c8e>] ? sas_queuecommand+0x83/0x25d [libsas]
[  954.057299]  [<ffffffffa006ca7c>] ? scsi_dispatch_cmd+0x1c0/0x23c 
[scsi_mod]
[  954.057311]  [<ffffffffa0071ff0>] ? scsi_request_fn+0x3a5/0x506 [scsi_mod]
[  954.057315]  [<ffffffff810546e0>] ? del_timer+0x59/0x62
[  954.057319]  [<ffffffff81163b08>] ? blk_execute_rq_nowait+0x65/0x89
[  954.057322]  [<ffffffff81163bb7>] ? blk_execute_rq+0x8b/0xac
[  954.057324]  [<ffffffff8115f0b9>] ? get_request_wait+0x21/0x17e
[  954.057337]  [<ffffffffa007306d>] ? scsi_execute+0xdc/0x12f [scsi_mod]
[  954.057350]  [<ffffffffa00a98b6>] ? ata_cmd_ioctl+0x134/0x209 [libata]
[  954.057354]  [<ffffffff811fe220>] ? loopback_xmit+0x62/0x7d
[  954.057367]  [<ffffffffa00a9b83>] ? ata_sas_scsi_ioctl+0x1f8/0x235 [libata]
[  954.057371]  [<ffffffff8123867a>] ? dev_queue_xmit+0x2fe/0x32c
[  954.057383]  [<ffffffffa006e040>] ? scsi_ioctl+0x2f8/0x324 [scsi_mod]
[  954.057386]  [<ffffffff81164a8d>] ? __blkdev_driver_ioctl+0x69/0x7e
[  954.057389]  [<ffffffff811652aa>] ? blkdev_ioctl+0x7e4/0x81a
[  954.057392]  [<ffffffff8122be38>] ? lock_sock_nested+0x9b/0xa6
[  954.057395]  [<ffffffff812dd777>] ? _spin_lock_bh+0x9/0x25
[  954.057398]  [<ffffffff8122bd1a>] ? release_sock+0x13/0x96
[  954.057401]  [<ffffffff812621ec>] ? inet_csk_accept+0x1c7/0x1f1
[  954.057403]  [<ffffffff8122be38>] ? lock_sock_nested+0x9b/0xa6
[  954.057406]  [<ffffffff810e892f>] ? __d_instantiate+0x54/0xbd
[  954.057410]  [<ffffffff81100ef8>] ? inotify_d_instantiate+0x12/0x39
[  954.057412]  [<ffffffff812dd777>] ? _spin_lock_bh+0x9/0x25
[  954.057415]  [<ffffffff810fb3de>] ? block_ioctl+0x38/0x3c
[  954.057417]  [<ffffffff810e51d2>] ? vfs_ioctl+0x21/0x6c
[  954.057420]  [<ffffffff810e56ca>] ? do_vfs_ioctl+0x437/0x475
[  954.057422]  [<ffffffff810e5759>] ? sys_ioctl+0x51/0x70
[  954.057426]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
[  954.057428] ---[ end trace ce7c5e8c05d7643d ]---
...
[ 2435.749631] JBD: barrier-based sync failed on md2:8 - disabling barriers
[ 2753.780726] sd 2:0:4:0: [sdg] Unhandled error code
[ 2753.780732] sd 2:0:4:0: [sdg] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2753.780914] sd 2:0:0:0: [sdc] Unhandled error code
... (and a bunch more of the unhandled error code and DRIVER_TIMEOUT lines)
[ 2753.783580] JBD2: Detected IO errors while flushing file data on md2:8
[ 2880.628276] pdflush       D ffff880028070800     0  5483      2 0x00000000
[ 2880.628287]  ffff880128044100 0000000000000046 ffff88012bcc4a18 
ffff88012bcc4a18
[ 2880.628297]  0000000000000003 0000000000014800 000000000000f800 
ffff880073445040
[ 2880.628306]  ffff880073445338 0000000281158373 ffff8801199e8a80 
0000000000000046
[ 2880.628314] Call Trace:
[ 2880.628329]  [<ffffffff8115eadd>] ? __generic_unplug_device+0x12/0x2c
[ 2880.628340]  [<ffffffff81017015>] ? read_tsc+0xa/0x20
[ 2880.628348]  [<ffffffff8115f597>] ? __make_request+0x381/0x3d5
[ 2880.628357]  [<ffffffff810661e9>] ? getnstimeofday+0x55/0xaf
[ 2880.628366]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 2880.628376]  [<ffffffff812dc68b>] ? io_schedule+0x63/0xa5
[ 2880.628384]  [<ffffffff810f7cf3>] ? sync_buffer+0x3b/0x40
[ 2880.628392]  [<ffffffff812dc99b>] ? __wait_on_bit+0x41/0x70
[ 2880.628400]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 2880.628408]  [<ffffffff812dca35>] ? out_of_line_wait_on_bit+0x6b/0x77
[ 2880.628416]  [<ffffffff8105ef14>] ? wake_bit_function+0x0/0x23
[ 2880.628425]  [<ffffffff810f80bf>] ? sync_dirty_buffer+0x5b/0x93
[ 2880.628481]  [<ffffffffa0369336>] ? ext4_commit_super+0x147/0x195 [ext4]
[ 2880.628528]  [<ffffffffa036b7f8>] ? ext4_handle_error+0x84/0xa8 [ext4]
[ 2880.628587]  [<ffffffffa036b964>] ? __ext4_std_error+0x5a/0x61 [ext4]
[ 2880.628633]  [<ffffffffa036c22a>] ? __ext4_journal_stop+0x3b/0x5d [ext4]
[ 2880.628676]  [<ffffffffa035c5be>] ? ext4_da_writepages+0x2e4/0x446 [ext4]
[ 2880.628690]  [<ffffffff810af4b4>] ? do_writepages+0x20/0x2d
[ 2880.628702]  [<ffffffff810f2307>] ? writeback_single_inode+0x164/0x34e
[ 2880.628714]  [<ffffffff81061c8a>] ? ktime_get_ts+0x21/0x49
[ 2880.628726]  [<ffffffff8108f78f>] ? delayacct_end+0x7d/0x88
[ 2880.628737]  [<ffffffff810f2946>] ? generic_sync_sb_inodes+0x2a7/0x43d
[ 2880.628750]  [<ffffffff810b010a>] ? pdflush+0x0/0x23b
[ 2880.628761]  [<ffffffff810f2be2>] ? writeback_inodes+0x7e/0xce
[ 2880.628772]  [<ffffffff810af5fe>] ? wb_kupdate+0xaa/0x11e
[ 2880.628784]  [<ffffffff810b0263>] ? pdflush+0x159/0x23b
[ 2880.628796]  [<ffffffff810af554>] ? wb_kupdate+0x0/0x11e
[ 2880.628807]  [<ffffffff810b010a>] ? pdflush+0x0/0x23b
[ 2880.628817]  [<ffffffff8105eb8a>] ? kthread+0x8b/0x93
[ 2880.628828]  [<ffffffff81011aea>] ? child_rip+0xa/0x20
[ 2880.628839]  [<ffffffff8105eaff>] ? kthread+0x0/0x93
[ 2880.628849]  [<ffffffff81011ae0>] ? child_rip+0x0/0x20
[ 2880.628871] kjournald2    D ffff88002808d800     0  8000      2 0x00000000
[ 2880.628886]  ffff880124d5e080 0000000000000046 ffff88012bcc4a18 
ffff88012bcc4a18
[ 2880.628904]  0000000000000003 0000000000014800 000000000000f800 
ffff88000af99780
[ 2880.628922]  ffff88000af99a78 0000000381158373 ffff880024bc2440 
0000000000000046
[ 2880.628940] Call Trace:
[ 2880.628951]  [<ffffffff8115eadd>] ? __generic_unplug_device+0x12/0x2c
[ 2880.628963]  [<ffffffff81017015>] ? read_tsc+0xa/0x20
[ 2880.628973]  [<ffffffff8115f597>] ? __make_request+0x381/0x3d5
[ 2880.628984]  [<ffffffff810661e9>] ? getnstimeofday+0x55/0xaf
[ 2880.628995]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 2880.629007]  [<ffffffff812dc68b>] ? io_schedule+0x63/0xa5
[ 2880.629018]  [<ffffffff810f7cf3>] ? sync_buffer+0x3b/0x40
[ 2880.629029]  [<ffffffff812dc99b>] ? __wait_on_bit+0x41/0x70
[ 2880.629041]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 2880.629053]  [<ffffffff812dca35>] ? out_of_line_wait_on_bit+0x6b/0x77
[ 2880.629064]  [<ffffffff8105ef14>] ? wake_bit_function+0x0/0x23
[ 2880.629075]  [<ffffffff810f80bf>] ? sync_dirty_buffer+0x5b/0x93
[ 2880.629108]  [<ffffffffa03457c6>] ? 
jbd2_journal_update_superblock+0xb9/0x134 [jbd2]
[ 2880.629135]  [<ffffffffa0345c14>] ? __jbd2_journal_abort_hard+0x3f/0x45 
[jbd2]
[ 2880.629161]  [<ffffffffa03418cd>] ? 
jbd2_journal_commit_transaction+0xb37/0x114a [jbd2]
[ 2880.629189]  [<ffffffffa0346129>] ? kjournald2+0xfc/0x240 [jbd2]
[ 2880.629200]  [<ffffffff8105eee6>] ? autoremove_wake_function+0x0/0x2e
[ 2880.629226]  [<ffffffffa034602d>] ? kjournald2+0x0/0x240 [jbd2]
[ 2880.629234]  [<ffffffff8105eb8a>] ? kthread+0x8b/0x93
[ 2880.629244]  [<ffffffff81011aea>] ? child_rip+0xa/0x20
[ 2880.629255]  [<ffffffff8105eaff>] ? kthread+0x0/0x93
[ 2880.629265]  [<ffffffff81011ae0>] ? child_rip+0x0/0x20
[ 2880.629286] rsync         D 0000000000000000     0  9019      1 0x00000004
[ 2880.629300]  ffff88012fb428c0 0000000000000082 ffff8800b050b818 
ffff88008006ae98
[ 2880.629318]  ffff8800988d0130 0000000000014800 000000000000f800 
ffff8800b38051c0
[ 2880.629336]  ffff8800b38054b8 000000021b937c38 0000000000000000 
0000000000001000
[ 2880.629354] Call Trace:
[ 2880.629366]  [<ffffffff81017015>] ? read_tsc+0xa/0x20
[ 2880.629377]  [<ffffffff810661e9>] ? getnstimeofday+0x55/0xaf
[ 2880.629389]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 2880.629400]  [<ffffffff812dc68b>] ? io_schedule+0x63/0xa5
[ 2880.629411]  [<ffffffff810f7cf3>] ? sync_buffer+0x3b/0x40
[ 2880.629423]  [<ffffffff812dc89e>] ? __wait_on_bit_lock+0x3f/0x84
[ 2880.629434]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 2880.629446]  [<ffffffff812dc94e>] ? out_of_line_wait_on_bit_lock+0x6b/0x77
[ 2880.629456]  [<ffffffff8105ef14>] ? wake_bit_function+0x0/0x23
[ 2880.629482]  [<ffffffffa033ffac>] ? do_get_write_access+0x69/0x421 [jbd2]
[ 2880.629495]  [<ffffffff81054b00>] ? __mod_timer+0xf7/0x109
[ 2880.629503]  [<ffffffff81061c8a>] ? ktime_get_ts+0x21/0x49
[ 2880.629526]  [<ffffffffa0340386>] ? jbd2_journal_get_write_access+0x22/0x33 
[jbd2]
[ 2880.629574]  [<ffffffffa0376295>] ? 
__ext4_journal_get_write_access+0x4b/0x53 [ext4]
[ 2880.629617]  [<ffffffffa035efc6>] ? ext4_delete_entry+0x7c/0x15c [ext4]
[ 2880.629660]  [<ffffffffa03625d7>] ? ext4_unlink+0x107/0x1c8 [ext4]
[ 2880.629673]  [<ffffffff810e289e>] ? vfs_unlink+0x72/0xa6
[ 2880.629685]  [<ffffffff810e405c>] ? do_unlinkat+0xad/0x134
[ 2880.629697]  [<ffffffff810314e5>] ? do_page_fault+0x25f/0x27b
[ 2880.629709]  [<ffffffff811731b1>] ? __up_read+0x13/0x8e
[ 2880.629719]  [<ffffffff812dda95>] ? page_fault+0x25/0x30
[ 2880.629732]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
[ 2939.780312] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780317] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780332] __ratelimit: 1129 callbacks suppressed
[ 2939.780342] lost page write due to I/O error on md2
[ 2939.780366] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780370] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780399] Pid: 5483, comm: pdflush Tainted: G        W  2.6.31-rc8 #1
[ 2939.780405] Call Trace:
[ 2939.780415] lost page write due to I/O error on md2
[ 2939.780467]  [<ffffffffa035c506>] ? ext4_da_writepages+0x22c/0x446 [ext4]
[ 2939.780482]  [<ffffffff810af4b4>] ? do_writepages+0x20/0x2d
[ 2939.780486] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780491] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780509] lost page write due to I/O error on md2
[ 2939.780520]  [<ffffffff810f2307>] ? writeback_single_inode+0x164/0x34e
[ 2939.780530]  [<ffffffff81061c8a>] ? ktime_get_ts+0x21/0x49
[ 2939.780537] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780541] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780558] lost page write due to I/O error on md2
[ 2939.780567]  [<ffffffff8108f78f>] ? delayacct_end+0x7d/0x88
[ 2939.780572] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780576] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780592] lost page write due to I/O error on md2
[ 2939.780602]  [<ffffffff810f2946>] ? generic_sync_sb_inodes+0x2a7/0x43d
[ 2939.780606] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780611] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780627] lost page write due to I/O error on md2
[ 2939.780637]  [<ffffffff810b010a>] ? pdflush+0x0/0x23b
[ 2939.780642] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780646] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780664] lost page write due to I/O error on md2
[ 2939.780674]  [<ffffffff810f2be2>] ? writeback_inodes+0x7e/0xce
[ 2939.780678] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780683] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780699] lost page write due to I/O error on md2
[ 2939.780708]  [<ffffffff810af5fe>] ? wb_kupdate+0xaa/0x11e
[ 2939.780712] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780717] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780733] lost page write due to I/O error on md2
[ 2939.780743]  [<ffffffff810b0263>] ? pdflush+0x159/0x23b
[ 2939.780747] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780752] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780767] lost page write due to I/O error on md2
[ 2939.780777]  [<ffffffff810af554>] ? wb_kupdate+0x0/0x11e
[ 2939.780781] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780786] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780802]  [<ffffffff810b010a>] ? pdflush+0x0/0x23b
[ 2939.780806] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780811] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780826]  [<ffffffff8105eb8a>] ? kthread+0x8b/0x93
[ 2939.780835]  [<ffffffff81011aea>] ? child_rip+0xa/0x20
[ 2939.780839] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780844] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780860]  [<ffffffff8105eaff>] ? kthread+0x0/0x93
[ 2939.780867]  [<ffffffff81011ae0>] ? child_rip+0x0/0x20
[ 2939.780962] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.780966] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 2939.780999] sd 2:0:0:0: [sdc] Unhandled error code
[ 2939.781011] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
... (snip redundant lines)
[ 3000.628266] rsync         D 0000000000000000     0  9019      1 0x00000004
[ 3000.628277]  ffff88012fb428c0 0000000000000082 ffff8800b050b818 
ffff88008006ae98
[ 3000.628287]  ffff8800988d0130 0000000000014800 000000000000f800 
ffff8800b38051c0
[ 3000.628296]  ffff8800b38054b8 000000021b937c38 0000000000000000 
0000000000001000
[ 3000.628304] Call Trace:
[ 3000.628320]  [<ffffffff81017015>] ? read_tsc+0xa/0x20
[ 3000.628330]  [<ffffffff810661e9>] ? getnstimeofday+0x55/0xaf
[ 3000.628341]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 3000.628350]  [<ffffffff812dc68b>] ? io_schedule+0x63/0xa5
[ 3000.628358]  [<ffffffff810f7cf3>] ? sync_buffer+0x3b/0x40
[ 3000.628367]  [<ffffffff812dc89e>] ? __wait_on_bit_lock+0x3f/0x84
[ 3000.628375]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 3000.628383]  [<ffffffff812dc94e>] ? out_of_line_wait_on_bit_lock+0x6b/0x77
[ 3000.628392]  [<ffffffff8105ef14>] ? wake_bit_function+0x0/0x23
[ 3000.628424]  [<ffffffffa033ffac>] ? do_get_write_access+0x69/0x421 [jbd2]
[ 3000.628434]  [<ffffffff81054b00>] ? __mod_timer+0xf7/0x109
[ 3000.628442]  [<ffffffff81061c8a>] ? ktime_get_ts+0x21/0x49
[ 3000.628468]  [<ffffffffa0340386>] ? jbd2_journal_get_write_access+0x22/0x33 
[jbd2]
[ 3000.628521]  [<ffffffffa0376295>] ? 
__ext4_journal_get_write_access+0x4b/0x53 [ext4]
[ 3000.628574]  [<ffffffffa035efc6>] ? ext4_delete_entry+0x7c/0x15c [ext4]
[ 3000.628618]  [<ffffffffa03625d7>] ? ext4_unlink+0x107/0x1c8 [ext4]
[ 3000.628632]  [<ffffffff810e289e>] ? vfs_unlink+0x72/0xa6
[ 3000.628644]  [<ffffffff810e405c>] ? do_unlinkat+0xad/0x134
[ 3000.628656]  [<ffffffff810314e5>] ? do_page_fault+0x25f/0x27b
[ 3000.628668]  [<ffffffff811731b1>] ? __up_read+0x13/0x8e
[ 3000.628678]  [<ffffffff812dda95>] ? page_fault+0x25/0x30
[ 3000.628693]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
[ 3120.628695] kjournald2    D ffff88012dc29bc0     0  8000      2 0x00000000
[ 3120.628706]  ffff88012f1837c0 0000000000000046 0000000000000000 
ffff88000af99780
[ 3120.628716]  ffffffff8105ef14 0000000000014800 000000000000f800 
ffff88000af99780
[ 3120.628725]  ffff88000af99a78 000000032dc29698 ffffffff81017015 
ffffffffa033f399
[ 3120.628733] Call Trace:
[ 3120.628748]  [<ffffffff8105ef14>] ? wake_bit_function+0x0/0x23
[ 3120.628759]  [<ffffffff81017015>] ? read_tsc+0xa/0x20
[ 3120.628792]  [<ffffffffa033f399>] ? __jbd2_journal_file_buffer+0xdf/0x180 
[jbd2]
[ 3120.628819]  [<ffffffffa0340f5f>] ? 
jbd2_journal_commit_transaction+0x1c9/0x114a [jbd2]
[ 3120.628829]  [<ffffffff8105eee6>] ? autoremove_wake_function+0x0/0x2e
[ 3120.628838]  [<ffffffff810545f0>] ? lock_timer_base+0x26/0x4c
[ 3120.628847]  [<ffffffff81054668>] ? try_to_del_timer_sync+0x52/0x5b
[ 3120.628872]  [<ffffffffa0346129>] ? kjournald2+0xfc/0x240 [jbd2]
[ 3120.628879]  [<ffffffff8105eee6>] ? autoremove_wake_function+0x0/0x2e
[ 3120.628902]  [<ffffffffa034602d>] ? kjournald2+0x0/0x240 [jbd2]
[ 3120.628909]  [<ffffffff8105eb8a>] ? kthread+0x8b/0x93
[ 3120.628917]  [<ffffffff81011aea>] ? child_rip+0xa/0x20
[ 3120.628924]  [<ffffffff8105eaff>] ? kthread+0x0/0x93
[ 3120.628931]  [<ffffffff81011ae0>] ? child_rip+0x0/0x20
[ 3120.628946] rsync         D 0000000000000000     0  9019      1 0x00000004
[ 3120.628955]  ffff88012fb428c0 0000000000000082 ffff8800b050b818 
ffff88008006ae98
[ 3120.628964]  ffff8800988d0130 0000000000014800 000000000000f800 
ffff8800b38051c0
[ 3120.628973]  ffff8800b38054b8 000000021b937c38 0000000000000000 
0000000000001000
[ 3120.628981] Call Trace:
[ 3120.628989]  [<ffffffff81017015>] ? read_tsc+0xa/0x20
[ 3120.628997]  [<ffffffff810661e9>] ? getnstimeofday+0x55/0xaf
[ 3120.629007]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 3120.629016]  [<ffffffff812dc68b>] ? io_schedule+0x63/0xa5
[ 3120.629024]  [<ffffffff810f7cf3>] ? sync_buffer+0x3b/0x40
[ 3120.629032]  [<ffffffff812dc89e>] ? __wait_on_bit_lock+0x3f/0x84
[ 3120.629040]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 3120.629049]  [<ffffffff812dc94e>] ? out_of_line_wait_on_bit_lock+0x6b/0x77
[ 3120.629056]  [<ffffffff8105ef14>] ? wake_bit_function+0x0/0x23
[ 3120.629079]  [<ffffffffa033ffac>] ? do_get_write_access+0x69/0x421 [jbd2]
[ 3120.629088]  [<ffffffff81054b00>] ? __mod_timer+0xf7/0x109
[ 3120.629096]  [<ffffffff81061c8a>] ? ktime_get_ts+0x21/0x49
[ 3120.629118]  [<ffffffffa0340386>] ? jbd2_journal_get_write_access+0x22/0x33 
[jbd2]
[ 3120.629172]  [<ffffffffa0376295>] ? 
__ext4_journal_get_write_access+0x4b/0x53 [ext4]
[ 3120.629212]  [<ffffffffa035efc6>] ? ext4_delete_entry+0x7c/0x15c [ext4]
[ 3120.629251]  [<ffffffffa03625d7>] ? ext4_unlink+0x107/0x1c8 [ext4]
[ 3120.629261]  [<ffffffff810e289e>] ? vfs_unlink+0x72/0xa6
[ 3120.629269]  [<ffffffff810e405c>] ? do_unlinkat+0xad/0x134
[ 3120.629278]  [<ffffffff810314e5>] ? do_page_fault+0x25f/0x27b
[ 3120.629289]  [<ffffffff811731b1>] ? __up_read+0x13/0x8e
[ 3120.629296]  [<ffffffff812dda95>] ? page_fault+0x25/0x30
[ 3120.629305]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
[ 3125.781630] sd 2:0:0:0: [sdc] Unhandled error code
[ 3125.781636] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 3125.781650] __ratelimit: 88 callbacks suppressed
[ 3125.781661] lost page write due to I/O error on md2
[ 3125.781699] sd 2:0:0:0: [sdc] Unhandled error code
[ 3125.781704] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
...
[ 3125.781846] lost page write due to I/O error on md2
[ 3125.781850] lost page write due to I/O error on md2
[ 3125.781874] sd 2:0:0:0: [sdc] Unhandled error code
[ 3125.781875] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 3125.781920] sd 2:0:0:0: [sdc] Unhandled error code
[ 3125.781922] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 3125.781929] sd 2:0:0:0: [sdc] Unhandled error code
[ 3125.781930] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 3125.781936] sd 2:0:0:0: [sdc] Unhandled error code
[ 3125.781937] sd 2:0:0:0: [sdc] 
[ 3125.781950] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 3125.781962] sd 2:0:0:0: [sdc] Unhandled error code
[ 3125.781964] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 3125.781970] sd 2:0:0:0: [sdc] Unhandled error code
[ 3125.781972] sd 2:0:0:0: [sdc] 
[ 3125.781980] Result: hostbyte=DID_OK driverbyte=DRIVER_TIMEOUT
[ 3125.781985] sd 2:0:0:0: [sdc] Unhandled error code
[ 3125.781986] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 3125.781995] sd 2:0:4:0: [sdg] Unhandled error code
[ 3125.781996] sd 2:0:4:0: [sdg] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 3197.447940] EXT4-fs: mballoc: 1564999 blocks 3553 reqs (2553 success)
[ 3197.447944] EXT4-fs: mballoc: 1037 extents scanned, 2010 goal hits, 503 2^N 
hits, 0 breaks, 0 lost
[ 3197.447946] EXT4-fs: mballoc: 82 generated and it took 534789
[ 3197.447947] EXT4-fs: mballoc: 1127712 preallocated, 52750 discarded
[ 3311.781630] sd 2:0:0:0: [sdc] Unhandled error code
[ 3311.781633] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 3311.781638] __ratelimit: 93 callbacks suppressed
[ 3311.781644] lost page write due to I/O error on md2
[ 3311.781662] sd 2:0:0:0: [sdc] Unhandled error code
[ 3311.781664] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
...
[ 3311.781733] lost page write due to I/O error on md2
[ 3311.781737] lost page write due to I/O error on md2
[ 3311.781740] lost page write due to I/O error on md2
[ 3311.781763] sd 2:0:0:0: [sdc] Unhandled error code
[ 3311.781764] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 3311.781787] sd 2:0:0:0: [sdc] Unhandled error code
[ 3311.781789] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
...
shutting down for system reboot
shutting down for system halt
[ 3360.628380] umount        D 0000000000000000     0 10702   9650 0x00000004
[ 3360.628572]  ffff88012fb428c0 0000000000000086 000000000000000b 
ffffffff814499b0
[ 3360.628857]  0000000000000047 0000000000014800 000000000000f800 
ffff8800748aa0c0
[ 3360.629146]  ffff8800748aa3b8 000000028104ae25 0000000000000092 
ffffffff81062454
[ 3360.629429] Call Trace:
[ 3360.629504]  [<ffffffff81062454>] ? up+0xe/0x36
[ 3360.629576]  [<ffffffff81017015>] ? read_tsc+0xa/0x20
[ 3360.629649]  [<ffffffff8104b2b6>] ? release_console_sem+0x183/0x1b5
[ 3360.629721]  [<ffffffff810661e9>] ? getnstimeofday+0x55/0xaf
[ 3360.629793]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 3360.629866]  [<ffffffff812dc68b>] ? io_schedule+0x63/0xa5
[ 3360.629936]  [<ffffffff810f7cf3>] ? sync_buffer+0x3b/0x40
[ 3360.630007]  [<ffffffff812dc99b>] ? __wait_on_bit+0x41/0x70
[ 3360.630078]  [<ffffffff810f7cb8>] ? sync_buffer+0x0/0x40
[ 3360.630149]  [<ffffffff812dca35>] ? out_of_line_wait_on_bit+0x6b/0x77
[ 3360.630220]  [<ffffffff8105ef14>] ? wake_bit_function+0x0/0x23
[ 3360.630317]  [<ffffffffa0342ddb>] ? jbd2_log_do_checkpoint+0x136/0x471 
[jbd2]
[ 3360.630409]  [<ffffffffa03459bb>] ? jbd2_journal_destroy+0x10c/0x1e9 [jbd2]
[ 3360.630481]  [<ffffffff8105eee6>] ? autoremove_wake_function+0x0/0x2e
[ 3360.630595]  [<ffffffffa036bf8f>] ? ext4_put_super+0x6a/0x2ca [ext4]
[ 3360.630669]  [<ffffffff810db99d>] ? generic_shutdown_super+0x56/0xee
[ 3360.630740]  [<ffffffff810dba57>] ? kill_block_super+0x22/0x3a
[ 3360.630810]  [<ffffffff810dc0f9>] ? deactivate_super+0x60/0x77
[ 3360.630882]  [<ffffffff810ee0ed>] ? sys_umount+0x2ca/0x2f9
[ 3360.630955]  [<ffffffff81010a02>] ? system_call_fastpath+0x16/0x1b
[ 3373.780430] ata11: no sense translation for status: 0x00
[ 3373.780579] ata11: status=0x00 { }
[ 3373.780779] ata11: no sense translation for status: 0x00
[ 3373.780925] ata11: status=0x00 { }
[ 3373.781110] ata11: no sense translation for status: 0x00
[ 3373.781256] ata11: status=0x00 { }
... (snip)
[ 3373.788939] ata15: no sense translation for status: 0x00
[ 3373.789088] ata15: status=0x00 { }
[ 3373.789211] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.789333] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.789638] Descriptor sense data with sense descriptors (in hex):
[ 3373.789757]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.790678]         00 00 00 00 
[ 3373.790995] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.797429] __ratelimit: 70 callbacks suppressed
[ 3373.797575] lost page write due to I/O error on md2
[ 3373.797740] ata11: no sense translation for status: 0x00
[ 3373.797891] ata11: status=0x00 { }
[ 3373.798008] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.798130] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.798409] Descriptor sense data with sense descriptors (in hex):
[ 3373.798534]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.799449]         00 00 00 00 
[ 3373.799767] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.800079] lost page write due to I/O error on md2
[ 3373.800227] ata11: no sense translation for status: 0x00
[ 3373.800377] ata11: status=0x00 { }
[ 3373.800495] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.800615] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.800901] Descriptor sense data with sense descriptors (in hex):
[ 3373.801019]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.801967]         00 00 00 00 
[ 3373.802281] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.802591] lost page write due to I/O error on md2
[ 3373.802740] ata11: no sense translation for status: 0x00
[ 3373.802893] ata11: status=0x00 { }
[ 3373.803010] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.803132] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.803411] Descriptor sense data with sense descriptors (in hex):
[ 3373.803529]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.804463]         00 00 00 00 
[ 3373.804776] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.805092] lost page write due to I/O error on md2
[ 3373.805240] ata11: no sense translation for status: 0x00
[ 3373.805390] ata11: status=0x00 { }
[ 3373.805598] ata11: no sense translation for status: 0x00
[ 3373.805749] ata11: status=0x00 { }
[ 3373.805937] ata11: no sense translation for status: 0x00
[ 3373.806090] ata11: status=0x00 { }
[ 3373.806213] sd 2:0:4:0: [sdg] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.806334] sd 2:0:4:0: [sdg] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.806613] Descriptor sense data with sense descriptors (in hex):
[ 3373.806731]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.807648]         00 00 00 00 
[ 3373.807963] sd 2:0:4:0: [sdg] Add. Sense: No additional sense information
[ 3373.808363] ata11: no sense translation for status: 0x00
[ 3373.808513] ata11: status=0x00 { }
[ 3373.808701] ata11: no sense translation for status: 0x00
[ 3373.808851] ata11: status=0x00 { }
[ 3373.809039] ata11: no sense translation for status: 0x00
[ 3373.809188] ata11: status=0x00 { }
[ 3373.809383] ata11: no sense translation for status: 0x00
[ 3373.809520] ata11: status=0x00 { }
[ 3373.809671] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.809796] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.810076] Descriptor sense data with sense descriptors (in hex):
[ 3373.810194]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.811115]         00 00 00 00 
[ 3373.811428] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.811741] lost page write due to I/O error on md2
[ 3373.811889] ata11: no sense translation for status: 0x00
[ 3373.812043] ata11: status=0x00 { }
[ 3373.812160] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.812282] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.812561] Descriptor sense data with sense descriptors (in hex):
[ 3373.812680]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.813615]         00 00 00 00 
[ 3373.813931] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.814242] lost page write due to I/O error on md2
[ 3373.814390] ata11: no sense translation for status: 0x00
[ 3373.814541] ata11: status=0x00 { }
...
[ 3373.828873] ata11: no sense translation for status: 0x00
[ 3373.829023] ata11: status=0x00 { }
[ 3373.829144] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.829266] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.829571] Descriptor sense data with sense descriptors (in hex):
[ 3373.829692]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.830612]         00 00 00 00 
[ 3373.830930] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.831240] lost page write due to I/O error on md2
[ 3373.831389] ata11: no sense translation for status: 0x00
[ 3373.831539] ata11: status=0x00 { }
[ 3373.831656] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.831777] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.832064] Descriptor sense data with sense descriptors (in hex):
[ 3373.832182]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.833107]         00 00 00 00 
[ 3373.833424] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.833759] lost page write due to I/O error on md2
[ 3373.833909] ata11: no sense translation for status: 0x00
[ 3373.834058] ata11: status=0x00 { }
[ 3373.834176] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.834297] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.834579] Descriptor sense data with sense descriptors (in hex):
[ 3373.834697]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.835619]         00 00 00 00 
[ 3373.835934] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.836255] lost page write due to I/O error on md2
[ 3373.836406] ata11: no sense translation for status: 0x00
[ 3373.836556] ata11: status=0x00 { }
[ 3373.836681] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.836802] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.837097] Descriptor sense data with sense descriptors (in hex):
[ 3373.837216]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.838161]         00 00 00 00 
[ 3373.838475] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.838811] ata11: no sense translation for status: 0x00
[ 3373.838961] ata11: status=0x00 { }
[ 3373.839152] ata11: no sense translation for status: 0x00
[ 3373.839302] ata11: status=0x00 { }
[ 3373.839490] ata11: no sense translation for status: 0x00
[ 3373.839640] ata11: status=0x00 { }
[ 3373.839829] ata11: no sense translation for status: 0x00
[ 3373.839978] ata11: status=0x00 { }
[ 3373.840173] ata11: no sense translation for status: 0x00
[ 3373.840323] ata11: status=0x00 { }
[ 3373.840510] ata11: no sense translation for status: 0x00
[ 3373.840660] ata11: status=0x00 { }
[ 3373.840860] ata11: no sense translation for status: 0x00
[ 3373.841009] ata11: status=0x00 { }
[ 3373.841135] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.841260] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.841558] Descriptor sense data with sense descriptors (in hex):
[ 3373.841677]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.842611]         00 00 00 00 
[ 3373.842928] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.843262] ata11: no sense translation for status: 0x00
[ 3373.843415] ata11: status=0x00 { }
[ 3373.843533] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.843653] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.843933] Descriptor sense data with sense descriptors (in hex):
[ 3373.844056]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.844987]         00 00 00 00 
[ 3373.845306] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.845655] ata11: no sense translation for status: 0x00
[ 3373.845805] ata11: status=0x00 { }
...
[ 3373.860193] ata11: no sense translation for status: 0x00
[ 3373.860343] ata11: status=0x00 { }
[ 3373.860461] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.860594] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.860880] Descriptor sense data with sense descriptors (in hex):
[ 3373.861004]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.861955]         00 00 00 00 
[ 3373.862269] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.862592] ata11: no sense translation for status: 0x00
[ 3373.862742] ata11: status=0x00 { }
[ 3373.862860] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.862985] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.863264] Descriptor sense data with sense descriptors (in hex):
[ 3373.863382]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.864303]         00 00 00 00 
[ 3373.864623] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.864943] ata11: no sense translation for status: 0x00
[ 3373.865092] ata11: status=0x00 { }
[ 3373.865229] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.865351] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.865652] Descriptor sense data with sense descriptors (in hex):
[ 3373.865770]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.866693]         00 00 00 00 
[ 3373.867007] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.867331] ata11: no sense translation for status: 0x00
[ 3373.867481] ata11: status=0x00 { }
[ 3373.867600] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.867722] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.868000] Descriptor sense data with sense descriptors (in hex):
[ 3373.868122]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.869061]         00 00 00 00 
[ 3373.869374] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.869767] ata11: no sense translation for status: 0x00
[ 3373.869918] ata11: status=0x00 { }
[ 3373.870113] ata11: no sense translation for status: 0x00
[ 3373.870262] ata11: status=0x00 { }
[ 3373.870450] ata11: no sense translation for status: 0x00
[ 3373.870605] ata11: status=0x00 { }
[ 3373.870794] ata11: no sense translation for status: 0x00
[ 3373.873567] ata11: status=0x00 { }
[ 3373.877344] ata11: no sense translation for status: 0x00
[ 3373.877497] ata11: status=0x00 { }
[ 3373.877700] ata11: no sense translation for status: 0x00
[ 3373.877850] ata11: status=0x00 { }
[ 3373.878042] ata11: no sense translation for status: 0x00
[ 3373.878192] ata11: status=0x00 { }
[ 3373.878388] ata11: no sense translation for status: 0x00
[ 3373.878537] ata11: status=0x00 { }
[ 3373.878726] ata11: no sense translation for status: 0x00
[ 3373.878876] ata11: status=0x00 { }
[ 3373.878996] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.879117] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.879399] Descriptor sense data with sense descriptors (in hex):
[ 3373.879517]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.880442]         00 00 00 00 
[ 3373.880768] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.881150] ata11: no sense translation for status: 0x00
[ 3373.881300] ata11: status=0x00 { }
[ 3373.881419] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.881564] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.881849] Descriptor sense data with sense descriptors (in hex):
[ 3373.881968]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.882892]         00 00 00 00 
[ 3373.883206] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.883527] ata11: no sense translation for status: 0x00
[ 3373.883679] ata11: status=0x00 { }
...
[ 3373.899342] ata11: no sense translation for status: 0x00
[ 3373.899492] ata11: status=0x00 { }
[ 3373.899624] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.899746] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.900026] Descriptor sense data with sense descriptors (in hex):
[ 3373.900136]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.901020]         00 00 00 00 
[ 3373.901317] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.901626] ata11: no sense translation for status: 0x00
[ 3373.901763] ata11: status=0x00 { }
[ 3373.901871] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.901983] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.902245] Descriptor sense data with sense descriptors (in hex):
[ 3373.902356]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.903229]         00 00 00 00 
[ 3373.903525] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.903817] ata11: no sense translation for status: 0x00
[ 3373.903953] ata11: status=0x00 { }
[ 3373.904065] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.904176] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.904438] Descriptor sense data with sense descriptors (in hex):
[ 3373.904553]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.905438]         00 00 00 00 
[ 3373.905755] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.906050] ata11: no sense translation for status: 0x00
[ 3373.906186] ata11: status=0x00 { }
[ 3373.906296] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.906366] ata11: no sense translation for status: 0x00
[ 3373.906379] ata11: status=0x00 { }
...
[ 3373.907848] ata15: no sense translation for status: 0x00
[ 3373.907860] ata15: status=0x00 { }
[ 3373.907888] ata16: no sense translation for status: 0x40
[ 3373.907900] ata16: status=0x40 { DriveReady }
...
[ 3373.908281] ata16: no sense translation for status: 0x40
[ 3373.908294] ata16: status=0x40 { DriveReady }
[ 3373.936016] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.936294] Descriptor sense data with sense descriptors (in hex):
[ 3373.936406]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.937286]         00 00 00 00 
[ 3373.937595] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.937887] ata11: no sense translation for status: 0x00
[ 3373.938022] ata11: status=0x00 { }
[ 3373.938193] ata11: no sense translation for status: 0x00
[ 3373.938329] ata11: status=0x00 { }
[ 3373.938500] ata11: no sense translation for status: 0x00
[ 3373.938643] ata11: status=0x00 { }
[ 3373.938816] ata11: no sense translation for status: 0x00
[ 3373.938953] ata11: status=0x00 { }
[ 3373.939128] ata11: no sense translation for status: 0x00
[ 3373.939265] ata11: status=0x00 { }
[ 3373.939436] ata11: no sense translation for status: 0x00
[ 3373.939573] ata11: status=0x00 { }
[ 3373.939747] ata11: no sense translation for status: 0x00
[ 3373.939883] ata11: status=0x00 { }
[ 3373.939991] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.940106] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.940372] Descriptor sense data with sense descriptors (in hex):
[ 3373.940484]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.941368]         00 00 00 00 
[ 3373.941678] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.941975] ata11: no sense translation for status: 0x00
[ 3373.942111] ata11: status=0x00 { }
[ 3373.942219] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.942331] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.942594] Descriptor sense data with sense descriptors (in hex):
[ 3373.942703]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.943580]         00 00 00 00 
[ 3373.943876] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.944174] ata11: no sense translation for status: 0x00
[ 3373.944310] ata11: status=0x00 { }
...
[ 3373.957792] ata11: no sense translation for status: 0x00
[ 3373.957929] ata11: status=0x00 { }
[ 3373.958037] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.958148] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.958411] Descriptor sense data with sense descriptors (in hex):
[ 3373.958521]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.959390]         00 00 00 00 
[ 3373.959686] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.959973] ata11: no sense translation for status: 0x00
[ 3373.960113] ata11: status=0x00 { }
[ 3373.960221] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.960333] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.960601] Descriptor sense data with sense descriptors (in hex):
[ 3373.960711]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.961599]         00 00 00 00 
[ 3373.961896] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.962184] ata11: no sense translation for status: 0x00
[ 3373.962319] ata11: status=0x00 { }
[ 3373.962427] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.962538] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.962801] Descriptor sense data with sense descriptors (in hex):
[ 3373.962911]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.963781]         00 00 00 00 
[ 3373.964081] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.964373] ata11: no sense translation for status: 0x00
[ 3373.964509] ata11: status=0x00 { }
[ 3373.964622] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.964734] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.965001] Descriptor sense data with sense descriptors (in hex):
[ 3373.965111]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.965999]         00 00 00 00 
[ 3373.966296] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.966588] ata11: no sense translation for status: 0x00
[ 3373.966724] ata11: status=0x00 { }
[ 3373.966895] ata11: no sense translation for status: 0x00
[ 3373.967031] ata11: status=0x00 { }
[ 3373.967203] ata11: no sense translation for status: 0x00
[ 3373.967340] ata11: status=0x00 { }
[ 3373.967511] ata11: no sense translation for status: 0x00
[ 3373.967648] ata11: status=0x00 { }
[ 3373.967818] ata11: no sense translation for status: 0x00
[ 3373.967954] ata11: status=0x00 { }
[ 3373.968130] ata11: no sense translation for status: 0x00
[ 3373.968265] ata11: status=0x00 { }
[ 3373.968437] ata11: no sense translation for status: 0x00
[ 3373.968574] ata11: status=0x00 { }
[ 3373.968686] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.968798] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.969066] Descriptor sense data with sense descriptors (in hex):
[ 3373.969176]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.970064]         00 00 00 00 
[ 3373.970361] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.970650] ata11: no sense translation for status: 0x00
[ 3373.970786] ata11: status=0x00 { }
[ 3373.970893] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.971006] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.971266] Descriptor sense data with sense descriptors (in hex):
[ 3373.971376]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.972246]         00 00 00 00 
[ 3373.972546] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.972834] ata11: no sense translation for status: 0x00
[ 3373.972970] ata11: status=0x00 { }
...
[ 3373.986497] ata11: no sense translation for status: 0x00
[ 3373.986633] ata11: status=0x00 { }
[ 3373.986741] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.986853] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.987115] Descriptor sense data with sense descriptors (in hex):
[ 3373.987226]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.988108]         00 00 00 00 
[ 3373.988404] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.988706] ata11: no sense translation for status: 0x00
[ 3373.988842] ata11: status=0x00 { }
[ 3373.988951] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.989068] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.989329] Descriptor sense data with sense descriptors (in hex):
[ 3373.989439]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.990327]         00 00 00 00 
[ 3373.990624] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.990911] ata11: no sense translation for status: 0x00
[ 3373.991047] ata11: status=0x00 { }
[ 3373.991155] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.991267] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.991529] Descriptor sense data with sense descriptors (in hex):
[ 3373.991639]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.992515]         00 00 00 00 
[ 3373.992811] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.993122] ata11: no sense translation for status: 0x00
[ 3373.993258] ata11: status=0x00 { }
[ 3373.993366] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.993478] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.993761] Descriptor sense data with sense descriptors (in hex):
[ 3373.993871]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.994740]         00 00 00 00 
[ 3373.995038] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3373.995344] ata11: no sense translation for status: 0x00
[ 3373.995480] ata11: status=0x00 { }
[ 3373.995651] ata11: no sense translation for status: 0x00
[ 3373.995787] ata11: status=0x00 { }
[ 3373.995958] ata11: no sense translation for status: 0x00
[ 3373.996097] ata11: status=0x00 { }
[ 3373.996294] ata11: no sense translation for status: 0x00
[ 3373.996430] ata11: status=0x00 { }
[ 3373.996606] ata11: no sense translation for status: 0x00
[ 3373.996742] ata11: status=0x00 { }
[ 3373.996913] ata11: no sense translation for status: 0x00
[ 3373.997049] ata11: status=0x00 { }
[ 3373.997226] ata11: no sense translation for status: 0x00
[ 3373.997362] ata11: status=0x00 { }
[ 3373.997469] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3373.997601] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3373.997866] Descriptor sense data with sense descriptors (in hex):
[ 3373.997977]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3373.998844]         00 00 00 00 
[ 3373.999140] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.005618] ata11: no sense translation for status: 0x00
[ 3374.005754] ata11: status=0x00 { }
[ 3374.005862] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.005974] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.006236] Descriptor sense data with sense descriptors (in hex):
[ 3374.006346]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.007217]         00 00 00 00 
[ 3374.007514] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.007800] ata11: no sense translation for status: 0x00
[ 3374.007936] ata11: status=0x00 { }
...
[ 3374.015257] ata11: no sense translation for status: 0x00
[ 3374.015392] ata11: status=0x00 { }
[ 3374.015501] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.015613] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.015889] Descriptor sense data with sense descriptors (in hex):
[ 3374.015999]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.016876]         00 00 00 00 
[ 3374.017177] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.017464] ata11: no sense translation for status: 0x00
[ 3374.017600] ata11: status=0x00 { }
[ 3374.017728] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.017841] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.018105] Descriptor sense data with sense descriptors (in hex):
[ 3374.018215]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.019085]         00 00 00 00 
[ 3374.019381] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.019668] ata11: no sense translation for status: 0x00
[ 3374.019804] ata11: status=0x00 { }
[ 3374.019911] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.020026] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.020288] Descriptor sense data with sense descriptors (in hex):
[ 3374.020398]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.021277]         00 00 00 00 
[ 3374.021594] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.021882] ata11: no sense translation for status: 0x00
[ 3374.022018] ata11: status=0x00 { }
[ 3374.022126] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.022242] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.028679] Descriptor sense data with sense descriptors (in hex):
[ 3374.028798]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.029671]         00 00 00 00 
[ 3374.029968] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.030256] ata11: no sense translation for status: 0x00
[ 3374.030392] ata11: status=0x00 { }
[ 3374.030564] ata11: no sense translation for status: 0x00
[ 3374.030699] ata11: status=0x00 { }
[ 3374.030870] ata11: no sense translation for status: 0x00
[ 3374.031006] ata11: status=0x00 { }
[ 3374.031177] ata11: no sense translation for status: 0x00
[ 3374.031313] ata11: status=0x00 { }
[ 3374.031483] ata11: no sense translation for status: 0x00
[ 3374.031619] ata11: status=0x00 { }
[ 3374.031790] ata11: no sense translation for status: 0x00
[ 3374.031925] ata11: status=0x00 { }
[ 3374.032100] ata11: no sense translation for status: 0x00
[ 3374.032236] ata11: status=0x00 { }
[ 3374.032344] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.032455] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.032723] Descriptor sense data with sense descriptors (in hex):
[ 3374.032833]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.033724]         00 00 00 00 
[ 3374.034021] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.034308] ata11: no sense translation for status: 0x00
[ 3374.034444] ata11: status=0x00 { }
[ 3374.034552] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.034664] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.034925] Descriptor sense data with sense descriptors (in hex):
[ 3374.035036]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.035908]         00 00 00 00 
[ 3374.036209] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.036500] ata11: no sense translation for status: 0x00
[ 3374.036635] ata11: status=0x00 { }
...
[ 3374.050117] ata11: no sense translation for status: 0x00
[ 3374.050254] ata11: status=0x00 { }
[ 3374.050363] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.050475] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.050738] Descriptor sense data with sense descriptors (in hex):
[ 3374.050848]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.051715]         00 00 00 00 
[ 3374.052016] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.052303] ata11: no sense translation for status: 0x00
[ 3374.052439] ata11: status=0x00 { }
[ 3374.052552] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.052664] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.052927] Descriptor sense data with sense descriptors (in hex):
[ 3374.053038]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.053928]         00 00 00 00 
[ 3374.054224] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.054517] ata11: no sense translation for status: 0x00
[ 3374.054653] ata11: status=0x00 { }
[ 3374.054761] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.054874] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.055136] Descriptor sense data with sense descriptors (in hex):
[ 3374.055245]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.056115]         00 00 00 00 
[ 3374.056411] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.056704] ata11: no sense translation for status: 0x00
[ 3374.056840] ata11: status=0x00 { }
[ 3374.056948] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.057060] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.057324] Descriptor sense data with sense descriptors (in hex):
[ 3374.057433]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.058314]         00 00 00 00 
[ 3374.058611] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.058903] ata11: no sense translation for status: 0x00
[ 3374.059039] ata11: status=0x00 { }
[ 3374.059210] ata11: no sense translation for status: 0x00
[ 3374.059346] ata11: status=0x00 { }
[ 3374.059517] ata11: no sense translation for status: 0x00
[ 3374.059653] ata11: status=0x00 { }
[ 3374.059835] ata11: no sense translation for status: 0x00
[ 3374.059970] ata11: status=0x00 { }
[ 3374.060146] ata11: no sense translation for status: 0x00
[ 3374.060281] ata11: status=0x00 { }
[ 3374.060452] ata11: no sense translation for status: 0x00
[ 3374.060588] ata11: status=0x00 { }
[ 3374.060765] ata11: no sense translation for status: 0x00
[ 3374.060901] ata11: status=0x00 { }
[ 3374.061014] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.061125] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.061387] Descriptor sense data with sense descriptors (in hex):
[ 3374.061510]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.062377]         00 00 00 00 
[ 3374.062674] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.062962] ata11: no sense translation for status: 0x00
[ 3374.063097] ata11: status=0x00 { }
[ 3374.063206] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.063317] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.063579] Descriptor sense data with sense descriptors (in hex):
[ 3374.063689]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.064567]         00 00 00 00 
[ 3374.064867] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.065159] ata11: no sense translation for status: 0x00
[ 3374.065296] ata11: status=0x00 { }
...
[ 3374.078743] ata11: no sense translation for status: 0x00
[ 3374.078878] ata11: status=0x00 { }
[ 3374.079017] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.079129] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.079392] Descriptor sense data with sense descriptors (in hex):
[ 3374.079510]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.080405]         00 00 00 00 
[ 3374.080716] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.081005] ata11: no sense translation for status: 0x00
[ 3374.081141] ata11: status=0x00 { }
[ 3374.081256] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.081368] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.081645] Descriptor sense data with sense descriptors (in hex):
[ 3374.081755]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.082628]         00 00 00 00 
[ 3374.082926] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.083233] ata11: no sense translation for status: 0x00
[ 3374.083369] ata11: status=0x00 { }
[ 3374.083478] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.083590] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.083853] Descriptor sense data with sense descriptors (in hex):
[ 3374.083963]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.084847]         00 00 00 00 
[ 3374.085149] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.085443] ata11: no sense translation for status: 0x00
[ 3374.085530] ata11: status=0x00 { }
[ 3374.085702] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.085813] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.086076] Descriptor sense data with sense descriptors (in hex):
[ 3374.086186]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.087055]         00 00 00 00 
[ 3374.087353] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.087655] ata11: no sense translation for status: 0x00
[ 3374.087791] ata11: status=0x00 { }
[ 3374.087967] ata11: no sense translation for status: 0x00
[ 3374.088109] ata11: status=0x00 { }
[ 3374.088280] ata11: no sense translation for status: 0x00
[ 3374.088417] ata11: status=0x00 { }
[ 3374.088606] ata11: no sense translation for status: 0x00
[ 3374.088743] ata11: status=0x00 { }
[ 3374.088915] ata11: no sense translation for status: 0x00
[ 3374.089052] ata11: status=0x00 { }
[ 3374.089228] ata11: no sense translation for status: 0x00
[ 3374.089365] ata11: status=0x00 { }
[ 3374.089536] ata11: no sense translation for status: 0x00
[ 3374.089672] ata11: status=0x00 { }
[ 3374.089793] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.089905] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.090170] Descriptor sense data with sense descriptors (in hex):
[ 3374.090281]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.091154]         00 00 00 00 
[ 3374.091452] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.091742] ata11: no sense translation for status: 0x00
[ 3374.091878] ata11: status=0x00 { }
[ 3374.091987] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.092103] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.092367] Descriptor sense data with sense descriptors (in hex):
[ 3374.092477]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.093360]         00 00 00 00 
[ 3374.093670] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.093959] ata11: no sense translation for status: 0x00
[ 3374.094095] ata11: status=0x00 { }
...
[ 3374.107595] ata11: no sense translation for status: 0x00
[ 3374.107730] ata11: status=0x00 { }
[ 3374.107839] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.107951] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.108216] Descriptor sense data with sense descriptors (in hex):
[ 3374.108327]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.109199]         00 00 00 00 
[ 3374.109515] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.109806] ata11: no sense translation for status: 0x00
[ 3374.109943] ata11: status=0x00 { }
[ 3374.110051] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.110164] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.110428] Descriptor sense data with sense descriptors (in hex):
[ 3374.110538]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.111410]         00 00 00 00 
[ 3374.111708] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.111995] ata11: no sense translation for status: 0x00
[ 3374.112135] ata11: status=0x00 { }
[ 3374.112243] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.112356] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.112628] Descriptor sense data with sense descriptors (in hex):
[ 3374.112739]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.113624]         00 00 00 00 
[ 3374.113923] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.114213] ata11: no sense translation for status: 0x00
[ 3374.114349] ata11: status=0x00 { }
[ 3374.114458] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.114570] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.114837] Descriptor sense data with sense descriptors (in hex):
[ 3374.114948]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.115816]         00 00 00 00 
[ 3374.116125] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.116412] ata11: no sense translation for status: 0x00
[ 3374.116548] ata11: status=0x00 { }
[ 3374.116724] ata11: no sense translation for status: 0x00
[ 3374.116860] ata11: status=0x00 { }
[ 3374.117031] ata11: no sense translation for status: 0x00
[ 3374.117167] ata11: status=0x00 { }
[ 3374.117339] ata11: no sense translation for status: 0x00
[ 3374.117475] ata11: status=0x00 { }
[ 3374.117660] ata11: no sense translation for status: 0x00
[ 3374.117796] ata11: status=0x00 { }
[ 3374.117966] ata11: no sense translation for status: 0x00
[ 3374.118102] ata11: status=0x00 { }
[ 3374.121594] ata11: no sense translation for status: 0x00
[ 3374.121594] ata11: status=0x00 { }
[ 3374.124693] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.124805] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.125067] Descriptor sense data with sense descriptors (in hex):
[ 3374.125176]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.126056]         00 00 00 00 
[ 3374.126353] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.126643] ata11: no sense translation for status: 0x00
[ 3374.126779] ata11: status=0x00 { }
[ 3374.126887] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.127000] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.127263] Descriptor sense data with sense descriptors (in hex):
[ 3374.127373]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.128248]         00 00 00 00 
[ 3374.128547] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.128838] ata11: no sense translation for status: 0x00
[ 3374.128974] ata11: status=0x00 { }
...
[ 3374.136260] ata11: no sense translation for status: 0x00
[ 3374.136396] ata11: status=0x00 { }
[ 3374.136510] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.136625] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.136887] Descriptor sense data with sense descriptors (in hex):
[ 3374.136997]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.137885]         00 00 00 00 
[ 3374.138182] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.138471] ata11: no sense translation for status: 0x00
[ 3374.138607] ata11: status=0x00 { }
[ 3374.138715] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.138828] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.139090] Descriptor sense data with sense descriptors (in hex):
[ 3374.139200]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.140075]         00 00 00 00 
[ 3374.140372] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.140671] ata11: no sense translation for status: 0x00
[ 3374.140807] ata11: status=0x00 { }
[ 3374.140916] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.141028] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.141291] Descriptor sense data with sense descriptors (in hex):
[ 3374.147574]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.148456]         00 00 00 00 
[ 3374.148758] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.149051] ata11: no sense translation for status: 0x00
[ 3374.149188] ata11: status=0x00 { }
[ 3374.149296] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.149409] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.149691] Descriptor sense data with sense descriptors (in hex):
[ 3374.149802]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.150677]         00 00 00 00 
[ 3374.150974] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.151262] ata11: no sense translation for status: 0x00
[ 3374.151398] ata11: status=0x00 { }
[ 3374.151569] ata11: no sense translation for status: 0x00
[ 3374.151705] ata11: status=0x00 { }
[ 3374.151875] ata11: no sense translation for status: 0x00
[ 3374.152011] ata11: status=0x00 { }
[ 3374.152183] ata11: no sense translation for status: 0x00
[ 3374.152319] ata11: status=0x00 { }
[ 3374.152492] ata11: no sense translation for status: 0x00
[ 3374.152628] ata11: status=0x00 { }
[ 3374.152806] ata11: no sense translation for status: 0x00
[ 3374.152942] ata11: status=0x00 { }
[ 3374.153114] ata11: no sense translation for status: 0x00
[ 3374.153250] ata11: status=0x00 { }
[ 3374.153358] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.153469] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.153758] Descriptor sense data with sense descriptors (in hex):
[ 3374.153869]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.154740]         00 00 00 00 
[ 3374.155037] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.155327] ata11: no sense translation for status: 0x00
[ 3374.155463] ata11: status=0x00 { }
[ 3374.155576] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.155688] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.155952] Descriptor sense data with sense descriptors (in hex):
[ 3374.156061]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.156966]         00 00 00 00 
[ 3374.157263] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.157533] ata11: no sense translation for status: 0x00
[ 3374.157533] ata11: status=0x00 { }
...
[ 3374.171194] ata11: no sense translation for status: 0x00
[ 3374.171330] ata11: status=0x00 { }
[ 3374.171439] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.171551] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.171813] Descriptor sense data with sense descriptors (in hex):
[ 3374.171923]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.172806]         00 00 00 00 
[ 3374.173103] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.173329] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.173441] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.173730] Descriptor sense data with sense descriptors (in hex):
[ 3374.173842]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.174720]         00 00 00 00 
[ 3374.175017] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.175259] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.175371] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.175634] Descriptor sense data with sense descriptors (in hex):
[ 3374.175743]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.176623]         00 00 00 00 
[ 3374.176921] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.177145] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.177257] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.177538] Descriptor sense data with sense descriptors (in hex):
[ 3374.177657]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.178526]         00 00 00 00 
[ 3374.178823] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.179112] ata11: no sense translation for status: 0x00
[ 3374.179247] ata11: status=0x00 { }
[ 3374.179418] ata11: no sense translation for status: 0x00
[ 3374.179555] ata11: status=0x00 { }
[ 3374.179664] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.179776] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.180045] Descriptor sense data with sense descriptors (in hex):
[ 3374.180156]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.181031]         00 00 00 00 
[ 3374.181328] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3374.181570] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3374.181684] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3374.181947] Descriptor sense data with sense descriptors (in hex):
[ 3374.182057]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3374.182931]         00 00 00 00 
[ 3374.183228] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3404.780314] ata11: no sense translation for status: 0x00
[ 3404.780466] ata11: status=0x00 { }
[ 3404.780664] ata11: no sense translation for status: 0x00
[ 3404.780814] ata11: status=0x00 { }
[ 3404.781031] ata11: no sense translation for status: 0x00
[ 3404.781180] ata11: status=0x00 { }
[ 3404.781381] ata11: no sense translation for status: 0x00
[ 3404.781531] ata11: status=0x00 { }
[ 3404.781743] ata11: no sense translation for status: 0x00
[ 3404.781894] ata11: status=0x00 { }
[ 3404.782080] ata11: no sense translation for status: 0x00
[ 3404.782230] ata11: status=0x00 { }
[ 3404.782431] ata11: no sense translation for status: 0x00
[ 3404.782580] ata11: status=0x00 { }
[ 3404.782766] ata11: no sense translation for status: 0x00
[ 3404.782915] ata11: status=0x00 { }
[ 3404.783101] ata11: no sense translation for status: 0x00
[ 3404.783253] ata11: status=0x00 { }
[ 3404.783440] ata11: no sense translation for status: 0x00
[ 3404.783589] ata11: status=0x00 { }
[ 3404.783785] ata11: no sense translation for status: 0x00
[ 3404.783933] ata11: status=0x00 { }
[ 3404.784120] ata11: no sense translation for status: 0x00
[ 3404.784272] ata11: status=0x00 { }
[ 3404.784458] ata11: no sense translation for status: 0x00
[ 3404.784607] ata11: status=0x00 { }
[ 3404.784734] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3404.784864] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3404.785156] Descriptor sense data with sense descriptors (in hex):
[ 3404.785275]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3404.786237]         00 00 00 00 
[ 3404.786550] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3404.786793] __ratelimit: 282 callbacks suppressed
[ 3404.786932] lost page write due to I/O error on md2
[ 3404.787082] lost page write due to I/O error on md2
[ 3404.787227] lost page write due to I/O error on md2
[ 3404.787373] lost page write due to I/O error on md2
[ 3404.787514] lost page write due to I/O error on md2
[ 3404.787656] lost page write due to I/O error on md2
[ 3404.787797] lost page write due to I/O error on md2
[ 3404.787940] lost page write due to I/O error on md2
[ 3404.788081] lost page write due to I/O error on md2
[ 3404.788230] lost page write due to I/O error on md2
[ 3404.788419] ata11: no sense translation for status: 0x00
[ 3404.788570] ata11: status=0x00 { }
[ 3404.788757] ata11: no sense translation for status: 0x00
[ 3404.788907] ata11: status=0x00 { }
[ 3404.789102] ata11: no sense translation for status: 0x00
[ 3404.789252] ata11: status=0x00 { }
[ 3404.789450] ata11: no sense translation for status: 0x00
[ 3404.789550] ata11: status=0x00 { }
[ 3404.789814] ata11: no sense translation for status: 0x00
[ 3404.789968] ata11: status=0x00 { }
[ 3404.790156] ata11: no sense translation for status: 0x00
[ 3404.790306] ata11: status=0x00 { }
[ 3404.790493] ata11: no sense translation for status: 0x00
[ 3404.790643] ata11: status=0x00 { }
[ 3404.790844] ata11: no sense translation for status: 0x00
[ 3404.790994] ata11: status=0x00 { }
[ 3404.791181] ata11: no sense translation for status: 0x00
[ 3404.791330] ata11: status=0x00 { }
[ 3404.791454] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3404.791581] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3404.791871] Descriptor sense data with sense descriptors (in hex):
[ 3404.791993]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3404.792913]         00 00 00 00 
[ 3404.793245] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3404.793627] ata11: no sense translation for status: 0x00
[ 3404.793778] ata11: status=0x00 { }
[ 3404.793967] ata11: no sense translation for status: 0x00
[ 3404.794116] ata11: status=0x00 { }
[ 3404.794317] ata11: no sense translation for status: 0x00
[ 3404.794467] ata11: status=0x00 { }
[ 3404.794655] ata11: no sense translation for status: 0x00
[ 3404.794808] ata11: status=0x00 { }
[ 3404.794996] ata11: no sense translation for status: 0x00
[ 3404.795146] ata11: status=0x00 { }
[ 3404.795332] ata11: no sense translation for status: 0x00
[ 3404.795482] ata11: status=0x00 { }
[ 3404.795679] ata11: no sense translation for status: 0x00
[ 3404.797504] ata11: status=0x00 { }
[ 3404.802213] ata11: no sense translation for status: 0x00
[ 3404.802363] ata11: status=0x00 { }
[ 3404.802484] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3404.802605] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3404.802884] Descriptor sense data with sense descriptors (in hex):
[ 3404.803003]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3404.803929]         00 00 00 00 
[ 3404.804243] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3404.804499] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3404.804620] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3404.804899] Descriptor sense data with sense descriptors (in hex):
[ 3404.805023]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3404.805974]         00 00 00 00 
[ 3404.806288] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3404.806535] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3404.806666] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3404.806944] Descriptor sense data with sense descriptors (in hex):
[ 3404.807063]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3404.807997]         00 00 00 00 
[ 3404.808311] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3404.808556] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3404.808677] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3404.808965] Descriptor sense data with sense descriptors (in hex):
[ 3404.809092]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3404.810052]         00 00 00 00 
[ 3404.810365] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3404.810614] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3404.810735] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3404.811021] Descriptor sense data with sense descriptors (in hex):
[ 3404.811143]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3404.812058]         00 00 00 00 
[ 3404.812392] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3404.812637] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3404.812759] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3404.813044] Descriptor sense data with sense descriptors (in hex):
[ 3404.813164]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3404.814113]         00 00 00 00 
[ 3404.814436] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3404.814682] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3404.814804] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3404.815083] Descriptor sense data with sense descriptors (in hex):
[ 3404.815201]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3404.816130]         00 00 00 00 
[ 3404.816444] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information
[ 3404.816699] sd 2:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[ 3404.816820] sd 2:0:0:0: [sdc] Sense Key : Aborted Command [current] 
[descriptor]
[ 3404.817107] Descriptor sense data with sense descriptors (in hex):
[ 3404.817226]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
[ 3404.818176]         00 00 00 00 
[ 3404.818493] sd 2:0:0:0: [sdc] Add. Sense: No additional sense information

sdc isn't even the disk having problems. Only that the disk that is having 
problems is causing the Marvell SATA controller to lock up, causing linux to 
get errors for all disks connected.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
