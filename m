Return-Path: <linux-kernel-owner+w=401wt.eu-S934175AbZIDUPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175AbZIDUPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934168AbZIDUPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:15:11 -0400
Received: from kroah.org ([198.145.64.141]:36323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934135AbZIDUOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:57 2009
Message-Id: <20090904200857.121342149@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Alan Cox <alan@linux.intel.com>
Subject: [patch 46/48] Remove low_latency flag setting from nozomi and mxser drivers
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=remove-low_latency-flag-setting-from-nozomi-and-mxser-drivers.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chuck Ebbert <cebbert@redhat.com>

commit 4d8d4d251df8eaaa3dae71c8cfa7fbf4510d967d upstream

[ cebbert@redhat.com: backport to 2.6.27 ]

Remove low_latency flag setting from nozomi and mxser drivers

The kernel oopses if this flag is set.

[and neither driver should set it as they call tty_flip_buffer_push from IRQ
 paths so have always been buggy]

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

---
 drivers/char/mxser.c  |    2 --
 drivers/char/nozomi.c |    1 -
 2 files changed, 3 deletions(-)

--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1099,8 +1099,6 @@ static int mxser_open(struct tty_struct 
 	if (retval)
 		return retval;
 
-	/* unmark here for very high baud rate (ex. 921600 bps) used */
-	tty->low_latency = 1;
 	return 0;
 }
 
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1584,7 +1584,6 @@ static int ntty_open(struct tty_struct *
 
 	/* Enable interrupt downlink for channel */
 	if (port->tty_open_count == 1) {
-		tty->low_latency = 1;
 		tty->driver_data = port;
 		port->tty = tty;
 		DBG1("open: %d", port->token_dl);


