Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbXKZRpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbXKZRpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 12:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXKZRpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 12:45:09 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:33160 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbXKZRpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 12:45:06 -0500
Date: Mon, 26 Nov 2007 09:43:21 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, dengxw@163.com,
       herbert@gondor.apana.org.au
Subject: [PATCH] hexdump: don't print bytes with bit 7 set
Message-Id: <20071126094321.c5c82f49.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

As Herbert Xu pointed out, bytes (chars) with bit 7 (0x80) set are
true with isprint() but they may not be isascii() but be Unicode
instead, so don't try to print them in hex dumps.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 lib/hexdump.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.24-rc3.orig/lib/hexdump.c
+++ linux-2.6.24-rc3/lib/hexdump.c
@@ -106,7 +106,8 @@ void hex_dump_to_buffer(const void *buf,
 	while (lx < (linebuflen - 1) && lx < (ascii_column - 1))
 		linebuf[lx++] = ' ';
 	for (j = 0; (j < rowsize) && (j < len) && (lx + 2) < linebuflen; j++)
-		linebuf[lx++] = isprint(ptr[j]) ? ptr[j] : '.';
+		linebuf[lx++] = (isascii(ptr[j]) && isprint(ptr[j])) ? ptr[j]
+				: '.';
 nil:
 	linebuf[lx++] = '\0';
 }
