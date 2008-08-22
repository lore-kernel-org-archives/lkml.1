Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYHVQgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYHVQgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYHVQgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:36:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45099 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbYHVQgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:36:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: ftraced and suspend to ram
Date: Fri, 22 Aug 2008 18:39:34 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <20080822072343.GA24173@atrey.karlin.mff.cuni.cz> <20080822103533.GA5425@joi>
In-Reply-To: <20080822103533.GA5425@joi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221839.35640.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of August 2008, Marcin Slusarz wrote:
> On Fri, Aug 22, 2008 at 09:23:43AM +0200, Pavel Machek wrote:
> > > 
> > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > 
> > > > > > The code in question is the ftraced() function in 
> > > > > > kernel/trace/ftrace.c
> > > > > 
> > > > > Thanks, I'll have a look in a while.
> > > > 
> > > > Can you try the appended patch, please?
> > > 
> > > makes sense - i've applied it to tip/tracing/urgent, see the tidied up 
> > > commit below.
> > > 
> > > It should be no big issue not being able to trace across suspend+resume 
> > > - and that restriction will go away with Steve's build-time based mcount 
> > > patching mechanism in v2.6.28.
> > 
> > Patch looks okay to me, but I'm not sure if another issue is not
> > hiding under it. Did anyone actually test ftrace + suspend after
> > applying this?
> 
> I just tested this patch - it didn't help ;(
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 49f4c3f..02e41b2 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -27,6 +27,7 @@
>  #include <linux/ctype.h>
>  #include <linux/hash.h>
>  #include <linux/list.h>
> +#include <linux/freezer.h>
>  
>  #include <asm/ftrace.h>

This is needed to fix compilation, sorry for the omission.

Still, did you test ftrace + suspend with the original patch and your fix
applied and if you did, then what happend?

Rafael
