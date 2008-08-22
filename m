Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbYHVKgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbYHVKgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 06:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbYHVKge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 06:36:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:49835 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbYHVKgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 06:36:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ag16ej0hshK1JgCkFXSUG41TVWM1n+78eTHgQaNk33omXd2VkqFkD8Uu41/P7MxKhP
         1K5d2mskjAXDtdOeRyH6TjptsaB9EYB7U9BjUC+HZnmPFMUiqjLvVz86UDhvvggt5rSR
         x4Qj3nF/Bu6YC5d4d+ruJ2ev1BlA1ADU4r6RY=
Date: Fri, 22 Aug 2008 12:35:39 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ftraced and suspend to ram
Message-ID: <20080822103533.GA5425@joi>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <alpine.DEB.1.10.0808211423410.678@gandalf.stny.rr.com> <200808212037.11775.rjw@sisk.pl> <200808212159.37678.rjw@sisk.pl> <20080822044649.GA356@elte.hu> <20080822072343.GA24173@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080822072343.GA24173@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2008 at 09:23:43AM +0200, Pavel Machek wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > > > The code in question is the ftraced() function in 
> > > > > kernel/trace/ftrace.c
> > > > 
> > > > Thanks, I'll have a look in a while.
> > > 
> > > Can you try the appended patch, please?
> > 
> > makes sense - i've applied it to tip/tracing/urgent, see the tidied up 
> > commit below.
> > 
> > It should be no big issue not being able to trace across suspend+resume 
> > - and that restriction will go away with Steve's build-time based mcount 
> > patching mechanism in v2.6.28.
> 
> Patch looks okay to me, but I'm not sure if another issue is not
> hiding under it. Did anyone actually test ftrace + suspend after
> applying this?

I just tested this patch - it didn't help ;(

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 49f4c3f..02e41b2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -27,6 +27,7 @@
 #include <linux/ctype.h>
 #include <linux/hash.h>
 #include <linux/list.h>
+#include <linux/freezer.h>
 
 #include <asm/ftrace.h>
 
