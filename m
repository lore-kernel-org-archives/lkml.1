Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZFSVJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZFSVJL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZFSVIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:08:45 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:44765 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZFSVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:08:44 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/3] Char: pcmcia/cm4000, fix lock imbalance
Date: Fri, 19 Jun 2009 23:08:27 +0200
Message-Id: <1245445708-27256-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1245445708-27256-1-git-send-email-jirislaby@gmail.com>
References: <1245445708-27256-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't return from switch/case, break instead, so that we unlock BKL.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/pcmcia/cm4000_cs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index dbb9125..881934c 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -1575,7 +1575,8 @@ static long cmm_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		clear_bit(LOCK_IO, &dev->flags);
 		wake_up_interruptible(&dev->ioq);
 
-		return 0;
+		rc = 0;
+		break;
 	case CM_IOCSPTS:
 		{
 			struct ptsreq krnptsreq;
-- 
1.6.3.2

