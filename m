Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0BWSjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 13:39:42 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40229 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab0BWSjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 13:39:41 -0500
X-Greylist: delayed 88473 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Feb 2010 13:39:40 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gHaARX/ZDolbfakLNJCTE46NC3mxJPZRUH4xIGxwx4CHgOTo4hUvfx0DE7DdQbBiK7
         lJBzTSkodV83Nlmt+Bab0n0RCX7fhb2ZrLLCXeVjItBpt4st5aLaWV7a3Y3dhuDdVXio
         yrG4fer5gKNmNckYvD/ayBEdMoN4DUZK8qu5U=
Date: Wed, 24 Feb 2010 00:11:04 +0530
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 04/10] ARM: ftrace: allow building without frame
 pointers
Message-ID: <20100223184104.GA6325@debian>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
 <1266090518-31120-5-git-send-email-rabin@rab.in>
 <20100222190516.GJ5055@nowhere>
 <1266931113.19540.5.camel@frodo>
 <20100223171112.GC5357@nowhere>
 <20100223175807.GB5836@debian>
 <1266948185.24271.6079.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266948185.24271.6079.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 01:03:05PM -0500, Steven Rostedt wrote:
> On Tue, 2010-02-23 at 23:28 +0530, Rabin Vincent wrote:
> > The easiest option to have a more obvious message than a linker error
> > would be to add something like this in entry-common.S:
> > 
> >   #if (__GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 4)) \
> > 	&& !defined(OLD_MCOUNT)
> >   #warning Ftrace on GCC < 4.4 requires frame pointers
> >   #endif
> > 
> > Messages like this are also present in other places in ARM (for example
> > arch/arm/kernel/unwind.c), so this wouldn't be this first.
> > 
> > Note that the above message would help in all cases except the one where
> > someone builds the kernel with !fp and GCC 4.4+, and then builds a
> > module with an older GCC.  That would still be only a linker error.
> 
> I was going to recommend the #if above. But shouldn't it be a #error
> instead of a #warning?

Yes, I'll make it a #error.

(I had it at #warning in case some one had a custom compiler that had
the new mcount patch backported, and chose to ignore the warning.  But
it's probably better to leave it at #error and see if someone actually
complains about it, rather than have someone miss the message with it as
a #warning.)

Rabin
