Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbXJHHR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbXJHHR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 03:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753095AbXJHHRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 03:17:48 -0400
Received: from hu-out-0506.google.com ([72.14.214.228]:21238 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbXJHHRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 03:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=gumK3+MiLM7VzoPoawpSz08tSo1UJXj3zGNS34n63KlKardjKLKQHlceUF7KhOJdT0Xi4XR/ta7zGBouBRiFLbXNebxaO+eftcQPxZz+kevyJosdp+ZhZ52uIasWywLB37ypgjM5iaQyvcWCGWqQoLdHgEZoUIcEocnsqwaV10U=
Date: Mon, 8 Oct 2007 15:17:30 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: xiyou.wangcong@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de
Subject: Re: [PATCH] param_sysfs_builtin memchr argument fix
Message-ID: <20071008071730.GA2979@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thanks for comment.
fixed.

Regards
dave
-----

If memchr argument is longer than strlen(kp->name), there will be some
weird result.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
kernel/params.c |    8 +++++++-
1 file changed, 7 insertions(+), 1 deletion(-)

diff -upr linux/kernel/params.c linux.new/kernel/params.c
--- linux/kernel/params.c	2007-10-08 14:30:06.000000000 +0800
+++ linux.new/kernel/params.c	2007-10-08 15:13:04.000000000 +0800
@@ -592,11 +592,17 @@ static void __init param_sysfs_builtin(v
 
 	for (i=0; i < __stop___param - __start___param; i++) {
 		char *dot;
+		size_t kplen;
 
 		kp = &__start___param[i];
+		kplen = strlen(kp->name);
 
 		/* We do not handle args without periods. */
-		dot = memchr(kp->name, '.', MAX_KBUILD_MODNAME);
+		if (kplen > MAX_KBUILD_MODNAME) {
+			DEBUGP("kernel parameter %s is too long\n", kp->name);
+			continue;
+		}
+		dot = memchr(kp->name, '.', kplen);
 		if (!dot) {
 			DEBUGP("couldn't find period in %s\n", kp->name);
 			continue;
