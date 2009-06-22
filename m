Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbZFVQon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbZFVQon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZFVQoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:44:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37488 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755046AbZFVQoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:44:12 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 06/15] pcmcia/cm4000: fix lock imbalance
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:42:10 +0100
Message-ID: <20090622174208.25341.53203.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
References: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Don't return from switch/case, break instead, so that we unlock BKL.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable@kernel.org
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

