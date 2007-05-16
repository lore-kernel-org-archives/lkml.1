Return-Path: <linux-kernel-owner+w=401wt.eu-S1763289AbXEPXfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763289AbXEPXfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 19:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763064AbXEPXf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 19:35:26 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:15728 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762920AbXEPXfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 19:35:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=FR4wpZ6jMVEpByPQ4k/uLp4gmt9FDNgkq6YedTkmtLOVhS0vTNyEY0phvzcLv3fXq2FA6iDRLtnUm3pVa5NU3qTzU0u4v8L/mcKzo70wJKPbjHhVFMQqhjO4hx0pWa1ZvLxjSz4i9DDFgZCi3LxGMhtTt/fohme5oGPOoEXCIr8=
Message-ID: <464B94DC.2090206@gmail.com>
Date: Wed, 16 May 2007 19:33:48 -0400
From: Florin Malita <fmalita@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net, a.paterniani@swapp-eng.it
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] spi: potential memleak in spidev_ioctl
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

'ioc' should be deallocated if __copy_from_user fails (found by Coverity 
- CID 1644).

Signed-off-by: Florin Malita <fmalita@gmail.com>
---

 spidev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index c0a6dce..2464f34 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -364,6 +364,7 @@ spidev_ioctl(struct inode *inode, struct file *filp,
 			break;
 		}
 		if (__copy_from_user(ioc, (void __user *)arg, tmp)) {
+			kfree(ioc);
 			retval = -EFAULT;
 			break;
 		}

