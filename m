Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbXBAPh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbXBAPh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbXBAPgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:36:46 -0500
Received: from styx.suse.cz ([82.119.242.94]:34361 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751823AbXBAPgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:36:13 -0500
Date: Thu, 1 Feb 2007 16:36:27 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/10] CHAR-Amiserial: turn local_save_flags() + local_irq_disable()
 into local_irq_save()
In-Reply-To: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0702011616340.13648@jikos.suse.cz>
References: <Pine.LNX.4.64.0702011609090.13648@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

CHAR-Amiserial: turn local_save_flags() + local_irq_disable() into local_irq_save()

drivers/char/amiserial.c::rs_write() contains local_irq_disable()
after local_save_flags(). Turn it into local_irq_save().

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

 drivers/char/amiserial.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index feb4ac8..61f646b 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -904,8 +904,7 @@ static int rs_write(struct tty_struct * tty, const unsigned char *buf, int count
 	if (!info->xmit.buf)
 		return 0;
 
-	local_save_flags(flags);
-	local_irq_disable();
+	local_irq_save(flags);
 	while (1) {
 		c = CIRC_SPACE_TO_END(info->xmit.head,
 				      info->xmit.tail,
