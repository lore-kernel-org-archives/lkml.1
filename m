Return-Path: <linux-kernel-owner+w=401wt.eu-S933300AbXCJI3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbXCJI3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933296AbXCJI3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:29:49 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51049
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933227AbXCJI3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:29:45 -0500
Date: Sat, 10 Mar 2007 00:29:44 -0800 (PST)
Message-Id: <20070310.002944.115909724.davem@davemloft.net>
To: wli@holomorphy.com
Cc: mathieu.desnoyers@polymtl.ca, akpm@linux-foundation.org, mbligh@google.com,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] Fix sparc TIF_USEDFPU flag atomicity
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070310082646.GC2994@holomorphy.com>
References: <20070310081743.GC23144@Krystal>
	<20070310082646.GC2994@holomorphy.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Lee Irwin III <wli@holomorphy.com>
Date: Sat, 10 Mar 2007 00:26:46 -0800

> On Sat, Mar 10, 2007 at 03:17:43AM -0500, Mathieu Desnoyers wrote:
> > @@ -348,7 +348,7 @@ void exit_thread(void)
> >  #ifndef CONFIG_SMP
> >  	if(last_task_used_math == current) {
> >  #else
> > -	if(current_thread_info()->flags & _TIF_USEDFPU) {
> > +	if(test_ti_thread_flag(current_thread_info(), TIF_USEDFPU)) {
> >  #endif
> >  		/* Keep process from leaving FPU in a bogon state. */
> >  		put_psr(get_psr() | PSR_EF);
> 
> Oh dear. Could we bit a bit more idiomatic here? For instance,
> something like:

Ok I pulled the sparc32 patch back out until there is some
consensus here :)

