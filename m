Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426Ab0ATXwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0ATXwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359Ab0ATXwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:52:08 -0500
Received: from kroah.org ([198.145.64.141]:37949 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab0ATXuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:50:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/8] serial: serial_cs: oxsemi quirk breaks resume
Date: Wed, 20 Jan 2010 15:50:02 -0800
Message-Id: <1264031403-32239-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100120234759.GC32068@kroah.com>
References: <20100120234759.GC32068@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>

Quirk is applied on all cards with given manfid (is it that correct?).
Unfortunately, that quirk breaks resume on zaurus with billionton
bluetooth card inserted: c950ctrl is 0 and outb() faults.

I believe it is simply not a multiport card.  (info->multi == 1).  ...
...  confirmed by printks.

Signed-off-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/serial_cs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/serial_cs.c b/drivers/serial/serial_cs.c
index 0ee7239..df85440 100644
--- a/drivers/serial/serial_cs.c
+++ b/drivers/serial/serial_cs.c
@@ -146,7 +146,8 @@ static void quirk_wakeup_oxsemi(struct pcmcia_device *link)
 {
 	struct serial_info *info = link->priv;
 
-	outb(12, info->c950ctrl + 1);
+	if (info->c950ctrl)
+		outb(12, info->c950ctrl + 1);
 }
 
 /* request_region? oxsemi branch does no request_region too... */
-- 
1.6.5.7

