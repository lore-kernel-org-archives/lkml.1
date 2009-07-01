Return-Path: <linux-kernel-owner+w=401wt.eu-S1762507AbZGAAoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762507AbZGAAoB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760959AbZGAAc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:32:58 -0400
Received: from kroah.org ([198.145.64.141]:59850 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760523AbZGAAc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:32:57 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:52 2009
Message-Id: <20090701001552.244954110@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>
Subject: [patch 23/35] vt_ioctl: fix lock imbalance
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=vt_ioctl-fix-lock-imbalance.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit a115902f67ef51fbbe83e214fb761aaa9734c1ce upstream.

Don't return from switch/case directly in vt_ioctl. Set ret and break
instead so that we unlock BKL.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/vt_ioctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -396,7 +396,8 @@ int vt_ioctl(struct tty_struct *tty, str
 	kbd = kbd_table + console;
 	switch (cmd) {
 	case TIOCLINUX:
-		return tioclinux(tty, arg);
+		ret = tioclinux(tty, arg);
+		break;
 	case KIOCSOUND:
 		if (!perm)
 			goto eperm;


