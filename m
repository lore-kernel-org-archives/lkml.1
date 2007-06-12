Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbXFLXdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbXFLXdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXFLXdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:33:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbXFLXdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:33:10 -0400
Date: Tue, 12 Jun 2007 19:33:09 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Fix empty macros in acpi.
Message-ID: <20070612233309.GA24251@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI has a ton of macros which make a bunch of empty if's
when configured in non-debug mode.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 4334c20..5955cfd 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -16,7 +16,7 @@
 #if ACPI_GLUE_DEBUG
 #define DBG(x...) printk(PREFIX x)
 #else
-#define DBG(x...)
+#define DBG(x...) do { } while(0)
 #endif
 static LIST_HEAD(bus_type_list);
 static DECLARE_RWSEM(bus_type_sem);
diff --git a/include/acpi/acmacros.h b/include/acpi/acmacros.h
index 8948a64..e64a748 100644
--- a/include/acpi/acmacros.h
+++ b/include/acpi/acmacros.h
@@ -599,26 +599,26 @@
 #define ACPI_DEBUG_EXEC(a)
 #define ACPI_NORMAL_EXEC(a)             a;
 
-#define ACPI_DEBUG_DEFINE(a)
-#define ACPI_DEBUG_ONLY_MEMBERS(a)
-#define ACPI_FUNCTION_NAME(a)
-#define ACPI_FUNCTION_TRACE(a)
-#define ACPI_FUNCTION_TRACE_PTR(a,b)
-#define ACPI_FUNCTION_TRACE_U32(a,b)
-#define ACPI_FUNCTION_TRACE_STR(a,b)
-#define ACPI_FUNCTION_EXIT
-#define ACPI_FUNCTION_STATUS_EXIT(s)
-#define ACPI_FUNCTION_VALUE_EXIT(s)
-#define ACPI_FUNCTION_ENTRY()
-#define ACPI_DUMP_STACK_ENTRY(a)
-#define ACPI_DUMP_OPERANDS(a,b,c,d,e)
-#define ACPI_DUMP_ENTRY(a,b)
-#define ACPI_DUMP_TABLES(a,b)
-#define ACPI_DUMP_PATHNAME(a,b,c,d)
-#define ACPI_DUMP_RESOURCE_LIST(a)
-#define ACPI_DUMP_BUFFER(a,b)
-#define ACPI_DEBUG_PRINT(pl)
-#define ACPI_DEBUG_PRINT_RAW(pl)
+#define ACPI_DEBUG_DEFINE(a)		do { } while(0)
+#define ACPI_DEBUG_ONLY_MEMBERS(a)	do { } while(0)
+#define ACPI_FUNCTION_NAME(a)		do { } while(0)
+#define ACPI_FUNCTION_TRACE(a)		do { } while(0)
+#define ACPI_FUNCTION_TRACE_PTR(a,b)	do { } while(0)
+#define ACPI_FUNCTION_TRACE_U32(a,b)	do { } while(0)
+#define ACPI_FUNCTION_TRACE_STR(a,b)	do { } while(0)
+#define ACPI_FUNCTION_EXIT		do { } while(0)
+#define ACPI_FUNCTION_STATUS_EXIT(s)	do { } while(0)
+#define ACPI_FUNCTION_VALUE_EXIT(s)	do { } while(0)
+#define ACPI_FUNCTION_ENTRY()		do { } while(0)
+#define ACPI_DUMP_STACK_ENTRY(a)	do { } while(0)
+#define ACPI_DUMP_OPERANDS(a,b,c,d,e)	do { } while(0)
+#define ACPI_DUMP_ENTRY(a,b)		do { } while(0)
+#define ACPI_DUMP_TABLES(a,b)		do { } while(0)
+#define ACPI_DUMP_PATHNAME(a,b,c,d)	do { } while(0)
+#define ACPI_DUMP_RESOURCE_LIST(a)	do { } while(0)
+#define ACPI_DUMP_BUFFER(a,b)		do { } while(0)
+#define ACPI_DEBUG_PRINT(pl)		do { } while(0)
+#define ACPI_DEBUG_PRINT_RAW(pl)	do { } while(0)
 
 #define return_VOID                     return
 #define return_ACPI_STATUS(s)           return(s)



-- 
http://www.codemonkey.org.uk
