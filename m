Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbZGAAhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbZGAAhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759611AbZGAAa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:30:29 -0400
Received: from kroah.org ([198.145.64.141]:34391 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759859AbZGAAaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:30:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:04:00 2009
Message-Id: <20090701000400.308901757@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:00:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>
Subject: [patch 25/30] pcmcia/cm4000: fix lock imbalance
References: <20090630235944.868879272@mini.kroah.org>
Content-Disposition: inline; filename=pcmcia-cm4000-fix-lock-imbalance.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 69ae59d7d8df14413cf0a97b3e372d7dc8352563 upstream.

Don't return from switch/case, break instead, so that we unlock BKL.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/pcmcia/cm4000_cs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -1575,7 +1575,8 @@ static long cmm_ioctl(struct file *filp,
 		clear_bit(LOCK_IO, &dev->flags);
 		wake_up_interruptible(&dev->ioq);
 
-		return 0;
+		rc = 0;
+		break;
 	case CM_IOCSPTS:
 		{
 			struct ptsreq krnptsreq;


