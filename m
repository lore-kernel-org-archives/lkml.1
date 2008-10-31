Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbYJaVkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbYJaVkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 17:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYJaVjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 17:39:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:49482 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYJaVjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 17:39:48 -0400
From: Andreas Schwab <schwab@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix block dev compat ioctl handling
Cc: Al Viro <viro@zeniv.linux.org.uk>
X-Yow: Yow!  Are you the self-frying president?
Date: Fri, 31 Oct 2008 22:39:46 +0100
Message-ID: <jeskqch2al.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 33c2dca4957bd0da3e1af7b96d0758d97e708ef6 (trim file propagation
in block/compat_ioctl.c) removed the handling of some ioctls from
compat_blkdev_driver_ioctl.  That caused them to be rejected as unknown
by the compat layer.

Signed-off-by: Andreas Schwab <schwab@suse.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>

---
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 3d3e7a4..d43e608 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -677,6 +677,29 @@ static int compat_blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
 	case DVD_WRITE_STRUCT:
 	case DVD_AUTH:
 		arg = (unsigned long)compat_ptr(arg);
+	/* These intepret arg as an unsigned long, not as a pointer,
+	 * so we must not do compat_ptr() conversion. */
+	case HDIO_SET_MULTCOUNT:
+	case HDIO_SET_UNMASKINTR:
+	case HDIO_SET_KEEPSETTINGS:
+	case HDIO_SET_32BIT:
+	case HDIO_SET_NOWERR:
+	case HDIO_SET_DMA:
+	case HDIO_SET_PIO_MODE:
+	case HDIO_SET_NICE:
+	case HDIO_SET_WCACHE:
+	case HDIO_SET_ACOUSTIC:
+	case HDIO_SET_BUSSTATE:
+	case HDIO_SET_ADDRESS:
+	case CDROMEJECT_SW:
+	case CDROM_SET_OPTIONS:
+	case CDROM_CLEAR_OPTIONS:
+	case CDROM_SELECT_SPEED:
+	case CDROM_SELECT_DISC:
+	case CDROM_MEDIA_CHANGED:
+	case CDROM_DRIVE_STATUS:
+	case CDROM_LOCKDOOR:
+	case CDROM_DEBUG:
 		break;
 	default:
 		/* unknown ioctl number */

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
