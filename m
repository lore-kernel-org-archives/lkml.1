Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbZFST5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbZFST5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 15:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZFST5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 15:57:47 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46050 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710AbZFST5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 15:57:46 -0400
Date: Fri, 19 Jun 2009 15:57:21 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anders Kaseorg <andersk@ksplice.com>,
       Jeffrey B Arnold <jbarnold@ksplice.com>
Subject: [PATCH] Add new TAINT_KSPLICE flag for when a Ksplice update has
 been loaded.
Message-ID: <alpine.DEB.1.10.0906191422460.29844@vinegar-pot.mit.edu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Distributions and kerneloops.org have requested that the Ksplice
rebootless update system taint the kernel the first time that a
Ksplice update is installed, in order to assist with bug triage.

Ksplice uses a new taint flag, TAINT_KSPLICE, displayed as 'K', for
this purpose.

We would like to confirm that this use of taint meets with the
community's approval and get this taint flag registered in mainline.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 include/linux/kernel.h |    1 +
 kernel/panic.c         |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c5a71c3..be77585 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -330,6 +330,7 @@ extern enum system_states {
 #define TAINT_OVERRIDDEN_ACPI_TABLE	8
 #define TAINT_WARN			9
 #define TAINT_CRAP			10
+#define TAINT_KSPLICE			11
 
 extern void dump_stack(void) __cold;
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 984b3ec..c2ea780 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -160,6 +160,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_OVERRIDDEN_ACPI_TABLE,	'A', ' ' },
 	{ TAINT_WARN,			'W', ' ' },
 	{ TAINT_CRAP,			'C', ' ' },
+	{ TAINT_KSPLICE,		'K', ' ' },
 };
 
 /**
@@ -176,6 +177,7 @@ static const struct tnt tnts[] = {
  *  'A' - ACPI table overridden.
  *  'W' - Taint on warning.
  *  'C' - modules from drivers/staging are loaded.
+ *  'K' - A Ksplice update has been loaded.
  *
  *	The string is overwritten by the next call to print_taint().
  */
-- 
1.6.3.1
