Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYL1Ol0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYL1Ol0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 09:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYL1OlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 09:41:18 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:12606 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYL1OlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 09:41:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=gFSph6IhZiJeYKnY6ziqFNzqv8eKrHzl1pxKmRAvdenRGB8+kz7l/PLSLi0tUVgJCL
         H98Hnx67VcmTBZHQz6WVKK/+OyA+stuqfFAoVKgh8azO0GGoSaeXGdcww29iTaaXmZoc
         HRspjqCYeKuOP5SjdQ7YKsAHUa7dc9WH9Z4h4=
Subject: [PATCH] Fix sg_io_hdr.info corruption.
To: Jens Axboe <jens.axboe@oracle.com>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 28 Dec 2008 17:50:35 +0300
Message-ID: <20081228144946.30288.67559.stgit@zaytsev.su>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(unsigned (short)) is actually sizeof(function), == 1.
Spotted by sparse.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
---
 fs/compat_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 5235c67..7c2d617 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -784,7 +784,7 @@ static int sg_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
 
 	if (copy_in_user(&sgio->status, &sgio32->status,
 			 (4 * sizeof(unsigned char)) +
-			 (2 * sizeof(unsigned (short))) +
+			 (2 * sizeof(unsigned short)) +
 			 (3 * sizeof(int))))
 		return -EFAULT;
 

