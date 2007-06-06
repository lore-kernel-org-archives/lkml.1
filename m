Return-Path: <linux-kernel-owner+w=401wt.eu-S934018AbXFFBAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934018AbXFFBAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764985AbXFFBAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:00:35 -0400
Received: from waste.org ([66.93.16.53]:33687 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbXFFBAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:00:34 -0400
Date: Tue, 5 Jun 2007 20:00:13 -0500
From: Matt Mackall <mpm@selenic.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 4/6] lguest don't signal like crazy, use LHREQ_BREAK command
Message-ID: <20070606010012.GD11115@waste.org>
References: <1181055308.14054.36.camel@localhost.localdomain> <1181055396.14054.38.camel@localhost.localdomain> <1181055483.14054.40.camel@localhost.localdomain> <1181055606.14054.43.camel@localhost.localdomain> <20070605153455.GW11115@waste.org> <1181088466.14054.65.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181088466.14054.65.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 10:07:46AM +1000, Rusty Russell wrote:
> On Tue, 2007-06-05 at 10:34 -0500, Matt Mackall wrote:
> > On Wed, Jun 06, 2007 at 01:00:06AM +1000, Rusty Russell wrote:
> > > We currently use a "waker" process: a child of the launcher which
> > > selects() on the incoming file descriptors.  It sends a SIGUSR1 to the
> > > launcher whenever select() returns to kick the launcher out of the
> > > kernel.
> > 
> > If I break out of lguest with three ctrl-Cs, this leaves one of the
> > lguest processes running with /dev/lguest held open.
> 
> This patch, or the previous version I sent?  The previous one had this
> issue, so this one takes some care to kill the waker and I haven't seen
> it since:
> 
> 				/* Make sure waker is not blocked in BREAK */
> 				u32 args[] = { LHREQ_BREAK, 0 };
> 				close(waker_fd);
> 				write(fd, args, sizeof(args));
> 				exit(2);

Probably the one you sent earlier.

-- 
Mathematics is the supreme nostalgia of our time.
