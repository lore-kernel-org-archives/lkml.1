Return-Path: <linux-kernel-owner+w=401wt.eu-S1761373AbZDIFv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761373AbZDIFv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZDIFvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:51:46 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:44172 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbZDIFvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:51:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ukUf2lbb4o/NbYZemvf4eTsGScI5BnJLrePBLkmYUcnt5AJhb6i+ef+jtmR82qPzrx
         0qCfjf9+fvddbfw3v/4PPgeIla0pNQOpiMrYCdOIqMg98HqmFLXcn9JagxM14MxJYw3P
         /9c0L7Xrs5gAKSaTULo1R9OR1W6V6YRgiaLFU=
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 22:51:43 -0700
Message-ID: <a95a62fe0904082251n45504a51r1847cd25b9d88583@mail.gmail.com>
Subject: [PATCH 1/4] [MTD] Update sysfs documentation
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>, greg@kroah.com,
       dedekind <dedekind@infradead.org>, David Brownell <david-b@pacbell.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux MTD <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>

---
 Documentation/ABI/testing/sysfs-class-mtd |  125 +++++++++++++++++++++++++++++
 1 files changed, 125 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-mtd

diff --git a/Documentation/ABI/testing/sysfs-class-mtd
b/Documentation/ABI/testing/sysfs-class-mtd
new file mode 100644
index 0000000..2bb3157
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-mtd
@@ -0,0 +1,125 @@
+What:		/sys/class/mtd/
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		The mtd/ class subdirectory belongs to the MTD subsystem
+		(MTD core).
+
+What:		/sys/class/mtd/mtdX/
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		The /sys/class/mtd/mtd{0,1,2,3,...} directories correspond
+		to each /dev/mtdX character device.  These may represent
+		physical/simulated flash devices, partitions on a flash
+		device, or concatenated flash devices.  They exist regardless
+		of whether CONFIG_MTD_CHAR is actually enabled.
+
+What:		/sys/class/mtd/mtdXro/
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		These directories provide the corresponding read-only device
+		nodes for /sys/class/mtd/mtdX/ .  They are only created
+		(for the benefit of udev) if CONFIG_MTD_CHAR is enabled.
+
+What:		/sys/class/mtd/mtdX/dev
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		Major and minor numbers of the character device corresponding
+		to this MTD device (in <major>:<minor> format).  This is the
+		read-write device so <minor> will be even.
+
+What:		/sys/class/mtd/mtdXro/dev
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		Major and minor numbers of the character device corresponding
+		to the read-only variant of thie MTD device (in
+		<major>:<minor> format).  In this case <minor> will be odd.
+
+What:		/sys/class/mtd/mtdX/erasesize
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		"Major" erase size for the device.  If numeraseregions is
+		zero, this is the eraseblock size for the entire device.
+		Otherwise, the MEMGETREGIONCOUNT/MEMGETREGIONINFO ioctls
+		can be used to determine the actual eraseblock layout.
+
+What:		/sys/class/mtd/mtdX/flags
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		A hexadecimal value representing the device flags, ORed
+		together:
+
+		0x0400: MTD_WRITEABLE - device is writable
+		0x0800: MTD_BIT_WRITEABLE - single bits can be flipped
+		0x1000: MTD_NO_ERASE - no erase necessary
+		0x2000: MTD_POWERUP_LOCK - always locked after reset
+
+What:		/sys/class/mtd/mtdX/name
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		A human-readable ASCII name for the device or partition.
+		This will match the name in /proc/mtd .
+
+What:		/sys/class/mtd/mtdX/numeraseregions
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		For devices that have variable eraseblock sizes, this
+		provides the total number of erase regions.  Otherwise,
+		it will read back as zero.
+
+What:		/sys/class/mtd/mtdX/oobsize
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		Number of OOB bytes per page.
+
+What:		/sys/class/mtd/mtdX/size
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		Total size of the device/partition, in bytes.
+
+What:		/sys/class/mtd/mtdX/type
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		One of the following ASCII strings, representing the device
+		type:
+
+		absent, ram, rom, nor, nand, dataflash, ubi, unknown
+
+What:		/sys/class/mtd/mtdX/writesize
+Date:		April 2009
+KernelVersion:	2.6.29
+Contact:	linux-mtd@lists.infradead.org
+Description:
+		Minimal writable flash unit size.  This will always be
+		a positive integer.
+
+		In the case of NOR flash it is 1 (even though individual
+		bits can be cleared).
+
+		In the case of NAND flash it is one NAND page (or a
+		half page, or a quarter page).
+
+		In the case of ECC NOR, it is the ECC block size.
-- 
1.5.4.3
