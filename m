Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbZJAAU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbZJAAU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 20:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbZJAAU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 20:20:56 -0400
Received: from mail.perches.com ([173.55.12.10]:1540 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121AbZJAAUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 20:20:55 -0400
Subject: Re: [PATCH 0/9] Add vsprintf extension %pU to print UUID/GUIDs and
 use it
From: Joe Perches <joe@perches.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Huang Ying <ying.huang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Adrian Hunter <adrian.hunter@nokia.com>, Alex Elder <aelder@sgi.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@lst.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jgarzik@redhat.com>,
       Matt Mackall <mpm@selenic.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Neil Brown <neilb@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>,
       Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>
In-Reply-To: <200910010207.45514.laurent.pinchart@ideasonboard.com>
References: <cover.1254193019.git.joe@perches.com>
	 <1254203852.15717.1506.camel@yhuang-dev.sh.intel.com>
	 <200910010207.45514.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Sep 2009 17:20:57 -0700
Message-Id: <1254356457.2960.129.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 02:07 +0200, Laurent Pinchart wrote:
> On Tuesday 29 September 2009 07:57:32 Huang Ying wrote:
> > It seems that the binary representation of UUID can be little-endian
> > (used by most kernel components) or big-endian (defined by RFC4122, used
> > in network?). Maybe we should consider about that.
> I think that's what the 'r' option is supposed to handle. Maybe you could use 
> 'b' and 'l' options instead, to specify the endianness explicitly.

or %pUbe and $pUle.
I've no objections, whatever's clearer to most people.

> > In fact, I find there are many different UUID/GUID definitions in
> > kernel, such as that in efi, many file systems, some drivers, etc. It
> > seems that every kernel components need UUID/GUID has its own
> > definition, so I think we should unify all the UUID/GUID definitions in
> > kernel too. The file attached is a draft unified UUID/GUID definition,
> > with byte-order issue in mind.
> > 
> > Any comment?
> 
> Not much, it would help if you could show where those functions would be used.
> 
> I would also use the 'le' and 'be' prefixes (as in le16, be32) instead of 'l' 
> and 'b', making it leuuid and beuuid, or maybe uuid_le and uuid_be.

A reply might take awhile.
I believe Ying is on vacation for a week or so.

Here is the list that Ying sent me:

﻿GUID in Linux kernel

arch/ia64/*.c:                efi_guid_t
arch/x86/kernel/efi.c:      efi_guid_t
fs/partitions/efi.[ch]:       efi_guid_t
drivers/firmware/efivars.c: efi_guid_t
fs/partitions/ldm.[ch]:      u8 [16],                    ldm_parse_guid,
memcmp, memcpy
fs/ntfs/layout.h:             GUID
fs/cifs/cifs*.[ch]:            u8 [16],                    memcpy
drivers/platform/x86/*wmi.c:    u8[16],              wmi_parse_guid
drivers/media/video/uvc/uvc*.[ch]: u8[16],        constants, format
(bin-»ascii),struct initialize(!!)
drivers/net/usb/zaurus.c:    u8[16]
drivers/staging/hv/*.c:      hv_guid                    initializing,
drivers/char/ipmi/ipmi_msghandler.c: u8[16]        show (sysfs)

Not standard uuid

fs/squashfs/*.[ch]:         __le16
include/linux/firewire.h:    unsigned long long
drivers/firewire/*.[ch]:
drivers/ieee1394/*.[ch]:
drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h:    u8[24]
drivers/infiniband/*.[ch]:    __be64

UUID in Linux kernel

arch/arm/*/sharpsl_param.[ch]:    u8[16]
arch/ia64/*/perfmon.[ch]:    pfm_uuid_t=u8[16]    cmp, format
arch/ia64/sn/kernel/io_acpi_init.c: acpi_vendor_uuid    initializing
arch/x86/kernel/tboot.c:    u8[16]
initializing,cmp
include/linux/tboot.h:
include/acpi/actbl1.h:        u8[16]
include/acpi/acpi/acrestyp.h acpi_uuid=struct {u8[16]},
acpi_vendor_uuid,u8[16]
drivers/acpi/acpica/*.[ch]
drivers/acpi/pci_root.c
drivers/pnp/pnpacpi/*.[ch]
include/linux/ext2_fs.h:    u8[16]
include/linux/ext3_fs.h:
fs/ext3/*.[ch]
drivers/ext4/ext4.h:
drivers/ext4/super.c:
include/linux/nfsd/nfsfh.h:    u8[16]
fs/nfsd/*.c
include/linux/wlp.h:            wlp_uuid=struct{u8[16]}
drivers/uwb/wlp/*.[ch]
include/linux/jbd2.h:            u8[16]
include/linux/jbd.h:
include/linux/gfs2_ondisk.h:   u8[16]
fs/gfs2/*.[ch]
include/linux/nilfs2_fs.h:       u8[16]
fs/jfs/*.[ch]:                      u8[16]                    access
component
fs/ubifs/*.[ch]:                   u8[16]                    generate!!!
fs/xfs/support/uuid.[ch]:       uuid_t=struct{u8[16]}
fs/xfs/*.[ch]
fs/ocfs2/*.[ch]:                   u8[16]
drivers/char/random.c:          u8[16]
generate_random_uuid
include/linux/reiserfs_fs.h:      u8[16]
fs/reiserfs/objectid.c:
fs/btrfs/*.[ch]:                    u8[16]
fs/afs/*.[ch]:                      afs_uuid=struct{u32,u16,xxx}
unmarshall(!!!), generate (DEC ver1 mode)
drivers/md/md.[ch]:              u8[16]
generate(get_random_bytes)
drivers/md/drivers.[ch]:

Not standard UUID

include/linux/dm-ioctl.h:    u8[129]
include/linux/dm-log-userspace.h:
drivers/md/dm-*.[ch]:

