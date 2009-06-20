Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZFTWYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZFTWYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 18:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZFTWYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 18:24:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60091 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbZFTWYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 18:24:06 -0400
Date: Sat, 20 Jun 2009 18:24:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] function-graph: disable when both x86_32 and optimize
 for size are configured
In-Reply-To: <20090620162513.GD32377@elte.hu>
Message-ID: <alpine.DEB.2.00.0906201822320.20813@gandalf.stny.rr.com>
References: <20090618224409.916725341@goodmis.org> <20090618225248.476090968@goodmis.org> <20090620162513.GD32377@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 20 Jun 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index 4a13e5a..1eac852 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -121,6 +121,7 @@ config FUNCTION_GRAPH_TRACER
> >  	bool "Kernel Function Graph Tracer"
> >  	depends on HAVE_FUNCTION_GRAPH_TRACER
> >  	depends on FUNCTION_TRACER
> > +	depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE
> >  	default y
> 
> Hm, nice fix, but this is a quite nasty constraint - distros like to 
> enable CC_OPTIMIZE_FOR_SIZE as it neatly trims the kernel's size by 
> about 30%.
> 
> Just in case you have not checked yet: is there no way to turn off 
> the specific gcc optimization that causes this? Or is it -Os itself 
> that does this optimization?

It seems to me that -Os causes it for i386. I did a make V=1 to capture 
how the files in question were being compiled, and tried various disabling 
of flags. -Os was the only one to make a difference. :-(

-- Steve

