Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbXA3IdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbXA3IdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 03:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXA3IdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 03:33:00 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48560 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbXA3Ic7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 03:32:59 -0500
Date: Tue, 30 Jan 2007 00:32:57 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Sunil Naidu" <akula2.shark@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-Id: <20070130003257.1745273c.akpm@osdl.org>
In-Reply-To: <8355959a0701300016k7c835fb3v31b4424edde3741c@mail.gmail.com>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	<8355959a0701300016k7c835fb3v31b4424edde3741c@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 13:46:54 +0530
"Sunil Naidu" <akula2.shark@gmail.com> wrote:

> On 1/30/07, Andrew Morton <akpm@osdl.org> wrote:
> >
> > - If you hit a bug in -mm and it is not obvious which patch caused it, it is
> >   most valuable if you can perform a bisection search to identify which patch
> >   introduced the bug.  Instructions for this process are at
> 
> I am hit with a compile error! Here is the info:-
> 
>   CC [M]  drivers/net/chelsio/cxgb2.o
>   CC [M]  drivers/net/chelsio/espi.o
>   CC [M]  drivers/net/chelsio/tp.o
>   CC [M]  drivers/net/chelsio/pm3393.o
>   CC [M]  drivers/net/chelsio/sge.o
> drivers/net/chelsio/sge.c: In function 't1_interrupt':
> drivers/net/chelsio/sge.c:1705: error: expected ')' before 'work_done'
> drivers/net/chelsio/sge.c:1722: error: expected expression before '}' token
> drivers/net/chelsio/sge.c:1697: warning: unused variable 'work_done'
> drivers/net/chelsio/sge.c:1722: warning: no return statement in
> function returning non-void
> make[3]: *** [drivers/net/chelsio/sge.o] Error 1
> make[2]: *** [drivers/net/chelsio] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

--- a/drivers/net/chelsio/sge.c~git-netdev-all-chelsio-fix
+++ a/drivers/net/chelsio/sge.c
@@ -1701,7 +1701,7 @@ irqreturn_t t1_interrupt(int irq, void *
 
 	writel(F_PL_INTR_SGE_DATA, adapter->regs + A_PL_CAUSE);
 
-	if (likely(responses_pending(adapter))
+	if (likely(responses_pending(adapter)))
 		work_done = process_responses(adapter, -1);
 	else
 		work_done = t1_slow_intr_handler(adapter);
_

