Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbYCOIfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbYCOIfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 04:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbYCOIfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 04:35:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:4539 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbYCOIfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 04:35:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=qd+TyNK2M/8UreEq63m0kd/uF67lAXJEVYhYQ7bbc0olErcmHlejFsO/6nBQgSwcORvc3VTJcDlnPxtJr2pxXNbHExTlTd/nrVKuCtdrKdqNQaPy4eh4OGtBRJTX/9bbp1S82bkcoLSNId45mrn5PsHCXDZli8/jtQYC7YlrDGE=
Date: Sat, 15 Mar 2008 11:34:26 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: traps_32.c - use KSYM_NAME_LEN instead of numeric
	value
Message-ID: <20080315083426.GA8086@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's safer to use KSYM_NAME_LEN instead of numeric constant
because we could get buffer overrun someday if KSYM_NAME_LEN
would be changed to a bigger value.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

I've patched 64bit version but forgot about 32bit. So
lets fix it too.

Index: linux-2.6.git/arch/x86/kernel/traps_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/traps_32.c	2008-02-09 22:27:13.000000000 +0300
+++ linux-2.6.git/arch/x86/kernel/traps_32.c	2008-03-15 11:21:16.000000000 +0300
@@ -109,7 +109,7 @@ void printk_address(unsigned long addres
 	const char *symname;
 	char *modname;
 	char *delim = ":";
-	char namebuf[128];
+	char namebuf[KSYM_NAME_LEN];
 	char reliab[4] = "";
 
 	symname = kallsyms_lookup(address, &symsize, &offset,
