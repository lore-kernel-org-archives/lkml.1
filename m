Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbYG0Feo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbYG0Feo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 01:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYG0Feh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 01:34:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:43105 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbYG0Feg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 01:34:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=kMyWEJE1vZccKyvBbCOPaBFnF7f4VqhWr8Trx2VQeAc/DFfmP3Ira5A04A/A9nlcb/
         3uKQ8yAYZqHVyyRLFXwk5jis9s1zDBj1ydtn62cvYlDlq8oyVEQjEyw71oXlUTrTTEto
         Xk59UvZPZwVc24AzKa803kD18ZbTcgj9mGDdg=
Date: Sun, 27 Jul 2008 09:34:33 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix __ratelimit() re flags can't be static
Message-ID: <20080727053433.GA12605@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 lib/ratelimit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/ratelimit.c
+++ b/lib/ratelimit.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 
 static DEFINE_SPINLOCK(ratelimit_lock);
-static unsigned long flags;
 
 /*
  * __ratelimit - rate limiting
@@ -26,6 +25,8 @@ static unsigned long flags;
  */
 int __ratelimit(struct ratelimit_state *rs)
 {
+	unsigned long flags;
+
 	if (!rs->interval)
 		return 1;
 

