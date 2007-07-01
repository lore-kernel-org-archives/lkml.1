Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbXGAPPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbXGAPPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 11:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbXGAPPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 11:15:05 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:43863
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750830AbXGAPPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 11:15:04 -0400
Date: Sun, 1 Jul 2007 17:16:10 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: davem@davemloft.net, wli@holomorphy.com, sparclinux@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Videopix Frame Grabber: Fix unreleased lock in vfc_debug()
Message-ID: <20070701151610.GA3940@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	davem@davemloft.net, wli@holomorphy.com, sparclinux@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Videopix Frame Grabber: vfc_debug() doesn't release the device lock
when copy_from_user() fails

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

---

diff --git a/drivers/sbus/char/vfc_dev.c b/drivers/sbus/char/vfc_dev.c
index 6afc7e5..1cbdabd 100644
--- a/drivers/sbus/char/vfc_dev.c
+++ b/drivers/sbus/char/vfc_dev.c
@@ -248,6 +248,7 @@ static int vfc_debug(struct vfc_dev *dev, int cmd, void __user *argp)
 					buffer,inout.len);
 
 		if (copy_to_user(argp,&inout,sizeof(inout))) {
+			vfc_unlock_device(dev);
 			kfree(buffer);
 			return -EFAULT;
 		}
 
-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona


   Usually when people are sad, they don't do anything. They just cry over
     their condition. But when they get angry, they bring about a change
                              (Malcolm X)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
