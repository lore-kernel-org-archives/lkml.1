Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZI0RdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZI0RdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 13:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZI0RdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 13:33:15 -0400
Received: from fifo99.com ([67.223.236.141]:47380 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbZI0RdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 13:33:14 -0400
Subject: Re: [PATCH] WARN_ONCE(): use bool for boolean flag
From: Daniel Walker <dwalker@fifo99.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>
In-Reply-To: <4ABF9FB4.6040608@cesarb.net>
References: <1254059590-31690-1-git-send-email-cesarb@cesarb.net>
	 <1254060189.20648.462.camel@desktop>  <4ABF8B30.5050801@cesarb.net>
	 <1254070336.20648.518.camel@desktop>  <4ABF9FB4.6040608@cesarb.net>
Content-Type: text/plain
Date: Sun, 27 Sep 2009 10:32:40 -0700
Message-Id: <1254072760.20648.524.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-27 at 14:24 -0300, Cesar Eduardo Barros wrote:

> I took a quick look, and all uses seem to be directly in a boolean 
> context (within an if()), so there would be no problem. Besides, the 
> unlikely() all these macros end with does a double negation, meaning 
> even if it is an int, it will be either 0 or 1 (but I am not sure I am 
> reading these macros right - it seems CONFIG_TRACE_BRANCH_PROFILING 
> turns all unlikely() into likely()).
> 
> In fact, I was expecting no change at all, since gcc should be able to 
> see it is being treated as a boolean (perhaps I am trusting gcc too 
> much). And to make matters even more confusing, my own test changing all 
> __ret_warn_once to bool and dropping the !! caused an _increase_ of 598 
> bytes (x86-64 defconfig).
> 
>     text    data     bss     dec     hex filename
> 8100553 1207148  991988 10299689         9d2929 vmlinux.warnret.before
> 8101119 1207180  991988 10300287         9d2b7f vmlinux.warnret.after
> 
> (And yes, data increased again.)

Did you have the CONFIG_TRACE_BRANCH_PROFILING option enabled for the
test above?

If this was just your regular base line config , then that is odd .. I
also would think worse case would be no size reduction .. I did my
compile test on x86-32 btw..

Daniel

Daniel

