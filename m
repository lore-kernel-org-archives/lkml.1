Return-Path: <linux-kernel-owner+w=401wt.eu-S932577AbXFEP1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbXFEP1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763236AbXFEP11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:27:27 -0400
Received: from ozlabs.org ([203.10.76.45]:37492 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561AbXFEP10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:27:26 -0400
Subject: [PATCH 1/6] lguest example launcher fix
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 00:55:08 +1000
Message-Id: <1181055308.14054.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"struct option" arrays handed to getopt_long() are supposed to be
NULL-terminated.  (Another patch added an arg and it finally segv'd).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/lguest.c |    1 +
 1 file changed, 1 insertion(+)

===================================================================
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -930,6 +930,7 @@ static struct option opts[] = {
 	{ "tunnet", 1, NULL, 't' },
 	{ "block", 1, NULL, 'b' },
 	{ "initrd", 1, NULL, 'i' },
+	{ NULL },
 };
 static void usage(void)
 {


