Return-Path: <linux-kernel-owner+w=401wt.eu-S934443AbZLKX32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443AbZLKX32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934405AbZLKX3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:22 -0500
Received: from kroah.org ([198.145.64.141]:50479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933962AbZLKX3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:06 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tilman Schmidt <tilman@imap.cc>, Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/58] tty: docs: serial/tty, add to ldisc methods
Date: Fri, 11 Dec 2009 15:28:06 -0800
Message-Id: <1260574122-10676-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>

A small addition to the ldisc method descriptions.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/serial/tty.txt |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/serial/tty.txt b/Documentation/serial/tty.txt
index 8e65c44..5e5349a 100644
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
1.6.5.5

