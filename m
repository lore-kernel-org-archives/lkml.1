Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbYAWRlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbYAWRlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbYAWRjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:39:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008AbYAWRjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:39:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ATZgve+YjZ5Wn+ldJoELueeOyLoizHuOg6Ld6Wf0ZjL/xTS8ljSMth+j2IfDqL3vDbsJxZWqaPGvjHAcXquuvpdQcjdyiqn49GIk5a7/WYft69Wx9OyaSYvJkK5vU2ZfX9DPK71OWXvGh4j9HiP6doC2KgxdaehB8bLIKw0Re3A=
Date: Wed, 23 Jan 2008 20:39:01 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/6] net: use KSYM_NAME_LEN
Message-ID: <20080123173901.GD12877@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use KSYM_NAME_LEN instead of numeric value

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/net/core/dev.c
===================================================================
--- linux-2.6.git.orig/net/core/dev.c	2008-01-21 19:35:33.000000000 +0300
+++ linux-2.6.git/net/core/dev.c	2008-01-23 19:22:17.000000000 +0300
@@ -2599,7 +2599,7 @@ static void ptype_seq_decode(struct seq_
 	unsigned long offset = 0, symsize;
 	const char *symname;
 	char *modname;
-	char namebuf[128];
+	char namebuf[KSYM_NAME_LEN];
 
 	symname = kallsyms_lookup((unsigned long)sym, &symsize, &offset,
 				  &modname, namebuf);
