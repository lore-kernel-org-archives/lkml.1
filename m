Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbYHVUzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbYHVUzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYHVUzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:55:14 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:38114 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbYHVUzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:55:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WzJY+IvrW6Jqyyn51Q++P9QcAG3Vk7P5OriFRt/MP7lAWTQM9SG0m0clVzA/JCDi7w
         L9CFpPskScXd9VvePrMkvC+JznOU08ZHIXVrJRdK1v3JQhHMwnAcoEITJHE2STk84QBI
         P7kHlQYwdPcT0he3vxiPaVDvJsPiz4+O247xQ=
Date: Fri, 22 Aug 2008 22:54:19 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ftraced and suspend to ram
Message-ID: <20080822205415.GA5452@joi>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <20080822072343.GA24173@atrey.karlin.mff.cuni.cz> <20080822103533.GA5425@joi> <200808221839.35640.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808221839.35640.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 06:39:34PM +0200, Rafael J. Wysocki wrote:
> On Friday, 22 of August 2008, Marcin Slusarz wrote:
> > On Fri, Aug 22, 2008 at 09:23:43AM +0200, Pavel Machek wrote:
> > > > 
> > > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > 
> > > > > > > The code in question is the ftraced() function in 
> > > > > > > kernel/trace/ftrace.c
> > > > > > 
> > > > > > Thanks, I'll have a look in a while.
> > > > > 
> > > > > Can you try the appended patch, please?
> > > > 
> > > > makes sense - i've applied it to tip/tracing/urgent, see the tidied up 
> > > > commit below.
> > > > 
> > > > It should be no big issue not being able to trace across suspend+resume 
> > > > - and that restriction will go away with Steve's build-time based mcount 
> > > > patching mechanism in v2.6.28.
> > > 
> > > Patch looks okay to me, but I'm not sure if another issue is not
> > > hiding under it. Did anyone actually test ftrace + suspend after
> > > applying this?
> > 
> > I just tested this patch - it didn't help ;(
> > 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index 49f4c3f..02e41b2 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -27,6 +27,7 @@
> >  #include <linux/ctype.h>
> >  #include <linux/hash.h>
> >  #include <linux/list.h>
> > +#include <linux/freezer.h>
> >  
> >  #include <asm/ftrace.h>
> 
> This is needed to fix compilation, sorry for the omission.
> 
> Still, did you test ftrace + suspend with the original patch and your fix
> applied and if you did, then what happend?

Suspend works fine. When I hit power button I see some informations from
video card (nvidia), then screen goes black and monitor says "no signal"
and then I see the same informations from video card, then BIOS and GRUB.
When everything works fine, X comes back after first infos from video card.

Marcin
