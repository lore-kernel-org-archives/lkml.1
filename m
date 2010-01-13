Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703Ab0AMBBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0AMBBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830Ab0AMBA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:00:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:60373 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab0AMBAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:00:55 -0500
Message-Id: <20100113004938.528241344@suse.com>
User-Agent: quilt/0.48-4.4
Date: Tue, 12 Jan 2010 19:48:56 -0500
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jean Delvare <khali@linux-fr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [patch 1/6] smsc47m1: Fix section mismatch
References: <20100113004855.550486769@suse.com>
Content-Disposition: inline; filename=patches.rpmify/smsc47m1-fix-section-mismatch

 smsc47m1_restore is called from sm_smsc47m1_exit, which is an __exit
 function, so it can't be __init.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/hwmon/smsc47m1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/smsc47m1.c
+++ b/drivers/hwmon/smsc47m1.c
@@ -488,7 +488,7 @@ static int __init smsc47m1_find(unsigned
 }
 
 /* Restore device to its initial state */
-static void __init smsc47m1_restore(const struct smsc47m1_sio_data *sio_data)
+static void smsc47m1_restore(const struct smsc47m1_sio_data *sio_data)
 {
 	if ((sio_data->activate & 0x01) == 0) {
 		superio_enter();


