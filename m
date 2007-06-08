Return-Path: <linux-kernel-owner+w=401wt.eu-S938735AbXFHK0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938735AbXFHK0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 06:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937676AbXFHK0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 06:26:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936305AbXFHK0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 06:26:07 -0400
Date: Fri, 8 Jun 2007 06:25:47 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Daniel Colascione <danc@merrillpress.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: O_CLOEXEC: An alternate proposal
Message-ID: <20070608102547.GU4033@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <45111.76.180.38.217.1181288832.squirrel@vpn.merrillpress.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45111.76.180.38.217.1181288832.squirrel@vpn.merrillpress.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 03:47:12AM -0400, Daniel Colascione wrote:
> Hey, this is my first post to linux-kernel, so please be kind. :-)
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
>   event_fd = super_duper_event_polling_mechanism_fd();
>   kernel_default_fd_flags(old_fd_flags);

It is not a win, what if a signal comes in between the two
kernel_default_fd_flags syscalls?  open and other functions
are async signal safe and programs will be certainly upset
if suddenly the syscalls in the signal handler start to behave
differently depending on which exact code the async signal
has interrupted.

	Jakub
