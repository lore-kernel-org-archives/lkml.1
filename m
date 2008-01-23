Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbYAWRk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbYAWRk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757911AbYAWRjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:39:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38285 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbYAWRjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:39:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ZMcaeFSP/kPVn2qNwvvoytJ+nOKVhXnnjnp6QtjWDkZKGfBY4uu8QNYGvH6FFJ+0wzaLAU90j4kW9YjPI8imy7E8NzGgFWJHbl2CaJ94pxzdNDjAyO0BfbL9NknSlhGpHna3Rw5q/+5NTOBl1odWqBVL4Z3D0cHpHs6CWbflRyI=
Date: Wed, 23 Jan 2008 20:38:43 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/6] x86: use KSYM_NAME_LEN
Message-ID: <20080123173843.GB12877@cvg>
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

Index: linux-2.6.git/arch/x86/kernel/traps_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/traps_64.c	2008-01-23 19:18:27.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/traps_64.c	2008-01-23 19:19:05.000000000 +0300
@@ -105,7 +105,7 @@ void printk_address(unsigned long addres
 	const char *symname;
 	char *modname;
 	char *delim = ":";
-	char namebuf[128];
+	char namebuf[KSYM_NAME_LEN];
 
 	symname = kallsyms_lookup(address, &symsize, &offset,
 					&modname, namebuf);
