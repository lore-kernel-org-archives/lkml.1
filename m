Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZKEALX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZKEALX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZKEALQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:11:16 -0500
Received: from xenotime.net ([72.52.64.118]:60207 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752113AbZKEALO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:11:14 -0500
Date: Wed, 04 Nov 2009 16:04:52 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Tilman Schmidt <tilman@imap.cc>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 7/8] docs: serial/tty, add to ldisc methods
Message-ID: <12573794921501@xenotime.net>
In-Reply-To: <1257379492822@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Subject: Doc: update serial/tty.txt ldisc methods

A small addition to the ldisc method descriptions.

Impact: Documentation
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/serial/tty.txt |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- lnx-2632-rc6.orig/Documentation/serial/tty.txt
+++ lnx-2632-rc6/Documentation/serial/tty.txt
@@ -42,7 +42,8 @@ TTY side interfaces:
 open()		-	Called when the line discipline is attached to
 			the terminal. No other call into the line
 			discipline for this tty will occur until it
-			completes successfully. Can sleep.
+			completes successfully. Returning an error will
+			prevent the ldisc from being attached. Can sleep.
 
 close()		-	This is called on a terminal when the line
 			discipline is being unplugged. At the point of
@@ -52,7 +53,7 @@ close()		-	This is called on a terminal 
 hangup()	-	Called when the tty line is hung up.
 			The line discipline should cease I/O to the tty.
 			No further calls into the ldisc code will occur.
-			Can sleep.
+			The return value is ignored. Can sleep.
 
 write()		-	A process is writing data through the line
 			discipline.  Multiple write calls are serialized
@@ -83,6 +84,10 @@ ioctl()		-	Called when an ioctl is hande
 			that might be for the ldisc. Multiple ioctl calls
 			may occur in parallel. May sleep. 
 
+compat_ioctl()	-	Called when a 32 bit ioctl is handed to the tty layer
+			that might be for the ldisc. Multiple ioctl calls
+			may occur in parallel. May sleep.
+
 Driver Side Interfaces:
 
 receive_buf()	-	Hand buffers of bytes from the driver to the ldisc


-- 

