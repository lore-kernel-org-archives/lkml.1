Return-Path: <linux-kernel-owner+w=401wt.eu-S968341AbXFHJVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968341AbXFHJVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 05:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967186AbXFHJVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 05:21:13 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:58076 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967182AbXFHJVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 05:21:12 -0400
Date: Fri, 8 Jun 2007 11:19:09 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: "Daniel Colascione" <danc@merrillpress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: O_CLOEXEC: An alternate proposal
Message-Id: <20070608111909.d338f974.dada1@cosmosbay.com>
In-Reply-To: <45111.76.180.38.217.1181288832.squirrel@vpn.merrillpress.com>
References: <45111.76.180.38.217.1181288832.squirrel@vpn.merrillpress.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 03:47:12 -0400 (EDT)
"Daniel Colascione" <danc@merrillpress.com> wrote:

> Hey, this is my first post to linux-kernel, so please be kind. :-)

Welcome Daniel

> 
> Linus Torvalds wrote on May 31:
> > I'm with Uli on this one. "Stateful" stuff is bad. It's essentially
> > impossible to handle with libraries - either the library would have to
> > explciitly always turn the state the way _it_ needs it, or the library
> > will do the wrogn thing.
> 
> I agree that stateful stuff is generally not very elegant,
> but I think it's a win here -- we wouldn't have to create any
> new APIs except for the state-setting stuff.
> 
> The state just has to be thread-local.
> 
> If it's thread-local, a library, say, glibc,
> can use code like this:
> 
>   /* Internal library function */
>   old_fd_flags = kernel_default_fd_flags(FD_CLOEXEC | FD_RANDFD);

<race here if a signal handler runs some user code messing with a thread-local fd_flags >

>   event_fd = super_duper_event_polling_mechanism_fd();
>   kernel_default_fd_flags(old_fd_flags);
> 
> I think that's a lot cleaner than augmenting every
> present and future fd-creating syscall to take some kind
> of flags parameter and adding some kind of funny dup().
> 

Thats funny, you probably missed Linus syscall_indirect() proposal, 
which is basically doing the thing but with one syscall (so no races, and faster)

http://marc.info/?l=linux-kernel&m=118124716616552&w=2

