Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbZB0Tpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbZB0Tpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 14:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759215AbZB0Tp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 14:45:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:39145 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbZB0Tp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 14:45:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Tq0+LjVCBAUupg9clFVq0YmtNVjfrxcFGMqoV120zaw5k1gRZymtC4mxHMmpFuo4Jc
         3ihQ5jESi8oHYvHr4gjm/eOQyhy6aQ8pFf8Yz3yOdG5Ie0q15O4CU1lkfBeMg49DMP/p
         L+QcrtVvpV8AvVOPduNj9wfRZPJjRpp7FMVq8=
Date: Fri, 27 Feb 2009 22:45:50 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] introduce pr_cont macro v2
Message-ID: <20090227194550.GC7882@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We cover all log-levels by pr_... macros except
KERN_CONT one. Add it for convenience.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

I think start printing with some pr_... macro
and continue with printk(KERN_CONT ...) look
not that clear -- better to continue with
same pr_... slogan.

It's written in same form as other (same aimed) macros have,
ie 'fmt' and ##__VA_ARGS__ saved.

 include/linux/kernel.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.git/include/linux/kernel.h
===================================================================
--- linux-2.6.git.orig/include/linux/kernel.h
+++ linux-2.6.git/include/linux/kernel.h
@@ -370,6 +370,8 @@ static inline char *pack_hex_byte(char *
         printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_cont(fmt, ...) \
+	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
