Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbXKMQyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbXKMQyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbXKMQxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:53:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbXKMQxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:53:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Fix the extern declaration of kallsyms_num_syms [try #2]
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 13 Nov 2007 16:53:16 +0000
Message-ID: <20071113165316.18700.67752.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Fix the extern declaration of kallsyms_num_syms to indicate that the symbol
does not reside in the small-data storage space, and so may not be accessed
relative to the small data base register.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/kallsyms.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 474219a..2fc2581 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -32,9 +32,14 @@
 
 /* These will be re-linked against their real values during the second link stage */
 extern const unsigned long kallsyms_addresses[] __attribute__((weak));
-extern const unsigned long kallsyms_num_syms __attribute__((weak));
 extern const u8 kallsyms_names[] __attribute__((weak));
 
+/* tell the compiler that the count isn't in the small data section if the arch
+ * has one (eg: FRV)
+ */
+extern const unsigned long kallsyms_num_syms
+__attribute__((weak, section(".rodata")));
+
 extern const u8 kallsyms_token_table[] __attribute__((weak));
 extern const u16 kallsyms_token_index[] __attribute__((weak));
 

