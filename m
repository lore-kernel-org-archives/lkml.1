Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbXLDO2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbXLDO2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 09:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXLDO2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 09:28:39 -0500
Received: from shadow.wildlava.net ([67.40.138.81]:59701 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbXLDO2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 09:28:38 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Dec 2007 09:28:38 EST
Message-ID: <475561E7.80304@skyrush.com>
Date: Tue, 04 Dec 2007 07:19:19 -0700
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071127)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] echo ctrl characters on INTR/QUIT/SUSP
X-Enigmail-Version: 0.95.5
Content-Type: multipart/mixed;
 boundary="------------000004040002060903020005"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000004040002060903020005
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The stty setting, "echoctl", directs the tty to echo control characters
as a normal letter prefixed by "^" (such as "^C" for the default INTR
setting).  Linux does not currently echo for the INTR/QUIT/SUSP signals,
whereas all other "unix" variants I have used over the years do, to my
recollection anyway (I recently tested: Solaris, BSD, Mac OS X).  I find
this a really nice feature, since it becomes very clear at a glance that
a terminal process was interrupted explicitly rather than finishing
normally (when I am running many things in different windows, it's nice
to verify which ones I interrupted).  It's just nice to see that echo
for positive feedback, and it seems to be standard OS behavior.

If you try this patch and don't see the echo, make sure echoctl is on
("stty echoctl").  I have applied this patch to 2.6.22 in my tests.  I
welcome feedback, as I have not seen this issue addressed before.
Please cc me at my address above on replies.

					Thanks, Joe


--------------000004040002060903020005
Content-Type: text/plain;
 name="gentoo-sources-2.6.22-echoctl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gentoo-sources-2.6.22-echoctl.patch"

--- linux-2.6.22-gentoo-r9.old/drivers/char/n_tty.c	2007-12-03 16:25:05.000000000 -0700
+++ linux-2.6.22-gentoo-r9/drivers/char/n_tty.c	2007-12-03 21:58:44.000000000 -0700
@@ -761,6 +761,9 @@
 		if (c == SUSP_CHAR(tty)) {
 send_signal:
 			isig(signal, tty, 0);
+			if (L_ECHO(tty)) {
+				echo_char(c, tty);
+			}
 			return;
 		}
 	}

--------------000004040002060903020005--
