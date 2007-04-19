Return-Path: <linux-kernel-owner+w=401wt.eu-S1161390AbXDSJVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161390AbXDSJVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161404AbXDSJVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:21:24 -0400
Received: from styx.suse.cz ([82.119.242.94]:35713 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161390AbXDSJVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:21:17 -0400
Date: Thu, 19 Apr 2007 11:23:39 +0200
From: Jiri Bohac <jbohac@suse.cz>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] fix abs() macro to work with types wider than int
Message-ID: <20070419092339.GA13569@dwarf.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is there any reason to use an explicit int instead of a typeof in
the abs() macro? The current implementation will return bogus
results when used with longs.

How about changing the int to a typeof like this?:





Fix the abs() macro to work with wider types than int.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>

--- linux-2.6.21-rc5.orig/include/linux/kernel.h
+++ linux-2.6.21-rc5/include/linux/kernel.h
@@ -89,7 +89,7 @@ extern int cond_resched(void);
 #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
 
 #define abs(x) ({				\
-		int __x = (x);			\
+		typeof(x) __x = (x);			\
 		(__x < 0) ? -__x : __x;		\
 	})
 



-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

