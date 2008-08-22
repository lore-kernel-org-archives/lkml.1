Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbYHVHgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbYHVHgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYHVHgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:36:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:37667 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbYHVHgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:36:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=gyrcivWN9iE5g0EJeqCTzqunsRVv6J9xafO92NXAvJ1N1ING49aB3t6XRHRUzaTp48
         5I7dEJe4vd5qCByuC213VcAY/uTx551yon2qYMd/+ZCKF2FEk7twKBtL6W+pPXoochH7
         HHd1+8q/W5v/zKh0ox2PGf+1GJeS8K7ISVYe0=
Message-ID: <806dafc20808220036k3c1360e6l1b5fea9b659592b3@mail.gmail.com>
Date: Fri, 22 Aug 2008 03:36:01 -0400
From: xiphmont@xiph.org
To: axboe@suse.de, "Linux Kernel" <linux-kernel@vger.kernel.org>,
       pjones@redhat.com
Subject: [PATCH] SG_IO block filter whitelist missing MMC SET READ AHEAD command
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 4b4a1d886617ee0c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I have another request for the block filter SG_IO command whitelist,
specifically the MMC streaming command set SET READ AHEAD command.
The command applies only to MMC CDROM/DVDROM drives with the streaming
optional feature set.  The command is useful to cdparanoia in that it
allows explicit cache control side effects that are, on many drives,
cdparanoia's most efficient way to flush/disable the media cache on
cdrom drives. I am aware of no reason why it should not be accessible
from usespace.

Also note that the command is already fully accessible through the
SCSI-native version of the SG_IO ioctl as well as the traditional SG
interface.  The command is only being refused on block devices.  That
means that on a typical stock distro, the command is available through
/dev/sg* but not /dev/scd* although both are typically available and
accessible.  Filtering the command is not providing any protection,
only a confusing inconsistency.

For convenience's sake, trivial patch below.

diff -ru linux-2.6.26.3/block/scsi_ioctl.c
linux-2.6.26.3-monty/block/scsi_ioctl.c
--- linux-2.6.26.3/block/scsi_ioctl.c   2008-08-20 14:11:37.000000000 -0400
+++ linux-2.6.26.3-monty/block/scsi_ioctl.c     2008-08-22
04:17:56.194248000 -0400
@@ -188,6 +188,7 @@
                safe_for_write(GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL),
                safe_for_write(GPCMD_LOAD_UNLOAD),
                safe_for_write(GPCMD_SET_STREAMING),
+               safe_for_write(GPCMD_SET_READ_AHEAD),
        };
        unsigned char type = cmd_type[cmd[0]];


Thanks,
Monty
