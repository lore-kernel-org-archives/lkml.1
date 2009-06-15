Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbZFOHIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbZFOHIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 03:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZFOHIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 03:08:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:50928 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbZFOHId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 03:08:33 -0400
Date: Mon, 15 Jun 2009 00:08:22 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org
Subject: [PATCH] WARN(): add a \n to the message printk
Message-ID: <20090615000822.6e6bf282@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 14cc1a7592e46a8b57081f90d7d54ab274ab7610 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 15 Jun 2009 00:05:39 -0700
Subject: [PATCH] WARN(): add a \n to the message printk

many (most) users of WARN() don't have a \n at the end of their string;
as is understandable from the API usage point of view. But this means
that the backend needs to add this \n or the warning message
gets corrupted (as is seen by kerneloops.org).

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/panic.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 984b3ec..08ce451 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -355,8 +355,10 @@ static void warn_slowpath_common(const char *file, int line, void *caller, struc
 	if (board)
 		printk(KERN_WARNING "Hardware name: %s\n", board);
 
-	if (args)
+	if (args) {
 		vprintk(args->fmt, args->args);
+		printk("\n");
+	}
 
 	print_modules();
 	dump_stack();
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
