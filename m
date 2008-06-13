Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbYFMI5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbYFMI5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 04:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYFMI5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 04:57:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:23180 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbYFMI5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 04:57:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=kfYFw+KZ1CFf/Yzjg7I1a9FtV2avLdg9yrycKABnUuAZaQG7hYEkFhbmE9Ld9G/v6z
         a1Cx6Bo2eVC3No1GsNcX3CANnJtSOq8lALti1GaHecqEyvfFt8kvS8M8uTeRhoNRJvoi
         4VGI4523DZ1gD2XaO+GzRr1dm7vP6wcX41YLs=
Date: Fri, 13 Jun 2008 10:57:16 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] kallsyms: unify 32- and 64-bit code
Message-ID: <20080613085716.GB3139@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 13 Jun 2008 10:02:26 +0200
Subject: [PATCH] kallsyms: unify 32- and 64-bit code

Use the %p format string which already accounts for the padding you need
with a pointer type on a particular architecture.

Also replace the macro with a static inline function to match the rest of
the file.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/kallsyms.h |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 00c1801..57aefa1 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -6,6 +6,7 @@
 #define _LINUX_KALLSYMS_H
 
 #include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/stddef.h>
 
 #define KSYM_NAME_LEN 128
@@ -105,18 +106,10 @@ static inline void print_fn_descriptor_symbol(const char *fmt, void *addr)
 	print_symbol(fmt, (unsigned long)addr);
 }
 
-#ifndef CONFIG_64BIT
-#define print_ip_sym(ip)		\
-do {					\
-	printk("[<%08lx>]", ip);	\
-	print_symbol(" %s\n", ip);	\
-} while(0)
-#else
-#define print_ip_sym(ip)		\
-do {					\
-	printk("[<%016lx>]", ip);	\
-	print_symbol(" %s\n", ip);	\
-} while(0)
-#endif
+static inline void print_ip_sym(unsigned long ip)
+{
+	printk("[<%p>]", (void *) ip);
+	print_symbol(" %s\n", ip);
+}
 
 #endif /*_LINUX_KALLSYMS_H*/
-- 
1.5.4.1

