Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbYJEQVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbYJEQVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbYJEQSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:18:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49657 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758191AbYJEQSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:18:00 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 46/76] vt: remove bogus lock dropping
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:18:00 +0100
Message-ID: <20081005161719.1997.68602.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For hysterical raisins the vt layer drops and retakes locks in the write
method. This is a left over from the days when user/kernel data was passed
directly to the tty not pre-buffered.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/vt.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 05ca1c5..ec94521 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2136,27 +2136,9 @@ static int do_con_write(struct tty_struct *tty, const unsigned char *buf, int co
 	    release_console_sem();
 	    return 0;
 	}
-	release_console_sem();
-
 	orig_buf = buf;
 	orig_count = count;
 
-	/* At this point 'buf' is guaranteed to be a kernel buffer
-	 * and therefore no access to userspace (and therefore sleeping)
-	 * will be needed.  The con_buf_mtx serializes all tty based
-	 * console rendering and vcs write/read operations.  We hold
-	 * the console spinlock during the entire write.
-	 */
-
-	acquire_console_sem();
-
-	vc = tty->driver_data;
-	if (vc == NULL) {
-		printk(KERN_ERR "vt: argh, driver_data _became_ NULL !\n");
-		release_console_sem();
-		goto out;
-	}
-
 	himask = vc->vc_hi_font_mask;
 	charmask = himask ? 0x1ff : 0xff;
 

