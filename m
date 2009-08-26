Return-Path: <linux-kernel-owner+w=401wt.eu-S1751602AbZHZPmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbZHZPmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 11:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbZHZPmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 11:42:17 -0400
Received: from server78.greatnet.de ([83.133.96.102]:50754 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZHZPmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 11:42:13 -0400
X-Greylist: delayed 634 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 11:42:13 EDT
Message-ID: <4A955556.8000104@nachtwindheim.de>
Date: Wed, 26 Aug 2009 17:31:34 +0200
From: Henne <henne@nachtwindheim.de>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: mingo@elte.hu
CC: corbet@lwn.net, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: kill-the-BKL/vt: Prevent holding the BKL on return to userspace
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Henrik Kretzschmar <henne@nachtwindheim.de>

kill-the-BKL/vt: Prevent holding the BKL on return to userspace

Returning from a function which holds the BLK isn't a good idea,
so we won't let it return from this point.
Instead we set the return variable and let the function return the
normal way without BKL held.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

---
This patch is only for the kill-the-BKL branch.

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 181ff38..b3da7b3 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -396,7 +396,9 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 	kbd = kbd_table + console;
 	switch (cmd) {
 	case TIOCLINUX:
-		return tioclinux(tty, arg);
+		ret = tioclinux(tty, arg);
+		break;
+
 	case KIOCSOUND:
 		if (!perm)
 			goto eperm;


