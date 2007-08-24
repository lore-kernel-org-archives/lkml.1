Return-Path: <linux-kernel-owner+w=401wt.eu-S1759358AbXHXPZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759358AbXHXPZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758231AbXHXPXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:23:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48443 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701AbXHXPXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:23:47 -0400
Date: Fri, 24 Aug 2007 21:06:40 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] Remove superfluous definition of __setup_null_param()
 macro.
In-Reply-To: <Pine.LNX.4.64.0708240608090.16678@localhost.localdomain>
Message-ID: <alpine.LFD.0.999.0708242100480.20322@enigma.security.iitk.ac.in>
References: <Pine.LNX.4.64.0708240608090.16678@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Aug 2007, Robert P. J. Day wrote:
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   since i apparently removed the final remaining reference to this
> macro in commit f4895925976977aaeda26ee2a603a99f17db500b (thanks,
> adrian), there seems to be little value in keeping this definition
> around.

How about ...


[PATCH] Remove superfluous definition of __setup_null_param() macro and broken (for MODULE) __setup_param()

From: Robert P. J. Day <rpjday@mindspring.com>

Remove superfluous definition of __setup_null_param() macro, as nobody
uses it anymore.

Also kill the #ifdef-MODULE-case (empty) definition for __setup_param.
It is only required for the !MODULE case, as __setup() is empty for
the MODULE case already. Also, no user outside init.h must use
__setup_null_param directly anyway (and nobody does), so it's not
something whose empty definition we necessarily need to make available
to rest of the kernel. Moreover, this MODULE case of __setup_param has
been broken for more than two years now -- as far back as git history
takes us. Let's get rid of it.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 include/linux/init.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 74b1f43..93b2ca5 100644
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
 
@@ -233,8 +230,6 @@ void __init parse_early_param(void);
 	{ return exitfn; }					\
 	void cleanup_module(void) __attribute__((alias(#exitfn)));
 
-#define __setup_param(str, unique_id, fn)	/* nothing */
-#define __setup_null_param(str, unique_id) 	/* nothing */
 #define __setup(str, func) 			/* nothing */
 #endif
 
