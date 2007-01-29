Return-Path: <linux-kernel-owner+w=401wt.eu-S932829AbXA2XGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbXA2XGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbXA2XGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:06:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:44022 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbXA2XGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:06:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=GWnQNkdSvJy+FEFUWTok+PnOHDAlCntsR+8ucNbWOtJNYQ+IVI/uImE+0LhiMc+tPvex3OYlqgVzcCvvaH9hl7W9Ze5DW5LBWfwWc12dY1ZiXYqnMCqBrEIzpQw7hxFKGolQkk4N8qgpmx0kswS5Rv6mg3Z6pELcd22NWoZGdZU=
Date: Mon, 29 Jan 2007 23:05:52 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Tomasz Kvarsin <kvarsin@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       paulmck@in.ibm.com, dipankar@in.ibm.com
Subject: [-mm patch] rcu_trace build fix (was Re: 2.6.20-rc6-mm2 build failure)
Message-ID: <20070129230552.GB10257@slug>
References: <5157576d0701291231j17c5c73we8aa4419d22c01b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5157576d0701291231j17c5c73we8aa4419d22c01b9@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 11:31:08PM +0300, Tomasz Kvarsin wrote:
> I try to compile and got:
> 
>  CHK     include/linux/version.h
>  CHK     include/linux/utsrelease.h
>  CHK     include/linux/compile.h
>  CC      kernel/rcupreempt.o
> kernel/rcupreempt.c: In function 'rcupreempt_try_flip_state_name':
> kernel/rcupreempt.c:641: error: 'rcu_try_flip_state_names' undeclared
> (first use in this function)
> kernel/rcupreempt.c:641: error: (Each undeclared identifier is
> reported only once
> kernel/rcupreempt.c:641: error: for each function it appears in.)
> kernel/rcupreempt.c: In function 'rcupreempt_trace':
> kernel/rcupreempt.c:645: error: 'struct rcu_data' has no member named 'trace'
> kernel/rcupreempt.c:646: warning: control reaches end of non-void function
> kernel/rcupreempt.c: In function 'rcupreempt_try_flip_state_name':
> kernel/rcupreempt.c:642: warning: control reaches end of non-void function
> 
Hi,

It looks like a typo there, thanks for reporting. The attached patch
"s/RCU_TRACE/CONFIG_RCU_TRACE/" did the trick for me.

Btw, shouldn't the RCU_TRACE macro be defined to "do {} while(0)" in the
!CONFIG_RCU_TRACE case?

Regards,
Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index f8962a7..9b7d66b 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -619,7 +619,7 @@ void synchronize_kernel(void)
 	synchronize_rcu();
 }
 
-#ifdef RCU_TRACE
+#ifdef CONFIG_RCU_TRACE
 int *rcupreempt_flipctr(int cpu)
 {
 	return &per_cpu(rcu_flipctr, cpu)[0];
@@ -649,7 +649,7 @@ EXPORT_SYMBOL_GPL(rcupreempt_data_completed);
 EXPORT_SYMBOL_GPL(rcupreempt_flip_flag);
 EXPORT_SYMBOL_GPL(rcupreempt_mb_flag);
 EXPORT_SYMBOL_GPL(rcupreempt_try_flip_state_name);
-#endif /* #ifdef RCU_TRACE */
+#endif /* #ifdef CONFIG_RCU_TRACE */
 
 EXPORT_SYMBOL_GPL(call_rcu);
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
