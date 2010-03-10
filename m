Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab0CJEQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 23:16:20 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:53095 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755205Ab0CJEQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 23:16:18 -0500
Date: Wed, 10 Mar 2010 15:16:15 +1100
From: CaT <cat@zip.com.au>
To: linux-kernel@vger.kernel.org
Subject: Regression? 2.6.23.16 -> 2.6.32.9: ide/libata HD recognition
Message-ID: <20100310041614.GG2657@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organisation: Furball Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just had a strange situation with the above upgrade. It was done on an
old server that used the serverworks ide driver. The IDE hw config under
2.6.23.16 was:

hda:	HD
hdb:	CDROM
hdc:	empty
hdd:	HD

After upgrade, using either IDE or libata the config changed to:

hda:	HD
hdb:	CDROM
hdc:	empty
hdd:	empty

The BIOS recognised the disk. I went through 3 disks and it wasn't until
I made the second HD a master that it was recognised. So now I have a
2.6.32.9 server, using the IDE subsystem with the following config:

hda:	HD
hdb:	CDROM
hdc:	HD
hdd:	empty

Otherwise it does not work.

I had an outage window that I already blew so I was not able to do
any more diagnosis than what it took to get the system up.

If anyone wants the full config I'll send. Otherwise:

IDE subsystem (no libata subsystem configured):

CONFIG_HAVE_IDE=y
CONFIG_IDE=y
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_PROC_FS=y
CONFIG_BLK_DEV_IDEDMA_SFF=y
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_LEDS_TRIGGER_IDE_DISK=y

libata kernel (no IDE subsystem configured):

CONFIG_ATA=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_ATA_SFF=y
CONFIG_PATA_SERVERWORKS=y

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
