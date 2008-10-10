Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbYJJJnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbYJJJnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYJJJnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:43:31 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:3029 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYJJJna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=U+hwrWsbKl8gkCst+11yGt8LNcDW6rMSUutyzmMe5ANR7rfdjDkZCxEa2H6AxZs8Nv
         spv06BM0TvZh0Zs1TWHKx2RiteRmF5Gq/Flc7WJtrpUYTLVgh2bGcqpqkCtU3sGAL80z
         M6c4tusslJ5TIzf9T8zL7irtBMFUKhdkFbPiY=
Date: Fri, 10 Oct 2008 10:43:03 +0100
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [Patch] kernel/kallsyms.c: fix double return's
Message-ID: <20081010094223.GA2925@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 6dd06c9fbe025f542bce4cdb91790c0f91962722 introduced double
returns in the function kallsyms_lookup(), it's weird.
The second one should be removed.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 38fc10a..5072cf1 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -260,7 +260,6 @@ const char *kallsyms_lookup(unsigned long addr,
 	/* see if it's in a module */
 	return module_address_lookup(addr, symbolsize, offset, modname,
 				     namebuf);
-	return NULL;
 }
 
 int lookup_symbol_name(unsigned long addr, char *symname)

