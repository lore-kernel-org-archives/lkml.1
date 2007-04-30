Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbXD3Kzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbXD3Kzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXD3Kzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:55:37 -0400
Received: from mail.suse.de ([195.135.220.2]:53882 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461AbXD3Kyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:54:49 -0400
From: Andreas Schwab <schwab@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix error handling in HDIO_GETGEO compat wrapper
X-Yow: C'MON, everybody!!  I've flown in LESLIE GORE and two dozen KOSHER
 BUTCHERS!  They'll be doing intricate MILITARY MANEUVERS to the
 soundtrack from "OKLAHOMA"!!
Date: Mon, 30 Apr 2007 12:54:48 +0200
Message-ID: <jefy6ixhc7.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't clobber error from sys_ioctl in HDIO_GETGEO compat wrapper.

Signed-off-by: Andreas Schwab <schwab@suse.de>

---
 fs/compat_ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.21.orig/fs/compat_ioctl.c	2007-04-26 13:40:52.000000000 +0200
+++ linux-2.6.21/fs/compat_ioctl.c	2007-04-29 23:50:45.000000000 +0200
@@ -670,8 +670,10 @@ static int hdio_getgeo(unsigned int fd, 
 	if (!err) {
 		err = copy_to_user (ugeo, &geo, 4);
 		err |= __put_user (geo.start, &ugeo->start);
+		if (err)
+			err = -EFAULT;
 	}
-	return err ? -EFAULT : 0;
+	return err;
 }
 
 static int hdio_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
