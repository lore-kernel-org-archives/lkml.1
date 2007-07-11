Return-Path: <linux-kernel-owner+w=401wt.eu-S1765036AbXGKOaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765036AbXGKOaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 10:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762554AbXGKOaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 10:30:05 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55445 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761962AbXGKOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 10:30:04 -0400
Message-ID: <4694E966.9040607@sgi.com>
Date: Wed, 11 Jul 2007 16:29:58 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060527)
MIME-Version: 1.0
To: akpm@linux-foundation.org
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org
Subject: [patch] sn_console section mismatch warning
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------000608060107030400030100"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000608060107030400030100
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

This one eliminates a link-time warning for the sn_console driver.

Cheers,
Jes


--------------000608060107030400030100
Content-Type: text/plain;
 name="sn_console-link-warn.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sn_console-link-warn.diff"

Do not mark sn_sal_console_setup as __init since it's referenced from
non init data structures.

Signed-off-by: Jes Sorensen <jes@sgi.com>

---
 drivers/serial/sn_console.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/serial/sn_console.c
===================================================================
--- linux-2.6.orig/drivers/serial/sn_console.c
+++ linux-2.6/drivers/serial/sn_console.c
@@ -759,7 +759,7 @@ static void __init sn_sal_switch_to_inte
  */
 
 static void sn_sal_console_write(struct console *, const char *, unsigned);
-static int __init sn_sal_console_setup(struct console *, char *);
+static int sn_sal_console_setup(struct console *, char *);
 static struct uart_driver sal_console_uart;
 extern struct tty_driver *uart_console_device(struct console *, int *);
 
@@ -1006,7 +1006,7 @@ sn_sal_console_write(struct console *co,
  * here so providing it is easier.
  *
  */
-static int __init sn_sal_console_setup(struct console *co, char *options)
+static int sn_sal_console_setup(struct console *co, char *options)
 {
 	return 0;
 }

--------------000608060107030400030100--
