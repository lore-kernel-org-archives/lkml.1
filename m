Return-Path: <linux-kernel-owner+w=401wt.eu-S1763723AbXGUBg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763723AbXGUBg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbXGUBgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:36:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbXGUBgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:36:42 -0400
Date: Fri, 20 Jul 2007 21:36:40 -0400
From: Dave Jones <davej@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: film at 11: kernel update breaks udev.
Message-ID: <20070721013640.GA8423@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070721010424.GA4411@redhat.com> <3ae72650707201809l33019f56i202c1a1ddd61007f@mail.gmail.com> <20070721011630.GA7017@redhat.com> <3ae72650707201828s22593ef7o7e66ebc2026d36ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ae72650707201828s22593ef7o7e66ebc2026d36ca@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 03:28:12AM +0200, Kay Sievers wrote:
 > On 7/21/07, Dave Jones <davej@redhat.com> wrote:
 > > On Sat, Jul 21, 2007 at 03:09:55AM +0200, Kay Sievers wrote:
 > >  > On 7/21/07, Dave Jones <davej@redhat.com> wrote:
 > >  > > Just one of my machines to 2.6.22.1, and got this during boot..
 > >  > >
 > >  > > Starting udev: udevd-event[619]: udev_node_symlink: symlink(../../sdc/dev/disk/by-uuid/2d773baf-8174-10a6-14db-a78e0e676e89) failed: File exists
 > >  > >
 > >  > > Under 2.6.21, all was fine.
 > >  > >
 > >  > > sdc is one disk of a 3 disk raid5 set.
 > >  > > The raidset still manages to come up despite this.
 > >  > >
 > >  > > This is a Fedora 7 box, with udev-106-4.1.fc7
 > >  > >
 > >  > > What changed this time?
 > >  >
 > >  > CONFIG_BLK_DEV_BSG=y?
 > >  >
 > >  > There's a name-clash, because bsg tries to create devices with the same name.
 > >  > James sent a patch, it's on lkml.
 > >
 > > BSG isn't in 2.6.22
 > 
 > Ok. There has nothing else changed, that I could think of what could cause this.
 > 
 > The code in udev that prints this message looks like:
 >    err("symlink(%s, %s) failed: %s", linktarget, filename, strerror(errno));
 > 
 > That doesn't really match what you posted. Are there chars missing?

Umm. Now I'm confused. Note above that it's talking about sdc.
/dev/disk/by-uuid/ contains ..

lrwxrwxrwx 1 root root  9 2007-07-17 20:35 2d773baf-8174-10a6-14db-a78e0e676e89 -> ../../sdd
lrwxrwxrwx 1 root root 10 2007-07-20 18:44 3B69-1AFD -> ../../sdl1
lrwxrwxrwx 1 root root 10 2007-07-20 19:06 46A1-3FCB -> ../../sdi1
lrwxrwxrwx 1 root root 10 2007-07-17 20:35 4e728818-fcf1-21ee-07a5-302b72bc6129 -> ../../sdc1
lrwxrwxrwx 1 root root 10 2007-07-17 20:35 5f435361-5797-4a8c-a285-c72fa455d401 -> ../../sda1
lrwxrwxrwx 1 root root  9 2007-07-17 20:35 9502a546-dd98-41df-8916-45032d801b69 -> ../../md0
lrwxrwxrwx 1 root root 10 2007-07-17 20:35 ed102ac9-5615-c34b-5fe7-1a9029705ebf -> ../../sda2

note that uuid matches sdd instead.

 > And what does:
 >   udevtest /block/sdc
 > print?

parse_file: reading '/etc/udev/rules.d/05-udev-early.rules' as rules file
parse_file: reading '/etc/udev/rules.d/40-multipath.rules' as rules file
parse_file: reading '/etc/udev/rules.d/50-udev.rules' as rules file
parse_file: reading '/etc/udev/rules.d/60-libsane.rules' as rules file
parse_file: reading '/etc/udev/rules.d/60-net.rules' as rules file
parse_file: reading '/etc/udev/rules.d/60-pcmcia.rules' as rules file
parse_file: reading '/etc/udev/rules.d/60-wacom.rules' as rules file
parse_file: reading '/etc/udev/rules.d/85-pcscd_ccid.rules' as rules file
parse_file: reading '/etc/udev/rules.d/85-pcscd_egate.rules' as rules file
parse_file: reading '/etc/udev/rules.d/90-alsa.rules' as rules file
parse_file: reading '/etc/udev/rules.d/90-hal.rules' as rules file
parse_file: reading '/etc/udev/rules.d/95-pam-console.rules' as rules file
parse_file: reading '/etc/udev/rules.d/bluetooth.rules' as rules file
This program is for debugging only, it does not create any node,
or run any program specified by a RUN key. It may show incorrect results,
if rules match against subsystem specfic kernel event variables.

main: looking at device '/block/sdc' from subsystem 'block'
run_program: '/bin/bash -c '/sbin/lsmod | /bin/grep ^dm_multipath''
run_program: '/bin/bash' (stdout) 'dm_multipath           28889  0 '
run_program: '/bin/bash' returned with status 0
run_program: '/lib/udev/usb_id -x'
run_program: '/lib/udev/usb_id' returned with status 1
run_program: '/lib/udev/scsi_id -g -x -s /block/sdc -d /dev/.tmp-8-32'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_VENDOR=ATA'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_MODEL=WDC_WD2500KS-00M'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_REVISION=02.0'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_SERIAL=SATA_WDC_WD2500KS-00_WD-WCANK6187088'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_SERIAL_SHORT=WD-WCANK6187088'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_TYPE=disk'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_BUS=scsi'
run_program: '/lib/udev/scsi_id' returned with status 0
udev_rules_get_name: add symlink 'disk/by-id/scsi-SATA_WDC_WD2500KS-00_WD-WCANK6187088'
run_program: '/lib/udev/path_id /block/sdc'
run_program: '/lib/udev/path_id' (stdout) 'ID_PATH=pci-0000:05:05.0-scsi-0:0:0:0'
run_program: '/lib/udev/path_id' returned with status 0
udev_rules_get_name: add symlink 'disk/by-path/pci-0000:05:05.0-scsi-0:0:0:0'
run_program: '/lib/udev/vol_id --export /dev/.tmp-8-32'
run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_USAGE=raid'
run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_TYPE=linux_raid_member'
run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_VERSION=0.90.0'
run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_UUID=2d773baf-8174-10a6-14db-a78e0e676e89'
run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_LABEL='
run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_LABEL_SAFE='
run_program: '/lib/udev/vol_id' returned with status 0
udev_rules_get_name: add symlink 'disk/by-uuid/2d773baf-8174-10a6-14db-a78e0e676e89'
run_program: '/lib/udev/edd_id --export /dev/.tmp-8-32'
run_program: '/lib/udev/edd_id' (stderr) 'no kernel EDD support'
run_program: '/lib/udev/edd_id' returned with status 2
udev_rules_get_name: no node name set, will use kernel name 'sdc'
udev_device_event: device '/block/sdc' already in database, validate currently present symlinks
udev_node_add: creating device node '/dev/sdc', major = '8', minor = '32', mode = '0640', uid = '0', gid = '6'
udev_node_add: creating symlink '/dev/disk/by-id/scsi-SATA_WDC_WD2500KS-00_WD-WCANK6187088' to '../../sdc'
udev_node_add: creating symlink '/dev/disk/by-path/pci-0000:05:05.0-scsi-0:0:0:0' to '../../sdc'
udev_node_add: creating symlink '/dev/disk/by-uuid/2d773baf-8174-10a6-14db-a78e0e676e89' to '../../sdc'
main: run: '/sbin/multipath -v0 8:32'
main: run: 'socket:/org/kernel/udev/monitor'
main: run: 'socket:/org/freedesktop/hal/udev_event'
main: run: '/sbin/pam_console_apply /dev/sdc /dev/disk/by-id/scsi-SATA_WDC_WD2500KS-00_WD-WCANK6187088 /dev/disk/by-path/pci-0000:05:05.0-scsi-0:0:0:0 /dev/disk/by-uuid/2d773baf-8174-10a6-14db-a78e0e676e89'



running udevtest on sdd gets me ..

parse_file: reading '/etc/udev/rules.d/05-udev-early.rules' as rules file
parse_file: reading '/etc/udev/rules.d/40-multipath.rules' as rules file
parse_file: reading '/etc/udev/rules.d/50-udev.rules' as rules file
parse_file: reading '/etc/udev/rules.d/60-libsane.rules' as rules file
parse_file: reading '/etc/udev/rules.d/60-net.rules' as rules file
parse_file: reading '/etc/udev/rules.d/60-pcmcia.rules' as rules file
parse_file: reading '/etc/udev/rules.d/60-wacom.rules' as rules file
parse_file: reading '/etc/udev/rules.d/85-pcscd_ccid.rules' as rules file
parse_file: reading '/etc/udev/rules.d/85-pcscd_egate.rules' as rules file
parse_file: reading '/etc/udev/rules.d/90-alsa.rules' as rules file
parse_file: reading '/etc/udev/rules.d/90-hal.rules' as rules file
parse_file: reading '/etc/udev/rules.d/95-pam-console.rules' as rules file
parse_file: reading '/etc/udev/rules.d/bluetooth.rules' as rules file
This program is for debugging only, it does not create any node,
or run any program specified by a RUN key. It may show incorrect results,
if rules match against subsystem specfic kernel event variables.

main: looking at device '/block/sdd' from subsystem 'block'
run_program: '/bin/bash -c '/sbin/lsmod | /bin/grep ^dm_multipath''
run_program: '/bin/bash' (stdout) 'dm_multipath           28889  0 '
run_program: '/bin/bash' returned with status 0
run_program: '/lib/udev/usb_id -x'
run_program: '/lib/udev/usb_id' returned with status 1
run_program: '/lib/udev/scsi_id -g -x -s /block/sdd -d /dev/.tmp-8-48'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_VENDOR=ATA'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_MODEL=WDC_WD2500KS-00M'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_REVISION=02.0'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_SERIAL=SATA_WDC_WD2500KS-00_WD-WCANK6240588'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_SERIAL_SHORT=WD-WCANK6240588'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_TYPE=disk'
run_program: '/lib/udev/scsi_id' (stdout) 'ID_BUS=scsi'
run_program: '/lib/udev/scsi_id' returned with status 0
udev_rules_get_name: add symlink 'disk/by-id/scsi-SATA_WDC_WD2500KS-00_WD-WCANK6240588'
run_program: '/lib/udev/path_id /block/sdd'
run_program: '/lib/udev/path_id' (stdout) 'ID_PATH=pci-0000:05:05.0-scsi-1:0:0:0'
run_program: '/lib/udev/path_id' returned with status 0
udev_rules_get_name: add symlink 'disk/by-path/pci-0000:05:05.0-scsi-1:0:0:0'
run_program: '/lib/udev/vol_id --export /dev/.tmp-8-48'
run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_USAGE=raid'
run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_TYPE=linux_raid_member'
run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_VERSION=0.90.0'
run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_UUID=2d773baf-8174-10a6-14db-a78e0e676e89'
run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_LABEL='
run_program: '/lib/udev/vol_id' (stdout) 'ID_FS_LABEL_SAFE='
run_program: '/lib/udev/vol_id' returned with status 0
udev_rules_get_name: add symlink 'disk/by-uuid/2d773baf-8174-10a6-14db-a78e0e676e89'
run_program: '/lib/udev/edd_id --export /dev/.tmp-8-48'
run_program: '/lib/udev/edd_id' (stderr) 'no kernel EDD support'
run_program: '/lib/udev/edd_id' returned with status 2
udev_rules_get_name: no node name set, will use kernel name 'sdd'
udev_device_event: device '/block/sdd' already in database, validate currently present symlinks
udev_node_add: creating device node '/dev/sdd', major = '8', minor = '48', mode = '0640', uid = '0', gid = '6'
udev_node_add: creating symlink '/dev/disk/by-id/scsi-SATA_WDC_WD2500KS-00_WD-WCANK6240588' to '../../sdd'
udev_node_add: creating symlink '/dev/disk/by-path/pci-0000:05:05.0-scsi-1:0:0:0' to '../../sdd'
udev_node_add: creating symlink '/dev/disk/by-uuid/2d773baf-8174-10a6-14db-a78e0e676e89' to '../../sdd'
main: run: '/sbin/multipath -v0 8:48'
main: run: 'socket:/org/kernel/udev/monitor'
main: run: 'socket:/org/freedesktop/hal/udev_event'
main: run: '/sbin/pam_console_apply /dev/sdd /dev/disk/by-id/scsi-SATA_WDC_WD2500KS-00_WD-WCANK6240588 /dev/disk/by-path/pci-0000:05:05.0-scsi-1:0:0:0 /dev/disk/by-uuid/2d773baf-8174-10a6-14db-a78e0e676e89'


note, same uuid. wtf?

	Dave

-- 
http://www.codemonkey.org.uk
