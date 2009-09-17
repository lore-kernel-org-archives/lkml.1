Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbZIQR5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbZIQR5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759253AbZIQR5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:57:21 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:65534 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830AbZIQR5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:57:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Sa2/U6bc5X/gqyIT6MZwjj0QVn5/kpKz3eN7XQy99xWlifnvpsme2bDsfVrGGgIJaR
         zllp7M+rxEITNDqAmp1zxqK/wE9VgNfjPI1BPPvchTvFjwPacUoglk30oYmed53V0TxA
         t6jlWEDSAGrhYcqKaqk8/Jtu0AMa8yJNFA2fg=
MIME-Version: 1.0
In-Reply-To: <4AA5E5F3.30309@primeinteractive.net>
References: <4AA5E5F3.30309@primeinteractive.net>
From: Nao Nakashima <nao.nakashima@gmail.com>
Date: Thu, 17 Sep 2009 23:56:51 +0600
Message-ID: <570e33fe0909171056x774ebbe5jc461e5a044d8d31@mail.gmail.com>
Subject: Re: ext4+quota+nfs issue
To: Pavol Cvengros <pavol.cvengros@primeinteractive.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
I have a similiar issues with kernels 2.6.30-gentoo-r4 and
2.6.31-gentoo (vanilla + this patches:
http://dev.gentoo.org/~dsd/genpatches)
Size of ext4 file system is 457Gb. fs located on LVM2, converted from
ext3 and resized (with resize2fs) many times after.
quotas are turned on and set for one user.
NFS are not used at all.

warnings are below:
------------[ cut here ]------------
WARNING: at fs/quota/dquot.c:964 dquot_claim_space+0x64/0x150()
Hardware name:
Modules linked in: vfat fat sit tunnel4 radeon drm ipv6 snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device pppoe pppox ppp_generic slhc
bridge stp llc ipt_REJECT xt_state xt_multiport iptable_filter
xt_comment xt_owner xt_DSCP iptable_mangle iptable_raw ipt_MASQUERADE
ipt_REDIRECT xt_tcpudp iptable_nat nf_nat nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 ip_tables x_tables joydev gamecon
snd_pcm_oss snd_mixer_oss analog gameport pcspkr snd_intel8x0
snd_ac97_codec ac97_bus snd_pcm snd_timer snd parport_pc nvidia_agp
snd_page_alloc agpgart forcedeth parport evdev
Pid: 28435, comm: pdflush Not tainted 2.6.30-gentoo-r4 #1
Call Trace:
 [<c01b44f4>] ? dquot_claim_space+0x64/0x150
 [<c01b44f4>] ? dquot_claim_space+0x64/0x150
 [<c011bb06>] ? warn_slowpath_common+0x76/0xd0
 [<c01b44f4>] ? dquot_claim_space+0x64/0x150
 [<c011bb73>] ? warn_slowpath_null+0x13/0x20
 [<c01b44f4>] ? dquot_claim_space+0x64/0x150
 [<c02315e6>] ? ext4_mb_mark_diskspace_used+0x466/0x480
 [<c0234e50>] ? ext4_mb_new_blocks+0x300/0x490
 [<c022afa4>] ? ext4_ext_find_extent+0x124/0x2d0
 [<c022d209>] ? ext4_ext_get_blocks+0xac9/0xed0
 [<c0264152>] ? generic_make_request+0x1d2/0x370
 [<c0119732>] ? scheduler_tick+0x82/0x90
 [<c01240d2>] ? run_timer_softirq+0x12/0x180
 [<c0219292>] ? ext4_get_blocks_wrap+0x1b2/0x2f0
 [<c0219807>] ? mpage_da_map_blocks+0xc7/0x860
 [<c015f98a>] ? pagevec_lookup_tag+0x2a/0x40
 [<c015df14>] ? write_cache_pages+0xd4/0x360
 [<c021a4a0>] ? __mpage_da_writepage+0x0/0x170
 [<c023f98f>] ? jbd2_journal_start+0x7f/0xc0
 [<c021a244>] ? ext4_da_writepages+0x2a4/0x410
 [<c019d650>] ? __bread+0x10/0xb0
 [<c0219fa0>] ? ext4_da_writepages+0x0/0x410
 [<c015e1fb>] ? do_writepages+0x2b/0x50
 [<c0195996>] ? __writeback_single_inode+0x76/0x3a0
 [<c01960ce>] ? generic_sync_sb_inodes+0x24e/0x3c0
 [<c0196391>] ? writeback_inodes+0x31/0xa0
 [<c015e82c>] ? background_writeout+0x9c/0xc0
 [<c015ef40>] ? pdflush+0x0/0x1a0
 [<c015f01f>] ? pdflush+0xdf/0x1a0
 [<c015e790>] ? background_writeout+0x0/0xc0
 [<c012d730>] ? kthread+0x40/0x70
 [<c012d6f0>] ? kthread+0x0/0x70
 [<c0103513>] ? kernel_thread_helper+0x7/0x14
---[ end trace 5d62dca1c9500b01 ]---

------------[ cut here ]------------
WARNING: at fs/quota/dquot.c:964 dquot_claim_space+0x64/0x150()
Hardware name:
Modules linked in: radeon drm snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device ipv6 pppoe pppox ppp_generic slhc bridge stp llc
ipt_MASQUERADE ipt_REDIRECT iptable_nat nf_nat iptable_raw xt_owner
xt_DSCP iptable_mangle ipt_REJECT xt_tcpudp nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack xt_comment xt_multiport
iptable_filter ip_tables x_tables joydev gamecon snd_pcm_oss
snd_mixer_oss analog gameport pcspkr parport_pc snd_intel8x0 parport
snd_ac97_codec ac97_bus snd_pcm snd_timer snd evdev forcedeth
snd_page_alloc nvidia_agp agpgart
Pid: 274, comm: pdflush Not tainted 2.6.31-gentoo #2
Call Trace:
 [<c10b9614>] ? dquot_claim_space+0x64/0x150
 [<c10b9614>] ? dquot_claim_space+0x64/0x150
 [<c101d0d6>] ? warn_slowpath_common+0x76/0xd0
 [<c10b9614>] ? dquot_claim_space+0x64/0x150
 [<c101d143>] ? warn_slowpath_null+0x13/0x20
 [<c10b9614>] ? dquot_claim_space+0x64/0x150
 [<c113874e>] ? ext4_mb_mark_diskspace_used+0x2fe/0x310
 [<c113ad30>] ? ext4_mb_new_blocks+0x300/0x490
 [<c11463a7>] ? __jbd2_journal_file_buffer+0x77/0x1e0
 [<c11161ed>] ? ext4_new_meta_blocks+0xbd/0xd0
 [<c113193c>] ? ext4_ext_insert_extent+0x1dc/0x1040
 [<c1138ca1>] ? ext4_mb_release_context+0xf1/0x300
 [<c113abf0>] ? ext4_mb_new_blocks+0x1c0/0x490
 [<c129787b>] ? __split_and_process_bio+0x52b/0x770
 [<c113324e>] ? ext4_ext_get_blocks+0xaae/0xe60
 [<c1178de0>] ? cfq_merged_request+0x0/0x60
 [<c116ab28>] ? elv_merged_request+0x28/0xb0
 [<c116cb32>] ? generic_make_request+0x1d2/0x370
 [<c10a1ac3>] ? bio_alloc_bioset+0x33/0xf0
 [<c111c7f9>] ? check_block_validity+0x39/0xb0
 [<c111de6a>] ? ext4_get_blocks+0x1ea/0x380
 [<c116cd16>] ? submit_bio+0x46/0xd0
 [<c111e3b0>] ? mpage_da_map_blocks+0xc0/0x8b0
 [<c1059c90>] ? find_get_pages_tag+0x40/0xb0
 [<c106209a>] ? pagevec_lookup_tag+0x2a/0x40
 [<c1060554>] ? write_cache_pages+0xd4/0x360
 [<c111f0a0>] ? __mpage_da_writepage+0x0/0x180
 [<c114794f>] ? jbd2_journal_start+0x7f/0xc0
 [<c111ee3c>] ? ext4_da_writepages+0x29c/0x410
 [<c111eba0>] ? ext4_da_writepages+0x0/0x410
 [<c106083b>] ? do_writepages+0x2b/0x50
 [<c1098e0b>] ? writeback_single_inode+0x15b/0x360
 [<c109941e>] ? generic_sync_sb_inodes+0x24e/0x3c0
 [<c1099651>] ? writeback_inodes+0x31/0xa0
 [<c1060e69>] ? background_writeout+0x99/0xc0
 [<c1061580>] ? pdflush+0x0/0x1a0
 [<c106165f>] ? pdflush+0xdf/0x1a0
 [<c1060dd0>] ? background_writeout+0x0/0xc0
 [<c102e84c>] ? kthread+0x7c/0x90
 [<c102e7d0>] ? kthread+0x0/0x90
 [<c1003513>] ? kernel_thread_helper+0x7/0x14
---[ end trace caa6ce044da37453 ]---

This is info after about 8 hours from last warning (computer are not
rebooted within this period):
$ sudo quota -u virma
Disk quotas for user virma (uid 1002):
     Filesystem  blocks   quota   limit   grace   files   quota   limit   grace
/dev/mapper/vg-home
                7048538  8718592 9018592            4139       0       0
$ quotastats
Kernel quota version: 6.5.1
Number of dquot lookups: 167609
Number of dquot drops: 166913
Number of dquot reads: 6
Number of dquot writes: 8
Number of quotafile syncs: 44
Number of dquot cache hits: 167603
Number of allocated dquots: 6
Number of free dquots: 2
Number of in use dquot entries (user/group): 4

$ sudo dumpe2fs -h /dev/vg/home
dumpe2fs 1.41.3 (12-Oct-2008)
Filesystem volume name:   <none>
Last mounted on:          /home
Filesystem UUID:          6efb6e9c-ffb0-4508-990c-bbd7f33973de
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index
filetype needs_recovery extent flex_bg sparse_super large_file
huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash
Default mount options:    user_xattr acl
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              30384128
Block count:              121528320
Reserved block count:     607358
Free blocks:              3519198
Free inodes:              29730602
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      995
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Fri May 22 02:14:00 2009
Last mount time:          Wed Sep 16 15:42:09 2009
Last write time:          Wed Sep 16 15:42:09 2009
Mount count:              1
Maximum mount count:      39
Last checked:             Wed Sep 16 15:17:15 2009
Check interval:           15552000 (6 months)
Next check after:         Mon Mar 15 14:17:15 2010
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:              256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      08226871-9df1-4fe7-ad56-3dbc308c555b
Journal backup:           inode blocks
Journal size:             128M

$ grep /dev/vg/home /etc/fstab
/dev/vg/home        /home            ext4        noatime,acl,usrquota    0 2


On Tue, Sep 8, 2009 at 11:04 AM, Pavol Cvengros
<pavol.cvengros@primeinteractive.net> wrote:
>
> Hello,
>
> recently we have build and started to use raid storage with formatted capacity of 4.5T (ext4 formatted, default params).
> FS has quota turned on and is exported via NFS to nodes.
> If we turn qouta on on this FS and are trying to use it over NFS we get the following:
>
> ------------[ cut here ]------------
> WARNING: at fs/quota/dquot.c:964 dquot_claim_space+0x181/0x190()
> Hardware name: S3210SH
> Modules linked in: nfs fscache nfsd lockd auth_rpcgss exportfs sunrpc coretemp hwmon ipmi_si ipmi_msghandler ehci_hcd sr_mod cdrom uhci_hcd floppy usbcore i2c_i801 i2c_core processor 3w_9xxx button thermal
> Pid: 268, comm: pdflush Tainted: G        W  2.6.30-gentoo-r3_host #1
> Call Trace:
>  [<ffffffff803151e1>] ? dquot_claim_space+0x181/0x190
>  [<ffffffff80245c59>] ? warn_slowpath_common+0x89/0x100
>  [<ffffffff803151e1>] ? dquot_claim_space+0x181/0x190
>  [<ffffffff80367e83>] ? ext4_mb_mark_diskspace_used+0x423/0x440
>  [<ffffffff8036c05f>] ? ext4_mb_new_blocks+0x2cf/0x460
>  [<ffffffff80360a17>] ? ext4_ext_find_extent+0x307/0x330
>  [<ffffffff80362508>] ? ext4_ext_get_blocks+0x578/0xfc0
>  [<ffffffff8028e828>] ? __pagevec_free+0x48/0x70
>  [<ffffffff803a1c65>] ? blk_rq_bio_prep+0x35/0x130
>  [<ffffffff8034d310>] ? ext4_get_blocks_wrap+0x210/0x380
>  [<ffffffff8034d8d8>] ? mpage_da_map_blocks+0xe8/0x750
>  [<ffffffff80292cee>] ? pagevec_lookup_tag+0x2e/0x50
>  [<ffffffff8029084c>] ? write_cache_pages+0x11c/0x400
>  [<ffffffff8034e500>] ? __mpage_da_writepage+0x0/0x190
>  [<ffffffff8034e269>] ? ext4_da_writepages+0x329/0x4b0
>  [<ffffffff80290bd2>] ? do_writepages+0x32/0x70
>  [<ffffffff802e4140>] ? __writeback_single_inode+0xb0/0x490
>  [<ffffffff8023c753>] ? dequeue_entity+0x23/0x1c0
>  [<ffffffff802e4b16>] ? generic_sync_sb_inodes+0x316/0x4f0
>  [<ffffffff802e4f4e>] ? writeback_inodes+0x5e/0x110
>  [<ffffffff80290e56>] ? wb_kupdate+0xc6/0x160
>  [<ffffffff80292110>] ? pdflush+0x120/0x230
>  [<ffffffff80290d90>] ? wb_kupdate+0x0/0x160
>  [<ffffffff80291ff0>] ? pdflush+0x0/0x230
>  [<ffffffff80261154>] ? kthread+0x64/0xc0
>  [<ffffffff8020d13a>] ? child_rip+0xa/0x20
>  [<ffffffff802610f0>] ? kthread+0x0/0xc0
>  [<ffffffff8020d130>] ? child_rip+0x0/0x20
> ---[ end trace cb54e6523e9ab60d ]---
>
> fstab entry:
> /dev/sdb1              /mnt/storage    ext4            noatime,nodiratime,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0
>
> qith quotaoff on tihs FS, warnings stop.
>
> Question is if it's safe to use quotas with this problem (warning) or not. Can't afford data damage.
>
> Thanks,
>
> Pavol Cvengros
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
