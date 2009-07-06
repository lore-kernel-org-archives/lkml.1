Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZGFPNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZGFPNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbZGFPN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:13:28 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:53060 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZGFPN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:13:27 -0400
Message-ID: <4A52141A.8020709@linux.vnet.ibm.com>
Date: Mon, 06 Jul 2009 17:11:22 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: allow whitespace as kernel parameter separator
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Some boot mechanisms require that kernel parameters are stored in a
separate file which is loaded to memory without further processing
(e.g. the "Load from FTP" method on s390). When such a file contains
newline characters, the kernel parameter preceding the newline might
not be correctly parsed (due to the newline being stuck to the end of
the actual parameter value) which can lead to boot failures.

This patch improves kernel command line usability in such a situation
by allowing generic whitespace characters as separators between kernel
parameters.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---

 kernel/params.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6.31-rc2/kernel/params.c
===================================================================
--- linux-2.6.31-rc2.orig/kernel/params.c
+++ linux-2.6.31-rc2/kernel/params.c
@@ -23,6 +23,7 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/ctype.h>
 
 #if 0
 #define DEBUGP printk
@@ -87,7 +88,7 @@ static char *next_arg(char *args, char *
 	}
 
 	for (i = 0; args[i]; i++) {
-		if (args[i] == ' ' && !in_quote)
+		if (isspace(args[i]) && !in_quote)
 			break;
 		if (equals == 0) {
 			if (args[i] == '=')
@@ -121,7 +122,7 @@ static char *next_arg(char *args, char *
 		next = args + i;
 
 	/* Chew up trailing spaces. */
-	while (*next == ' ')
+	while (isspace(*next))
 		next++;
 	return next;
 }
@@ -138,7 +139,7 @@ int parse_args(const char *name,
 	DEBUGP("Parsing ARGS: %s\n", args);
 
 	/* Chew leading spaces */
-	while (*args == ' ')
+	while (isspace(*args))
 		args++;
 
 	while (*args) {

