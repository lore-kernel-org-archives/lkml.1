Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbXKSO3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbXKSO3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 09:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbXKSO25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 09:28:57 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58370 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753222AbXKSO24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 09:28:56 -0500
Date: Mon, 19 Nov 2007 14:27:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] termios: document callback more clearly
Message-ID: <20071119142713.2e15ea74@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/Documentation/tty.txt linux-2.6.24-rc2-mm1/Documentation/tty.txt
--- linux.vanilla-2.6.24-rc2-mm1/Documentation/tty.txt	2007-11-16 17:20:39.000000000 +0000
+++ linux-2.6.24-rc2-mm1/Documentation/tty.txt	2007-11-16 18:10:43.000000000 +0000
@@ -132,6 +132,14 @@
 			tty->termios. Previous settings should be passed in
 			the "old" argument.
 
+			The API is defined such that the driver should return
+			the actual modes selected. This means that the
+			driver function is responsible for modifying any
+			bits in the request it cannot fulfill to indicate
+			the actual modes being used. A device with no
+			hardware capability for change (eg a USB dongle or
+			virtual port) can provide NULL for this method.
+
 throttle()		Notify the tty driver that input buffers for the
 			line discipline are close to full, and it should
 			somehow signal that no more characters should be
