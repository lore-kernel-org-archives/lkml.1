Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZKKCZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZKKCZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbZKKCZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:25:40 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:58688 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756128AbZKKCZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:25:39 -0500
Message-ID: <4AFA20A1.3060208@blueyonder.co.uk>
Date: Wed, 11 Nov 2009 02:25:37 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4 ThunderBrowse/3.2.6.5
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32-rc6 - 2.6.32-rc6-git3 misinterpreting fstype on boot
References: <4AF7431D.9080002@blueyonder.co.uk>
In-Reply-To: <4AF7431D.9080002@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now I have found the cause, the wonder is why it booted for the last
many months the new motherboard was installed with earlier kernels up to
2.6.32-rc5-git4.
Problem was my INITRD script gave / as -part1 instead of -part2, having
corrected it, 2.6-32-rc6-git4 boots.
I obviously had not been paying close attention to what mkinitrd was
telling me, mainly because it always worked - then .....
Regards
Sid.

On 08/11/09 22:15, Sid Boyce wrote:
> 2.6.32-rc5-git4 kernel boots normally, but 2.6.32-rc6 and later exhibit
> strangeness - misinterpreting the xfs partition as reiserfs.
> The .config is the same.
> Under 2.6.32-rc5-git4
> ======================
> # mount
> /dev/sda2 on / type xfs (rw) <<======
> proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw)
> debugfs on /sys/kernel/debug type debugfs (rw)
> udev on /dev type tmpfs (rw)
> devpts on /dev/pts type devpts (rw,mode=0620,gid=5)
> /dev/sda1 on /boot type reiserfs (rw,acl,user_xattr) <<====
> /dev/sdb1 on /home/lancelot/ftp type reiserfs (rw)
> none on /tmp type tmpfs (rw)
> fusectl on /sys/fs/fuse/connections type fusectl (rw)
> none on /proc/sys/fs/binfmt_misc type binfmt_misc (rw)
> nfsd on /proc/fs/nfsd type nfsd (rw)
> rpc_pipefs on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw)
> /proc on /var/lib/ntp/proc type none (ro,bind)
> gvfs-fuse-daemon on /home/lancelot/.gvfs type fuse.gvfs-fuse-daemon
> (rw,nosuid,nodev,user=lancelot)
> 
>  system.firmware.version = 'ASUS CROSSHAIR II FORMULA ACPI BIOS Revision
> 1802'
>   system.firmware.release_date = '05/06/2009'
>   system.hardware.vendor = 'System manufacturer'
>   system.hardware.product = 'System Product Name'
>   system.hardware.version = 'System Version'
>   system.chassis.manufacturer = 'Chassis Manufacture'
>   system.board.product = 'CROSSHAIR II FORMULA'
>   system.board.version = '1.XX'
>   system.board.vendor = 'ASUSTeK Computer INC.'
>   system.chassis.type = 'Desktop'
>   system.formfactor = 'desktop'
> CPU is AMD quad core.
> 
> 
> When I try to boot 2.6.32-rc6 and 2.6.32-rc6-git, it thinks /dev/sda2
> is a reiserfs partition it needs to mount as "/root"????.
> Boot up messages
> ==================
> fsck from util-linux-ng 2.16
> [/sbin/fsck.reiserfs (1) -- /] fsck.reiserfs -a /dev/sda2
> reiserfs_open: the reiserfs superblock cannot be found on /dev/sda2.
> REISERFS: warning (device sda2): sh-2021 reiserfs_fill_super: can not
> find reiserfs on sda2.
> Failed to open the filesystem
>   If the partition table has not been changed, the partition is valid
>   and really contains a reiserfs  partition, then the superblock is
>   corrupted and you need to run this utility with --rebuild-sb.
> fsck failed. Mounting root device read-only.
> Mounting root /dev/disk/by-id/scsi-SATA_SAMSUNG_HD103UJS13PJDWS258743-part2
> mount -o ro -t reiserfs
> /dev/disk/by-id/scsi-SATA_SAMSUNG_HD103UJS13PJDWS258743-part2 /root
> mount: wrong fstype, bad option, bad superblock on /dev/sda2
> could not mount root filesystem - exiting to /bin/sh
> 
> 
> No problem on this other box with AMD dual-core and 2.6.32-rc6-git3 running.
> system.firmware.vendor = 'Phoenix Technologies, LTD'
>   system.firmware.version = 'ASUS M2N32-SLI DELUXE ACPI BIOS Revision 1802'
>   system.firmware.release_date = '01/31/2008'
>   system.hardware.vendor = 'System manufacturer'
>   system.hardware.product = 'System Product Name'
>   system.hardware.version = 'System Version'
>   system.chassis.manufacturer = 'Chassis Manufacture'
>   system.board.product = 'M2N32-SLI DELUXE'
>   system.board.version = '1.XX'
>   system.board.vendor = 'ASUSTeK Computer INC.'
>   system.chassis.type = 'Desktop'
> /dev/sda1 on / type xfs (rw)
> /dev/sdb1 on /data1 type btrfs (rw)
> Regards
> Sid.


-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

