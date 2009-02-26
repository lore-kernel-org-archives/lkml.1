Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZBZN7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZBZN7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZBZN7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:59:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46101 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZBZN7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:59:14 -0500
Date: Thu, 26 Feb 2009 08:59:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] make CALLER_ADDRx overwriteable
In-Reply-To: <20090226134544.GA7110@pengutronix.de>
Message-ID: <alpine.DEB.2.00.0902260857510.26792@gandalf.stny.rr.com>
References: <1235600169-26912-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090226050806.GB25589@goodmis.org> <20090226134544.GA7110@pengutronix.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 26 Feb 2009, Uwe Kleine-K?nig wrote:

> Hi Steven,
> 
> On Thu, Feb 26, 2009 at 12:08:06AM -0500, Steven Rostedt wrote:
> > On Wed, Feb 25, 2009 at 11:16:09PM +0100, Uwe Kleine-K??nig wrote:
> > > The current definition of CALLER_ADDRx isn't suitable for all platforms.
> > > E.g. for ARM __builtin_return_address(N) doesn't work for N > 0 and
> > > AFAIK for powerpc there are no frame pointers needed to have a working
> > > __builtin_return_address.  This patch allows defining the CALLER_ADDRx
> > > macros in <asm/ftrace.h> and let these take precedence.
> > > 
> > > Signed-off-by: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
> >
> > Ah, but unfortunately this will break other archs :-(
> > 
> > They may not use FTRACE, but they do include the ftrace header (the
> > ftrace.h header can be used for other types of tracing, not just
> > function tracing).
> Then that's from generic files, because the archs that don't have
> <asm/ftrace.h> don't include <linus/ftrace.h> under arch/.
> 
> > A better solution would be to move the CALLER_ADDER0 out of the
> > ftrace.h header completely. Not sure where though. Have a caller.h ?
> > And then we can have ftrace.h include caller.h. A asm/caller.h can be
> > used to override the default.
> Well, but then every arch needs this file.  I don't see an advantage
> here.  So I'd favour to add an empty ftrace.h for the relevant archs.

The safest bet is then to add an empty ftrace.h to all archs.

Anyone else have any issues with that?

If this happens, you can put the asm/ftrace.h at the top and remove the
asm/ftrace.h referenced in the DYNAMIC_FTRACE ifdef.

-- Steve

