Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYCJG3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYCJG3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 02:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYCJG2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 02:28:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:38480 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbYCJG2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 02:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=hGmvNoo10crX4PxWvo0rreCkCK7v+u+0tmfRpHT+Pjuey/W4fzwSDgRHS75jdIhjVHIqEHq5adoHtVtmslrphXRYaSArf2qavnr/dNXASNz75PxtEPHOxaBYRElnUlDsgQ7qqxlxK0u98aUVuAOY930jd7hCxSlqwxINWdQP0MI=
Date: Mon, 10 Mar 2008 14:34:37 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com
Subject: [PATCH] [2/3] add WARN_ON_SECS macro
Message-ID: <20080310063437.GB6745@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add WARN_ON_SECS macro for some serious case which need repeat the
warnings, but with some ratelimit.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
include/asm-generic/bug.h |    8 ++++++++
1 file changed, 8 insertions(+)

diff -upr linux/include/asm-generic/bug.h linux.new/include/asm-generic/bug.h
--- linux/include/asm-generic/bug.h	2008-03-10 13:27:03.000000000 +0800
+++ linux.new/include/asm-generic/bug.h	2008-03-10 13:27:14.000000000 +0800
@@ -3,6 +3,7 @@
 
 #include <linux/compiler.h>
 
+
 #ifdef CONFIG_BUG
 
 #ifdef CONFIG_GENERIC_BUG
@@ -75,6 +76,13 @@ extern void warn_on_slowpath(const char 
 	unlikely(__ret_warn_once);				\
 })
 
+#define WARN_ON_SECS(condition, secs) ({			\
+	int __ret_warn_on = !!(condition);			\
+	if (unlikely(__ret_warn_on))				\
+		if (__ratelimit(secs * HZ, 1))			\
+			WARN_ON(condition);			\
+})
+
 #ifdef CONFIG_SMP
 # define WARN_ON_SMP(x)			WARN_ON(x)
 #else
