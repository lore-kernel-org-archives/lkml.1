Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZIFS7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZIFS7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 14:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758168AbZIFS7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 14:59:16 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:42846 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159AbZIFS7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 14:59:11 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH] Documentation: extend tty.txt
To: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Message-Id: <20090906185852.4DDE0111865@xenon.ts.pxnet.com>
Date: Sun,  6 Sep 2009 20:58:52 +0200 (CEST)
X-Spam-Score: -1.593 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A small addition to the ldisc method descriptions.

Impact: Documentation
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 Documentation/serial/tty.txt |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/serial/tty.txt b/Documentation/serial/tty.txt
index 8e65c44..6528a89 100644
--- a/Documentation/serial/tty.txt
+++ b/Documentation/serial/tty.txt
@@ -42,7 +42,8 @@ TTY side interfaces:
 open()		-	Called when the line discipline is attached to
 			the terminal. No other call into the line
 			discipline for this tty will occur until it
-			completes successfully. Can sleep.
+			completes successfully. Returning an error will
+			prevent the ldisc from being attached. Can sleep.
 
 close()		-	This is called on a terminal when the line
 			discipline is being unplugged. At the point of
@@ -52,7 +53,7 @@ close()		-	This is called on a terminal when the line
 hangup()	-	Called when the tty line is hung up.
 			The line discipline should cease I/O to the tty.
 			No further calls into the ldisc code will occur.
-			Can sleep.
+			The return value is ignored. Can sleep.
 
 write()		-	A process is writing data through the line
 			discipline.  Multiple write calls are serialized
@@ -83,6 +84,10 @@ ioctl()		-	Called when an ioctl is handed to the tty layer
 			that might be for the ldisc. Multiple ioctl calls
 			may occur in parallel. May sleep. 
 
+compat_ioctl()	-	Called when a 32 bit ioctl is handed to the tty layer
+			that might be for the ldisc. Multiple ioctl calls
+			may occur in parallel. May sleep.
+
 Driver Side Interfaces:
 
 receive_buf()	-	Hand buffers of bytes from the driver to the ldisc
-- 
1.6.2.1.214.ge986c

