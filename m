Return-Path: <linux-kernel-owner+w=401wt.eu-S933907AbXFFAox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907AbXFFAox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 20:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759344AbXFFAoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 20:44:44 -0400
Received: from ozlabs.org ([203.10.76.45]:43307 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215AbXFFAon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 20:44:43 -0400
Subject: Re: [PATCH 4/6] lguest don't signal like crazy, use LHREQ_BREAK
	command
From: Rusty Russell <rusty@rustcorp.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070605153455.GW11115@waste.org>
References: <1181055308.14054.36.camel@localhost.localdomain>
	 <1181055396.14054.38.camel@localhost.localdomain>
	 <1181055483.14054.40.camel@localhost.localdomain>
	 <1181055606.14054.43.camel@localhost.localdomain>
	 <20070605153455.GW11115@waste.org>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 10:07:46 +1000
Message-Id: <1181088466.14054.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 10:34 -0500, Matt Mackall wrote:
> On Wed, Jun 06, 2007 at 01:00:06AM +1000, Rusty Russell wrote:
> > We currently use a "waker" process: a child of the launcher which
> > selects() on the incoming file descriptors.  It sends a SIGUSR1 to the
> > launcher whenever select() returns to kick the launcher out of the
> > kernel.
> 
> If I break out of lguest with three ctrl-Cs, this leaves one of the
> lguest processes running with /dev/lguest held open.

This patch, or the previous version I sent?  The previous one had this
issue, so this one takes some care to kill the waker and I haven't seen
it since:

				/* Make sure waker is not blocked in BREAK */
				u32 args[] = { LHREQ_BREAK, 0 };
				close(waker_fd);
				write(fd, args, sizeof(args));
				exit(2);

Thanks,
Rusty.



