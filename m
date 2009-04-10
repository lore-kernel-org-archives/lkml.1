Return-Path: <linux-kernel-owner+w=401wt.eu-S934766AbZDJJzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766AbZDJJzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759384AbZDJJz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:55:28 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:42411 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbZDJJz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:55:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Xd+RMU3SBlKOnegW13kIAng2A4oD3LB29KXkSd09z0UJwJyPdfocLaMi2PKS40ZNnH
         6t93Bdv+EjcUyr+IOhmGcMASZzWI4DGsyIUkZHlz+Qk/72CpBBm1KfM2izKSGASpWsA+
         uQ7YAMv4cAImqHlBmn7ZLUp5DRSBgWXhMZY7Y=
MIME-Version: 1.0
Date: Fri, 10 Apr 2009 11:55:25 +0200
Message-ID: <6e4284620904100255i600e130fpcb2ac967f6f0c5d0@mail.gmail.com>
Subject: [PATCH] asiliantfb: add missing return statement
From: Vlada Peric <vlada.peric@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dilinger@debian.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 032220ba (asiliantfb: fix cmap memory leaks) changed the function
init_asiliant from void to int, resulting in the following compile warning:

drivers/video/asiliantfb.c: In function ‘init_asiliant’:
drivers/video/asiliantfb.c:536: warning: control reaches end of
non-void function

Fix the warning by returning 0.

Signed-off-by: Vlada Perić <vlada.peric@gmail.com>
CC: Andres Salomon <dilinger@debian.org>
---
 drivers/video/asiliantfb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/asiliantfb.c b/drivers/video/asiliantfb.c
index 1a1f946..9fe90ce 100644
--- a/drivers/video/asiliantfb.c
+++ b/drivers/video/asiliantfb.c
@@ -533,6 +533,7 @@ static int __devinit init_asiliant(struct fb_info
*p, unsigned long addr)

 	writeb(0xff, mmio_base + 0x78c);
 	chips_hw_init(p);
+	return 0;
 }

 static int __devinit
-- 
1.6.2.2
