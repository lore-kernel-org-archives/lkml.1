Return-Path: <linux-kernel-owner+w=401wt.eu-S1758312AbXESJwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312AbXESJwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 05:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXESJwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 05:52:00 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:40513 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754767AbXESJv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 05:51:59 -0400
Message-id: <37615320526925076@wsc.cz>
Subject: [PATCH 1/2] Misc: misc-phantom-move-to-unlocked_ioctl-fix
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sat, 19 May 2007 11:51:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

misc-phantom-move-to-unlocked_ioctl-fix

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit fd826c7ffca5d1052a742d04f819c0251856cc6b
tree bad1cf29a70b1ff7171e1d2082967ab31f8383aa
parent d2f8feac3bd0ec0cd2d44a41fcbdb7568ac8629e
author Jiri Slaby <jirislaby@gmail.com> Sat, 19 May 2007 11:20:26 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 19 May 2007 11:20:26 +0200

 drivers/misc/phantom.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 6249767..4b5959b 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -125,9 +125,7 @@ static long phantom_ioctl(struct file *file, unsigned int cmd,
 		if (r.reg > 7)
 			return -EINVAL;
 
-		spin_lock(&dev->ioctl_lock);
 		r.value = ioread32(dev->iaddr + r.reg);
-		spin_unlock(&dev->ioctl_lock);
 
 		if (copy_to_user(argp, &r, sizeof(r)))
 			return -EFAULT;
