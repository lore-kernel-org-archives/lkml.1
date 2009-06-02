Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbZFBOP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbZFBOP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZFBOO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:14:56 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:61264 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbZFBOOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:14:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=G4yjcCPC68It+Vby9aLFQBdX0RdIMvufSZFvGIfZxbuR2CIdVLCH7bKmlv2nRYhfuJ
         sMlQTDGcl3t/LHHT4prGVQVXe0iHjBMygpqQG2VcsEzl32wJR6B6wNKgkgRgeHu440W9
         Myq9EB0jjUOIO3jqhr0xGoT8U2hkSYUriqb38=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] drivers/ide/ide-core: Convert printk(KERN_<level> to dev_<level>
Date: Tue, 2 Jun 2009 15:57:14 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1243062772.git.joe@perches.com> <1c1c4761bd0705f8c7e50c969379a59c5849d430.1243062772.git.joe@perches.com>
In-Reply-To: <1c1c4761bd0705f8c7e50c969379a59c5849d430.1243062772.git.joe@perches.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906021557.14288.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 May 2009 09:41:13 Joe Perches wrote:
> When hwif->name or drive->name is printed.
> 
> There is a single #ifdef DEBUG printk(KERN_DEBUG
> that is also converted to dev_dbg.

This change is not what we would like to have there, please drop it.

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/ide/ide-atapi.c     |   74 ++++++++++++++++++++++---------------------
>  drivers/ide/ide-dma-sff.c   |    6 ++--
>  drivers/ide/ide-dma.c       |   28 ++++++++--------
>  drivers/ide/ide-eh.c        |   18 +++++-----
>  drivers/ide/ide-io.c        |   18 +++-------
>  drivers/ide/ide-ioctls.c    |    4 +-
>  drivers/ide/ide-iops.c      |    9 ++---
>  drivers/ide/ide-lib.c       |    4 +-
>  drivers/ide/ide-pm.c        |    8 ++--
>  drivers/ide/ide-probe.c     |   69 ++++++++++++++++++++-------------------
>  drivers/ide/ide-taskfile.c  |   22 ++++++-------
>  drivers/ide/ide-xfer-mode.c |    6 ++--
>  drivers/ide/ide.c           |   20 +++++-------
>  drivers/ide/setup-pci.c     |    7 ++--
>  14 files changed, 142 insertions(+), 151 deletions(-)
> 
> diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
> index ffa1bb8..fc5cfb6 100644
> --- a/drivers/ide/ide-atapi.c
> +++ b/drivers/ide/ide-atapi.c
> @@ -50,21 +50,21 @@ int ide_check_atapi_device(ide_drive_t *drive, const char *s)
>  #endif
>  
>  	if (protocol != 2)
> -		printk(KERN_ERR "%s: %s: protocol (0x%02x) is not ATAPI\n",
> -			s, drive->name, protocol);
> +		dev_err(&drive->gendev, "%s: protocol (0x%02x) is not ATAPI\n",
> +			s, protocol);
>  	else if ((drive->media == ide_floppy && device_type != 0) ||
>  		 (drive->media == ide_tape && device_type != 1))
> -		printk(KERN_ERR "%s: %s: invalid device type (0x%02x)\n",
> -			s, drive->name, device_type);
> +		dev_err(&drive->gendev, "%s: invalid device type (0x%02x)\n",
> +			s, device_type);
>  	else if (removable == 0)
> -		printk(KERN_ERR "%s: %s: the removable flag is not set\n",
> -			s, drive->name);
> +		dev_err(&drive->gendev, "%s: the removable flag is not set\n",
> +			s);
>  	else if (drive->media == ide_floppy && drq_type == 3)
> -		printk(KERN_ERR "%s: %s: sorry, DRQ type (0x%02x) not "
> -			"supported\n", s, drive->name, drq_type);
> +		dev_err(&drive->gendev, "%s: sorry, DRQ type (0x%02x) not "
> +			"supported\n", s, drq_type);
>  	else if (packet_size != 0)
> -		printk(KERN_ERR "%s: %s: packet size (0x%02x) is not 12 "
> -			"bytes\n", s, drive->name, packet_size);
> +		dev_err(&drive->gendev, "%s: packet size (0x%02x) is not 12 "
> +			"bytes\n", s, packet_size);

Currently we pass driver name to this function using 's' parameter,
the conversion needs to take this into account (because dev_*() helpers
also print driver name).  IOW 's' should be dropped now.

> diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
> index 4002487..5672c27 100644
> --- a/drivers/ide/ide-probe.c
> +++ b/drivers/ide/ide-probe.c

[...]

> @@ -376,9 +375,10 @@ static int do_probe (ide_drive_t *drive, u8 cmd)
>  		return 4;
>  
>  #ifdef DEBUG
> -	printk(KERN_INFO "probing for %s: present=%d, media=%d, probetype=%s\n",
> -		drive->name, present, drive->media,
> -		(cmd == ATA_CMD_ID_ATA) ? "ATA" : "ATAPI");
> +	dev_info(&drive->gendev,
> +		 "probing for %s: present=%d, media=%d, probetype=%s\n",
> +		 drive->name, present, drive->media,
> +		 (cmd == ATA_CMD_ID_ATA) ? "ATA" : "ATAPI");

drive->name should be dropped now

> --- a/drivers/ide/ide.c
> +++ b/drivers/ide/ide.c
> @@ -273,25 +273,23 @@ static void ide_dev_apply_params(ide_drive_t *drive, u8 unit)
>  	int i = drive->hwif->index * MAX_DRIVES + unit;
>  
>  	if (ide_nodma & (1 << i)) {
> -		printk(KERN_INFO "ide: disallowing DMA for %s\n", drive->name);
> +		dev_info(&drive->gendev, "ide: disallowing DMA\n");
>  		drive->dev_flags |= IDE_DFLAG_NODMA;
>  	}
>  	if (ide_noflush & (1 << i)) {
> -		printk(KERN_INFO "ide: disabling flush requests for %s\n",
> -				 drive->name);
> +		dev_info(&drive->gendev, "ide: disabling flush requests\n");
>  		drive->dev_flags |= IDE_DFLAG_NOFLUSH;
>  	}
>  	if (ide_noprobe & (1 << i)) {
> -		printk(KERN_INFO "ide: skipping probe for %s\n", drive->name);
> +		dev_info(&drive->gendev, "ide: skipping probe\n");
>  		drive->dev_flags |= IDE_DFLAG_NOPROBE;
>  	}
>  	if (ide_nowerr & (1 << i)) {
> -		printk(KERN_INFO "ide: ignoring the ATA_DF bit for %s\n",
> -				 drive->name);
> +		dev_info(&drive->gendev, "ide: ignoring the ATA_DF bit\n");
>  		drive->bad_wstat = BAD_R_STAT;
>  	}
>  	if (ide_cdroms & (1 << i)) {
> -		printk(KERN_INFO "ide: forcing %s as a CD-ROM\n", drive->name);
> +		dev_info(&drive->gendev, "ide: forcing as a CD-ROM\n");
>  		drive->dev_flags |= IDE_DFLAG_PRESENT;
>  		drive->media = ide_cdrom;
>  		/* an ATAPI device ignores DRDY */
> @@ -302,9 +300,8 @@ static void ide_dev_apply_params(ide_drive_t *drive, u8 unit)
>  		drive->head = drive->bios_head = ide_disks_chs[i].head;
>  		drive->sect = drive->bios_sect = ide_disks_chs[i].sect;
>  
> -		printk(KERN_INFO "ide: forcing %s as a disk (%d/%d/%d)\n",
> -				 drive->name,
> -				 drive->cyl, drive->head, drive->sect);
> +		dev_info(&drive->gendev, "ide: forcing as a disk (%d/%d/%d)\n",
> +			 drive->cyl, drive->head, drive->sect);
>  
>  		drive->dev_flags |= IDE_DFLAG_FORCED_GEOM | IDE_DFLAG_PRESENT;
>  		drive->media = ide_disk;
> @@ -343,8 +340,7 @@ void ide_port_apply_params(ide_hwif_t *hwif)
>  	int i;
>  
>  	if (ide_ignore_cable & (1 << hwif->index)) {
> -		printk(KERN_INFO "ide: ignoring cable detection for %s\n",
> -				 hwif->name);
> +		dev_info(&hwif->gendev, "ide: ignoring cable detection\n");
>  		hwif->cbl = ATA_CBL_PATA40_SHORT;
>  	}

Probably "ide: " should be dropped now in all the above dev_*() instances.

also:

Please test your patches -- I get following output with this patch:

Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x24ca rev 0x03)
pci 0000:00:1f.1: enabling device (0005 -> 0007)
pci 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
 <NULL>:     BM-DMA at 0x1100-0x1107
 <NULL>:     BM-DMA at 0x1108-0x110f
Probing IDE interface ide0...
 <NULL>: IC25N060ATMR04-0, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
 <NULL>: UDMA/100 mode selected
Probing IDE interface ide1...
 <NULL>: TOSHIBA ODD-DVD SD-R6372, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
 <NULL>: UDMA/33 mode selected
 ide0: at 0x1f0-0x1f7,0x3f6 on irq 14
 ide1: at 0x170-0x177,0x376 on irq 15

It turns out that some drive->name users should be converted to use
hwif->name instead (which means they would be using hwif->gendev
instead of drive->gendev after conversion) and also some hwif->name
users should become pci_dev->name users.

It looks that it is not as simple as a mindless s/printk()/dev_*()/g
conversion (sorry for being too optimistic about it previously).

[ OTOH this is the standard practice in kernel development process that
  if we discover underlying issues we address them first and quite often
  the end result is very different from the initial patches. ]

Another observation from the testing is:

ide-cd: hdc: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache

this message comes from ATAPI layer but since device drivers haven't been
converted yet they would be preceded by only "hdc: " so we need to apply
all dev_*() conversion patches in one go to keep the consistency of kernel
messages and not confuse users (BTW when are the other patches coming?).

Once again sorry if this sounds like more work than we initially though
but the IDE logging improvements are much needed and I think that once we
are content with the way of doing dev_*()/pr_*() conversion the similar
approach can be later used also in other kernel subsystems.

Thanks.
Bart
