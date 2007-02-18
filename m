Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbXBRX2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbXBRX2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 18:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbXBRX2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 18:28:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbXBRX2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 18:28:14 -0500
Message-ID: <45D8E102.6090004@redhat.com>
Date: Sun, 18 Feb 2007 18:28:02 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@suse.de>, Jeff Garzik <jeff@garzik.org>
Subject: I2O block driver broken in kernel 2.6.19?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fedora is getting a bunch of bug reports about the I2O block
driver not working in 2.6.19 kernels.

Everything looks like it loads OK, but no block IO can be
done, not even reading the partition table:

I2O subsystem v1.325
i2o: max drivers = 8
i2o: Checking for PCI I2O controllers...
ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [APC4] -> GSI 19 (level, low) -> IRQ 19
iop0: controller found (0000:01:07.0)
iop0: limit sectors per request to 128
iop0: using 64-bit DMA
iop0: PCI I2O controller at E0000000 size=1048576
iop0: Installed at IRQ 19
i2o: iop0: Activating I2O controller...
i2o: iop0: This may take a few minutes if there are many devices
iop0: HRT has 1 entries of 16 bytes each.
Adapter 00000012: TID 0000:[HPC*]:PCI 1: Bus 1 Device 22 Function 0
i2o: iop0: Controller added
I2O Block Device OSM v1.325
block-osm: registered device at major 80
 i2o/hda:<3>Buffer I/O error on device i2o/hda, logical block 0
Buffer I/O error on device i2o/hda, logical block 0
Buffer I/O error on device i2o/hda, logical block 0
 unable to read partition table
block-osm: device added (TID: 209): i2o/hda

The driver looks unchanged except for cleanups...


