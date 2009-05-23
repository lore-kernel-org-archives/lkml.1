Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbZEWJSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbZEWJSm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 05:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZEWJSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 05:18:35 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:57981 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbZEWJSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 05:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=d7DBDnpzGIAnWKtn4ROUGN9aYMZ8rLvMRp5dGRBL6ZDVcEzeDwhd19evnkVRICKSYp
         I5EpuW9OVJJWTWu68P8f+CbeODU0GneV44A7xe+qg+S3BtN5buhRoojV7eDO+DuQDZ42
         BfKLncPsvzzsp1o9QolxbpB2IByA/Uv3bjcaw=
Message-ID: <4A17BF44.2030703@gmail.com>
Date: Sat, 23 May 2009 11:17:56 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1pre) Gecko/20090521 Shredder/3.0b3pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <ckpL0-3TE-3@gated-at.bofh.it> <ckpL0-3TE-5@gated-at.bofh.it> <ckpL0-3TE-7@gated-at.bofh.it> <ckpL0-3TE-9@gated-at.bofh.it> <ckpL0-3TE-11@gated-at.bofh.it> <ckpL0-3TE-1@gated-at.bofh.it> <cllvN-2Gf-1@gated-at.bofh.it> <49D0D788.6070405@gmail.com> <49D419E8.2080603@kernel.org> <49D4591B.3070807@gmail.com> <49D46096.1040701@kernel.org> <49D49B8A.7070408@gmail.com> <49D4C886.1010101@gmail.com> <49D6E7FA.3000306@kernel.org> <49D98C9E.2000507@gmail.com> <49D9D4D8.2020608@kernel.org> <49DA489E.1030801@gmail.com> <49DA5A83.2070002@kernel.org> <49DA7392.4020809@gmail.com> <49DE3BE3.80806@kernel.org>
In-Reply-To: <49DE3BE3.80806@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2009 08:18 PM, Tejun Heo wrote:
> Hmm... none of the debugging messages got triggered, so there should
> be no noticeable timing change.  It seems like you're being lucky for
> the time being.  Can you please keep testing and report back?

Hi Tejun,

Just to keep you up informed - this issue is still happening, I've been 
testing the latest 2.6.30-git kernels the last couple of weeks and just 
checked my logs after having an unexpected fsck upon system boot - the 
freeze seems to trigger very infrequently though, since I use s2disk at 
least twice a day and the error only seems to have happened twice since 
May 2.

I had a look at your 2.6.29 debug patch, it does "Hunk #6 succeeded at 
3368" so it should still be good (I hope), I'll try and run with it for 
a while.

The fsck output also seems a bit odd, on boot it displays a bunch of 
newlines and the partition name without a *real* message (the ^H being 
newlines):
/dev/disk/by-id/ata-HITACHI_HTS722020K9SA00_FDE_080726DP0470DTGMUNPC-part6: 
||  0.9%
<progress bar skipped>
^H- 56.5%
/dev/disk/by-id/ata-HITACHI_HTS722020K9SA00_FDE_080726DP0470DTGMUNPC-part6: 
|                                                                                                                            
^H\ 56.7%
/dev/disk/by-id/ata-HITACHI_HTS722020K9SA00_FDE_080726DP0470DTGMUNPC-part6: 
|                                                                                                                            
^H| 57.1%
/dev/disk/by-id/ata-HITACHI_HTS722020K9SA00_FDE_080726DP0470DTGMUNPC-part6: 
|


Thanks,
Niel


linux-7vph:~ # uname -r
2.6.30-rc6-pae

linux-7vph:~# rpm -qf `which fsck`
e2fsprogs-1.41.4-2.1

linux-7vph:~# lspci -vvv|grep -i sata
00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI 
Controller (rev 03) (prog-if 01 [AHCI 1.0])

/var/log/warn:
<snip>
May 22 09:28:55 linux-7vph kernel: Syncing filesystems ... done.
May 22 09:28:55 linux-7vph kernel: Freezing user space processes ... 
(elapsed 0.00 seconds) done.
May 22 09:28:55 linux-7vph kernel: Freezing remaining freezable tasks 
... (elapsed 0.00 seconds) done.
May 22 09:28:55 linux-7vph kernel: Suspending console(s) (use 
no_console_suspend to debug)
May 22 09:28:57 linux-7vph kernel: Disabling non-boot CPUs ...
May 22 09:28:57 linux-7vph kernel: CPU1 is down
May 22 09:28:57 linux-7vph kernel: Enabling non-boot CPUs ...
May 22 09:28:57 linux-7vph kernel: microcode: failed to init CPU1
May 22 09:28:57 linux-7vph kernel: CPU1 is up
May 22 09:28:57 linux-7vph kernel: e1000e 0000:00:19.0: 
pci_enable_pcie_error_reporting failed 0xfffffffb
May 22 09:28:58 linux-7vph kernel: ata1: exception Emask 0x10 SAct 0x0 
SErr 0x0 action 0x9 t4
May 22 09:28:58 linux-7vph kernel: ata1: irq_stat 0x00400040, connection 
status changed
May 22 09:28:58 linux-7vph kernel: Restarting tasks ... done.
May 22 09:28:58 linux-7vph kernel: ata2: exception Emask 0x10 SAct 0x0 
SErr 0x0 action 0x9 t4
May 22 09:28:58 linux-7vph kernel: ata2: irq_stat 0x40000001
May 22 09:28:58 linux-7vph kernel: ata1.00: exception Emask 0x10 SAct 
0x1ff SErr 0x50000 action 0xe frozen
May 22 09:28:58 linux-7vph kernel: ata1.00: irq_stat 0x00400008, PHY RDY 
changed
May 22 09:28:58 linux-7vph kernel: ata1: SError: { PHYRdyChg CommWake }
May 22 09:28:58 linux-7vph kernel: ata1.00: cmd 
60/40:00:91:ca:b5/00:00:09:00:00/40 tag 0 ncq 32768 in
May 22 09:28:58 linux-7vph kernel:          res 
50/00:e8:5f:8e:2b/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 22 09:28:59 linux-7vph kernel: ata1.00: status: { DRDY }
May 22 09:28:59 linux-7vph kernel: ata1.00: cmd 
60/40:08:91:d4:b5/00:00:09:00:00/40 tag 1 ncq 32768 in
May 22 09:28:59 linux-7vph kernel:          res 
50/00:e8:5f:8e:2b/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 22 09:28:59 linux-7vph kernel: ata1.00: status: { DRDY }
May 22 09:28:59 linux-7vph kernel: ata1.00: cmd 
60/40:10:51:d2:b5/00:00:09:00:00/40 tag 2 ncq 32768 in
May 22 09:28:59 linux-7vph kernel:          res 
50/00:e8:5f:8e:2b/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 22 09:28:59 linux-7vph kernel: ata1.00: status: { DRDY }
May 22 09:28:59 linux-7vph kernel: ata1.00: cmd 
60/40:18:11:cd:b5/00:00:09:00:00/40 tag 3 ncq 32768 in
May 22 09:28:59 linux-7vph kernel:          res 
50/00:e8:5f:8e:2b/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 22 09:28:59 linux-7vph kernel: ata1.00: status: { DRDY }
May 22 09:28:59 linux-7vph kernel: ata1.00: cmd 
60/40:20:11:0a:b7/00:00:09:00:00/40 tag 4 ncq 32768 in
May 22 09:28:59 linux-7vph kernel:          res 
50/00:e8:5f:8e:2b/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 22 09:28:59 linux-7vph kernel: ata1.00: status: { DRDY }
May 22 09:28:59 linux-7vph kernel: ata1.00: cmd 
60/40:28:d1:2b:b6/00:00:09:00:00/40 tag 5 ncq 32768 in
May 22 09:28:59 linux-7vph kernel:          res 
50/00:e8:5f:8e:2b/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 22 09:28:59 linux-7vph kernel: ata1.00: status: { DRDY }
May 22 09:28:59 linux-7vph kernel: ata1.00: cmd 
60/40:30:91:c3:b5/00:00:09:00:00/40 tag 6 ncq 32768 in
May 22 09:28:59 linux-7vph kernel:          res 
50/00:e8:5f:8e:2b/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 22 09:28:59 linux-7vph kernel: ata1.00: status: { DRDY }
May 22 09:28:59 linux-7vph kernel: ata1.00: cmd 
60/08:38:5f:88:2e/00:00:0b:00:00/40 tag 7 ncq 4096 in
May 22 09:29:01 linux-7vph kernel:          res 
50/00:e8:5f:8e:2b/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 22 09:29:01 linux-7vph kernel: ata1.00: status: { DRDY }
May 22 09:29:02 linux-7vph kernel: ata1.00: cmd 
60/e8:40:5f:8e:2b/00:00:0b:00:00/40 tag 8 ncq 118784 in
May 22 09:29:02 linux-7vph kernel:          res 
50/00:e8:5f:8e:2b/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 22 09:29:02 linux-7vph kernel: ata1.00: status: { DRDY }
May 22 09:29:03 linux-7vph kernel: Descriptor sense data with sense 
descriptors (in hex):
May 22 09:29:03 linux-7vph kernel: end_request: I/O error, dev sda, 
sector 187403871
May 22 09:29:03 linux-7vph kernel: EXT4-fs error (device sda6): 
__ext4_get_inode_loc: unable to read inode block - inode=641187, 
block=2556122
May 22 09:29:03 linux-7vph kernel: EXT4-fs error (device sda6) in 
ext4_reserve_inode_write: IO failure
<snip>

and an older one, could have been 2.6.30-rc5, I'm not sure:
May 14 07:47:17 linux-7vph kernel: Syncing filesystems ... done.
May 14 07:47:18 linux-7vph kernel: Freezing user space processes ... 
(elapsed 0.00 seconds) done.
May 14 07:47:18 linux-7vph kernel: Freezing remaining freezable tasks 
... (elapsed 0.00 seconds) done.
May 14 07:47:18 linux-7vph kernel: Suspending console(s) (use 
no_console_suspend to debug)
May 14 07:47:18 linux-7vph kernel: Disabling non-boot CPUs ...
May 14 07:47:18 linux-7vph kernel: CPU1 is down
May 14 07:47:18 linux-7vph kernel: Enabling non-boot CPUs ...
May 14 07:47:18 linux-7vph kernel: microcode: failed to init CPU1
May 14 07:47:18 linux-7vph kernel: CPU1 is up
May 14 07:47:19 linux-7vph kernel: e1000e 0000:00:19.0: 
pci_enable_pcie_error_reporting failed 0xfffffffb
May 14 07:47:19 linux-7vph kernel: ata1: exception Emask 0x10 SAct 0x0 
SErr 0x0 action 0x9 t4
May 14 07:47:19 linux-7vph kernel: ata1: irq_stat 0x00400040, connection 
status changed
May 14 07:47:19 linux-7vph kernel: mac80211-phy0: failed to set key (0, 
00:1d:92:1d:1e:8e) to hardware (-22)
May 14 07:47:19 linux-7vph kernel: ata2: exception Emask 0x10 SAct 0x0 
SErr 0x0 action 0x9 t4
May 14 07:47:19 linux-7vph kernel: ata2: irq_stat 0x40000001
May 14 07:47:19 linux-7vph kernel: Restarting tasks ... done.
May 14 07:47:19 linux-7vph kernel: ata1.00: exception Emask 0x10 SAct 
0x3fffff SErr 0x50000 action 0xe frozen
May 14 07:47:19 linux-7vph kernel: ata1.00: irq_stat 0x00400008, PHY RDY 
changed
May 14 07:47:19 linux-7vph kernel: ata1: SError: { PHYRdyChg CommWake }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/08:00:17:70:14/00:00:0d:00:00/40 tag 0 ncq 4096 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/40:08:11:8e:b5/00:00:09:00:00/40 tag 1 ncq 32768 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/40:10:91:a4:b5/00:00:09:00:00/40 tag 2 ncq 32768 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/08:18:5f:08:c8/00:00:0c:00:00/40 tag 3 ncq 4096 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/08:20:6f:88:6f/01:00:0e:00:00/40 tag 4 ncq 135168 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/08:28:9f:98:6d/00:00:0e:00:00/40 tag 5 ncq 4096 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/40:30:11:91:b5/00:00:09:00:00/40 tag 6 ncq 32768 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/40:38:91:9d:b5/00:00:09:00:00/40 tag 7 ncq 32768 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/40:40:51:7f:b5/00:00:09:00:00/40 tag 8 ncq 32768 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/40:48:91:7d:b5/00:00:09:00:00/40 tag 9 ncq 32768 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/a8:50:5f:89:67/00:00:0e:00:00/40 tag 10 ncq 86016 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/08:58:0f:8a:67/00:00:0e:00:00/40 tag 11 ncq 4096 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/b0:60:5f:8e:2b/00:00:0b:00:00/40 tag 12 ncq 90112 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/18:68:17:8f:2b/00:00:0b:00:00/40 tag 13 ncq 12288 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:19 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:19 linux-7vph kernel: ata1.00: cmd 
60/08:70:0f:8f:2b/00:00:0b:00:00/40 tag 14 ncq 4096 in
May 14 07:47:19 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:20 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:20 linux-7vph kernel: ata1.00: cmd 
60/18:78:2f:8f:2b/00:00:0b:00:00/40 tag 15 ncq 12288 in
May 14 07:47:20 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:20 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:20 linux-7vph kernel: ata1.00: cmd 
60/08:80:07:8a:67/00:00:0e:00:00/40 tag 16 ncq 4096 in
May 14 07:47:20 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:20 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:20 linux-7vph kernel: ata1.00: cmd 
60/50:88:17:8a:67/00:00:0e:00:00/40 tag 17 ncq 40960 in
May 14 07:47:20 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:20 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:20 linux-7vph kernel: ata1.00: cmd 
60/58:90:6f:06:44/00:00:0c:00:00/40 tag 18 ncq 45056 in
May 14 07:47:20 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:20 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:20 linux-7vph kernel: ata1.00: cmd 
60/08:98:d7:06:44/00:00:0c:00:00/40 tag 19 ncq 4096 in
May 14 07:47:20 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:20 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:20 linux-7vph kernel: ata1.00: cmd 
60/18:a0:17:07:44/00:00:0c:00:00/40 tag 20 ncq 12288 in
May 14 07:47:20 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:20 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:20 linux-7vph kernel: ata1.00: cmd 
60/08:a8:ef:4a:39/00:00:0b:00:00/40 tag 21 ncq 4096 in
May 14 07:47:20 linux-7vph kernel:          res 
50/00:08:ef:4a:39/00:00:0b:00:00/40 Emask 0x10 (ATA bus error)
May 14 07:47:20 linux-7vph kernel: ata1.00: status: { DRDY }
May 14 07:47:20 linux-7vph kernel: Descriptor sense data with sense 
descriptors (in hex):
May 14 07:47:20 linux-7vph kernel: end_request: I/O error, dev sda, 
sector 242190447
May 14 07:47:20 linux-7vph kernel: Descriptor sense data with sense 
descriptors (in hex):
May 14 07:47:20 linux-7vph kernel: end_request: I/O error, dev sda, 
sector 241666399
May 14 07:47:20 linux-7vph kernel: Descriptor sense data with sense 
descriptors (in hex):
May 14 07:47:20 linux-7vph kernel: end_request: I/O error, dev sda, 
sector 241666575
May 14 07:47:20 linux-7vph kernel: Descriptor sense data with sense 
descriptors (in hex):
May 14 07:47:20 linux-7vph kernel: end_request: I/O error, dev sda, 
sector 187403871
May 14 07:47:20 linux-7vph kernel: Descriptor sense data with sense 
descriptors (in hex):
May 14 07:47:20 linux-7vph kernel: end_request: I/O error, dev sda, 
sector 187404055
May 14 07:47:20 linux-7vph kernel: Descriptor sense data with sense 
descriptors (in hex):
May 14 07:47:20 linux-7vph kernel: end_request: I/O error, dev sda, 
sector 187404079
May 14 07:47:20 linux-7vph kernel: Descriptor sense data with sense 
descriptors (in hex):
May 14 07:47:20 linux-7vph kernel: end_request: I/O error, dev sda, 
sector 241666583
May 14 07:47:20 linux-7vph kernel: EXT4-fs error (device sda6): 
__ext4_get_inode_loc: unable to read inode block - inode=2346519, 
block=9404418
May 14 07:47:20 linux-7vph kernel: EXT4-fs error (device sda6) in 
ext4_reserve_inode_write: IO failure

