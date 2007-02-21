Return-Path: <linux-kernel-owner+w=401wt.eu-S1161267AbXBUPN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161267AbXBUPN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161037AbXBUPN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:13:27 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38435 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161267AbXBUPN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:13:26 -0500
Date: Wed, 21 Feb 2007 16:17:12 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: Clarify documentation of ->write()
Message-ID: <20070221161712.4f7ee621@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The tty driver write method is different to the usual fops device write
methods as the buffer is already in kernel space. Clarify the docs since
someone writing a driver made that mistake.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/Documentation/tty.txt linux-2.6.20-mm2/Documentation/tty.txt
--- linux.vanilla-2.6.20-mm2/Documentation/tty.txt	2007-02-20 12:32:28.000000000 +0000
+++ linux-2.6.20-mm2/Documentation/tty.txt	2007-02-21 14:56:36.521024464 +0000
@@ -108,7 +108,9 @@
 structure:
 
 write()			Write a block of characters to the tty device.
-			Returns the number of characters accepted.
+			Returns the number of characters accepted. The 
+			character buffer passed to this method is already
+			in kernel space.
 
 put_char()		Queues a character for writing to the tty device.
 			If there is no room in the queue, the character is
