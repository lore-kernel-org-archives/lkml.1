Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab0BSR6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:58:42 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37540 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab0BSR6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:58:39 -0500
Subject: [PATCH v1 4/7] resource: add bus number support
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>
Date: Fri, 19 Feb 2010 10:58:38 -0700
Message-ID: <20100219175838.9199.46837.stgit@bob.kio>
In-Reply-To: <20100219175655.9199.30691.stgit@bob.kio>
References: <20100219175655.9199.30691.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add support for bus number resources.  This is for bridges with a range of
bus numbers behind them.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 include/linux/ioport.h |    1 +
 lib/vsprintf.c         |    9 +++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)


diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index e38dedc..17c9b0e 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -39,6 +39,7 @@ struct resource_list {
 #define IORESOURCE_MEM		0x00000200
 #define IORESOURCE_IRQ		0x00000400
 #define IORESOURCE_DMA		0x00000800
+#define IORESOURCE_BUS		0x00001000
 
 #define IORESOURCE_PREFETCH	0x00002000	/* No side effects */
 #define IORESOURCE_READONLY	0x00004000
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 9ed3976..af3236c 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -609,6 +609,12 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 		.precision = -1,
 		.flags = SPECIAL | SMALL | ZEROPAD,
 	};
+	static const struct printf_spec bus_spec = {
+		.base = 16,
+		.field_width = 2,
+		.precision = -1,
+		.flags = SMALL | ZEROPAD,
+	};
 	static const struct printf_spec dec_spec = {
 		.base = 10,
 		.precision = -1,
@@ -651,6 +657,9 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 	} else if (res->flags & IORESOURCE_DMA) {
 		p = string(p, pend, "dma ", str_spec);
 		specp = &dec_spec;
+	} else if (res->flags & IORESOURCE_BUS) {
+		p = string(p, pend, "bus ", str_spec);
+		specp = &bus_spec;
 	} else {
 		p = string(p, pend, "??? ", str_spec);
 		specp = &mem_spec;

