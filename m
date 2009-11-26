Return-Path: <linux-kernel-owner+w=401wt.eu-S1758545AbZKZEQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbZKZEQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 23:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbZKZEQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 23:16:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36625 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbZKZEQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 23:16:15 -0500
Date: Thu, 26 Nov 2009 15:16:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Roel Kluin <roel.kluin@gmail.com>, Len Brown <len.brown@intel.com>
Subject: linux-next: manual merge of the backlight tree with the acpi tree
Message-Id: <20091126151619.5161466e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

Today's linux-next merge of the backlight tree got a conflict in
drivers/platform/x86/thinkpad_acpi.c between commit
80a8d1228e90349b4514e8c925c061fa5cbcea75 ("thinkpad-acpi: fix sign of
ERESTARTSYS return") from the acpi tree and commit
9c2f754d86c96ef548c6c444a6b0da421105c76e ("backlight/thinkpad-acpi: issue
backlight class events") from the backlight tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/platform/x86/thinkpad_acpi.c
index db1c099,9a2e9a7..0000000
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@@ -6325,7 -6325,10 +6337,10 @@@ static int brightness_write(char *buf
  	 * Doing it this way makes the syscall restartable in case of EINTR
  	 */
  	rc = brightness_set(level);
+ 	if (!rc && ibm_backlight_device)
+ 		backlight_force_update(ibm_backlight_device,
+ 					BACKLIGHT_UPDATE_SYSFS);
 -	return (rc == -EINTR)? ERESTARTSYS : rc;
 +	return (rc == -EINTR)? -ERESTARTSYS : rc;
  }
  
  static struct ibm_struct brightness_driver_data = {
