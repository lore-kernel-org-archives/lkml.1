Return-Path: <linux-kernel-owner+w=401wt.eu-S1759748AbXETWYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748AbXETWYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 18:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756930AbXETWX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 18:23:58 -0400
Received: from aun.it.uu.se ([130.238.12.36]:45298 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbXETWX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 18:23:57 -0400
Date: Mon, 21 May 2007 00:21:20 +0200 (MEST)
Message-Id: <200705202221.l4KMLKvI002716@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: ak@suse.de, folkert@vanheusden.com
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Cc: dada1@cosmosbay.com, jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, riel@redhat.com, righiandr@users.sourceforge.net,
       shemminger@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 23:20:36 +0200, Folkert van Heusden wrote:
> > > +	switch(sig) {
> > > +	case SIGQUIT: 
> > > +	case SIGILL: 
> > > +	case SIGTRAP:
> > > +	case SIGABRT: 
> > > +	case SIGBUS: 
> > > +	case SIGFPE:
> > > +	case SIGSEGV: 
> > > +	case SIGXCPU: 
> > > +	case SIGXFSZ:
> > > +	case SIGSYS: 
> > > +	case SIGSTKFLT:
> > 
> > Unconditional? That's definitely a very bad idea. If anything only unhandled
> > signals should be printed this way because some programs use them internally. 
> 
> Use these signals internally? Afaik these are fatal, stopping the
> process. So using them internally would be a little tricky.

Tricky for Joe Programmer, perhaps.

I've been personally involved with writing SIGFPE-handling code
in a major telco application framework, for several different
CPU architectures and operating systems.

SIGSEGV is used by some garbage collectors, some JITs, and I believe
also some software distributed shared memory implementations.

I've heard of at least one Lisp implementation that used SIGBUS
instead of dynamic type checks in some operations (e.g. to catch
CAR of a non-CONS).

Handled signals should not be logged.
