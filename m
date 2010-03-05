Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0CERrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:47:47 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:39882 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab0CERrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:47:43 -0500
Subject: [PATCH v2 4/7] resource: add bus number support
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>
Date: Fri, 05 Mar 2010 10:47:42 -0700
Message-ID: <20100305174742.21946.12508.stgit@bob.kio>
In-Reply-To: <20100305174656.21946.93874.stgit@bob.kio>
References: <20100305174656.21946.93874.stgit@bob.kio>
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
index b126209..510e4ac 100644
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
index 4d58d28..bcabb2f 100644
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

