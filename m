Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbZCFRer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbZCFRer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 12:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZCFReg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 12:34:36 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:59678 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZCFRef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:34:35 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: LS-120 eject does not work with libata
Date: Fri, 6 Mar 2009 18:34:22 +0100
User-Agent: KMail/1.9.10
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903061834.24907.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I remember fixing LS-120 eject in ide-floppy 3 years ago.
Found this time thatit does not work with libata (2.6.28):

# eject -v /dev/sda
eject: device name is `/dev/sda'
eject: expanded name is `/dev/sda'
eject: `/dev/sda' is not mounted
eject: `/dev/sda' is not a mount point
eject: `/dev/sda' is a multipartition device
eject: trying to eject `/dev/sda' using CD-ROM eject command
eject: CD-ROM eject command failed
eject: trying to eject `/dev/sda' using SCSI commands
eject: SCSI eject succeeded

# strace eject -v /dev/sda
[...]
write(1, "eject: trying to eject `/dev/sda"..., 54eject: trying to eject `/dev/sda' using SCSI commands
) = 54
ioctl(3, SG_GET_VERSION_NUM, 0xbfbaeac4) = 0
ioctl(3, SG_IO, 0xbfbaea50)             = 0
ioctl(3, SG_IO, 0xbfbaea50)             = 0
ioctl(3, SG_IO, 0xbfbaea50)             = 0
ioctl(3, BLKRRPART, 0xbfbaea50)         = 0
write(1, "eject: SCSI eject succeeded\n", 28eject: SCSI eject succeeded
) = 28
[...]

It looks like everything is OK. The only problem is that the disk
does not eject (only spins up).


It does work when using SCSI generic device:
# eject -v /dev/sg0
eject: device name is `/dev/sg0'
eject: expanded name is `/dev/sg0'
eject: `/dev/sg0' is not mounted
eject: `/dev/sg0' is not a mount point
eject: `/dev/sg0' is not a multipartition device
eject: trying to eject `/dev/sg0' using CD-ROM eject command
eject: CD-ROM eject command failed
eject: trying to eject `/dev/sg0' using SCSI commands
eject: SCSI eject succeeded

The disk spins up and does some reads (most probably useless) and then ejects.

Now I wonder where the problem is...

-- 
Ondrej Zary
