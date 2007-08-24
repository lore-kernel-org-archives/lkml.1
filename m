Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbXHXKYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbXHXKYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbXHXKYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:24:11 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59762 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXHXKYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:24:09 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 24 Aug 2007 06:14:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove superfluous definition of __setup_null_param() macro.
Message-ID: <Pine.LNX.4.64.0708240608090.16678@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  since i apparently removed the final remaining reference to this
macro in commit f4895925976977aaeda26ee2a603a99f17db500b (thanks,
adrian), there seems to be little value in keeping this definition
around.

$ grep -rw __setup_null_param *
include/linux/init.h:#define __setup_null_param(str, unique_id)  \
include/linux/init.h:#define __setup_null_param(str, unique_id)  /* nothing */
$


diff --git a/include/linux/init.h b/include/linux/init.h
index 74b1f43..2e4d3e0 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -165,9 +165,6 @@ struct obs_kernel_param {
 		__attribute__((aligned((sizeof(long)))))	\
 		= { __setup_str_##unique_id, fn, early }

-#define __setup_null_param(str, unique_id)			\
-	__setup_param(str, unique_id, NULL, 0)
-
 #define __setup(str, fn)					\
 	__setup_param(str, fn, fn, 0)

@@ -234,7 +231,6 @@ void __init parse_early_param(void);
 	void cleanup_module(void) __attribute__((alias(#exitfn)));

 #define __setup_param(str, unique_id, fn)	/* nothing */
-#define __setup_null_param(str, unique_id) 	/* nothing */
 #define __setup(str, func) 			/* nothing */
 #endif



 --
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
