Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYKYSAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYKYSAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 13:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYKYR76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:59:58 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:34978 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752028AbYKYR75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:59:57 -0500
Date: Tue, 25 Nov 2008 12:59:37 -0500
From: Theodore Tso <tytso@mit.edu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>, ltt-dev@lists.casi.polymtl.ca,
       Zhaolei <zhaolei@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LTTng kernel integration roadmap, update
Message-ID: <20081125175937.GA525@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Sam Ravnborg <sam@ravnborg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Christoph Hellwig <hch@infradead.org>,
	ltt-dev@lists.casi.polymtl.ca, Zhaolei <zhaolei@cn.fujitsu.com>,
	Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org> <20081124122055.GA18626@Krystal> <alpine.DEB.1.10.0811241156030.20122@gandalf.stny.rr.com> <20081125055744.c3377164.akpm@linux-foundation.org> <20081125154011.GA4883@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081125154011.GA4883@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 04:40:11PM +0100, Sam Ravnborg wrote:
> > 
> > Mathieu, if you're feeling keen I'd suggest that you just type `mkdir
> > -p userspace/lttng' and build your userspace tools in there.
> 
> Maybe this can help...
> 
> 	Sam
> 
> diff --git a/usr/lttng/Makefile b/usr/lttng/Makefile
> new file mode 100644
> index 0000000..8667998
> --- /dev/null
> +++ b/usr/lttng/Makefile
> @@ -0,0 +1,4 @@
> +
> +always := ltt
> +
> +hostprogs-y := ltt

hostprogs are intended to be run on the host during the compilation
process, right?  What we really want is something that allows us to
build userspace programs intended for use on the target, not the host,
since they aren't going to be used when the system is compiled, but
when the system is run.

This also brings up some interesting questions such as where would we
install these userspace programs (which could be kernel version
specific), and how they would be packaged.  In some ways, this is
similar to a previously unsolved and unresolved problem with firmware
which people want to move out of the kernel (but not for legal
reasons, they swear, but because most of the time the firmware stays
constant from version to version --- except when it doesn't).

The same arguments that are used for ejecting firmware from the kernel
and not wanting to ship multiple versions of binaries with the kernel
can also be used for these sorts of low-level userspace binaries which
may be kernel version specific which are often duplicated.

I happen to disagree with those who wish to eject firmware from the
kernel sources (because I don't believe it is for technology reasons,
but because they want to be able to chant, "Unclean, Unclean!" as they
type rm -rf firmware).  And I think we should need to be able to
distribute userspace binaries in the kernel, because of the versioning
issues and so we can guarantee that we get upgraded userspace tools
into the hands of users when they upgrade to the latest kernel.org
kernel and need certian updated userspace utilities where we want the
stable kernel interface to be located at a kernel-shipped userspace
program or library.   

However, we do need to understand that there are issues around
building target userspace progs, where they get installed, changing
the kernel packaging systems to include them in the kernel image
package, creating some convention so users can set the appropriate
search path in their shells depending on which kernel they have
booted, etc.  These are not insurmountable problems.  But they are
ones that we need to solve first.

					- Ted
