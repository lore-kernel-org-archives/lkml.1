Return-Path: <linux-kernel-owner+w=401wt.eu-S1761516AbZBYVE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761516AbZBYVE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZBYVEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:04:16 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:64596 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbZBYVEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:04:15 -0500
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 16:04:15 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MbKkROh62SIg68vIZMu+7udkNFYVKMmuly5GwnJ/4PTEQzNUa17dXiEteXSQ0Ucp1S
         vsuXpCE98q0kIXcijI+in5M/nVvtLIOZSgxKSBcvgD3Ig6aiNRStRNSCN1tEf5fab4Bm
         qah6JkNYni2Kb0RwJ5VPZCmLGUeiWkxtLkSEQ=
Date: Wed, 25 Feb 2009 23:59:20 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC] introduce pr_cont macro
Message-ID: <20090225205920.GA22091@localhost>
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
same pr_... slogan. Thoughts? I hope I didn't
miss anything.

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
+        printk(KERN_CONT pr_fmt(fmt), ##__VA_ARGS__)
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(DEBUG)
