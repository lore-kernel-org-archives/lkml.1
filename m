Return-Path: <linux-kernel-owner+w=401wt.eu-S940134AbXGTQC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940134AbXGTQC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933142AbXGTQCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:02:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933011AbXGTQCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:02:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Fix linkage problems
To: torvalds@osdl.org, akpm@osdl.org, roland@redhat.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 20 Jul 2007 17:02:04 +0100
Message-ID: <20070720160204.25719.64703.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Make it possible to use __start_notes and __stop_notes without getting a GPREL
overflow error from the FRV linker.

Small variables that would otherwise be in .data or .bss may, depending on the
arch, be placed in special sections (.sdata or .sbss) that permit single
instruction references on fixed instruction width machines.

__start_notes and __stop_notes aren't really char variables, and certainly
don't refer to data in .data or .bss.  Making them type "void" fools the
compiler into not assuming anything about them.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/ksysfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 2565e1b..d0e5c48 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -65,8 +65,8 @@ KERNEL_ATTR_RO(kexec_crash_loaded);
 /*
  * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
  */
-extern const char __start_notes __attribute__((weak));
-extern const char __stop_notes __attribute__((weak));
+extern const void __start_notes __attribute__((weak));
+extern const void __stop_notes __attribute__((weak));
 #define	notes_size (&__stop_notes - &__start_notes)
 
 static ssize_t notes_read(struct kobject *kobj, struct bin_attribute *bin_attr,

