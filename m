Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbZA1VOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbZA1VOc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZA1VOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:14:18 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:37015 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZA1VOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:14:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=u+DmcP4fw9vvTMOAmBr7EoVZb/P2pND8S/P8fsjgnNXCOuvMGeUDRt3DpZxEpDMOBD
         cMWrruZSXkeX3BPf6cNuCICXYvGv2H8/UBRImtH2Ximgd19CIBT3D3FtkQEBemvIr0x2
         JS1QzaePJO3TUmWoogkmzopYdGz4U8aEuwrrA=
Message-ID: <4980CAA9.1060301@gmail.com>
Date: Wed, 28 Jan 2009 22:14:17 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [STAGING] fix verification of memory area
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix verification of memory area

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
index ec343ef..0d111dd 100644
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -1026,7 +1026,7 @@ static int poch_ioctl(struct inode *inode, struct file *filp,
 		}
 		break;
 	case POCH_IOC_GET_COUNTERS:
-		if (access_ok(VERIFY_WRITE, argp, sizeof(struct poch_counters)))
+		if (!access_ok(VERIFY_WRITE, argp, sizeof(struct poch_counters)))
 			return -EFAULT;
 
 		spin_lock_irq(&channel->counters_lock);
