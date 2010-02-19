Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab0BSR6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:58:49 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:31163 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab0BSR6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:58:45 -0500
Subject: [PATCH v1 5/7] resource: add window support
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>
Date: Fri, 19 Feb 2010 10:58:43 -0700
Message-ID: <20100219175843.9199.32618.stgit@bob.kio>
In-Reply-To: <20100219175655.9199.30691.stgit@bob.kio>
References: <20100219175655.9199.30691.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add support for resource windows.  This is for bridge resources, i.e.,
regions where a bridge forwards transactions from the primary to the
secondary side.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 include/linux/ioport.h |    1 +
 lib/vsprintf.c         |    4 +++-
 2 files changed, 4 insertions(+), 1 deletions(-)


diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 17c9b0e..8ea584d 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -51,6 +51,7 @@ struct resource_list {
 #define IORESOURCE_STARTALIGN	0x00080000	/* start field is alignment */
 
 #define IORESOURCE_MEM_64	0x00100000
+#define IORESOURCE_WINDOW	0x00200000	/* forwarded by bridge */
 
 #define IORESOURCE_EXCLUSIVE	0x08000000	/* Userland may not map this resource */
 #define IORESOURCE_DISABLED	0x10000000
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index af3236c..e9bca8d 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -635,7 +635,7 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 	 * 64-bit res (sizeof==8): 20 chars in dec, 18 in hex ("0x" + 16) */
 #define RSRC_BUF_SIZE		((2 * sizeof(resource_size_t)) + 4)
 #define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
-#define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref disabled]")
+#define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref window disabled]")
 #define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
 	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
 		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
@@ -675,6 +675,8 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 			p = string(p, pend, " 64bit", str_spec);
 		if (res->flags & IORESOURCE_PREFETCH)
 			p = string(p, pend, " pref", str_spec);
+		if (res->flags & IORESOURCE_WINDOW)
+			p = string(p, pend, " window", str_spec);
 		if (res->flags & IORESOURCE_DISABLED)
 			p = string(p, pend, " disabled", str_spec);
 	} else {

