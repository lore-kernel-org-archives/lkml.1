Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbZDPCb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbZDPCb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 22:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZDPCbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 22:31:17 -0400
Received: from thunk.org ([69.25.196.29]:52005 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZDPCbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 22:31:16 -0400
Date: Wed, 15 Apr 2009 22:31:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090416023103.GI21586@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Jones <davej@redhat.com>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <200904152014.11717.rusty@rustcorp.com.au> <alpine.LFD.2.00.0904150822020.4132@localhost.localdomain> <200904161057.07108.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904161057.07108.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 10:57:05AM +0930, Rusty Russell wrote:
> Ingo wants them.  Example:
> 
> 	lguest: don't expect linear addresses in gdt pvops
> 
> 	Impact: fix guest crash 'lguest: bad read address 0x4800000 len 256'
> 
> What's more important in the subject line?  That it fixes a crash, or what it
> does?

Well, consider that 2 or 3 months later, when we're trying to find a
potential commit (say, because we're trying to find a potential fix
that needs to be forward ported to a distro kernel, or some such), the
initial summary line is what is going to be visible in gitk or via
"git log --oneline" (or "git log --pretty=oneline --abbrev-commit" for
older git versions).

So when I try to create git log messages, I try to make the first line
useful for folks who might be sorting through potentially thousands of
patches via gitk or git log --oneline.  So I might do something like

lguest: fix crash caused by expecting linear address in gdt pvops

and then making sure the body of the message goes into detail about
the oops message so that someone who is searching "git log" might find
the commit.  I also try to include relevant bugzilla numbers (for
distro's as well as the kernel bugzilla system).[1]

I think it was you who once quoted Will Strunk, "Always write with
deep sympathy for the reader"?  This definitely applies to git commit
messages, both the initial one-line summary as well as the body.

[1] I tend to use "Addresses-Debian-bug: #12345" in e2fsprogs git
repository, but the convention in the kernel commit logs seems to be
to use the URL to the bugzilla entry.  Since it's stuff that's
intended to be grep'ed, I put it at the end of the commit body, just
before the Signed-off-by: messages.

						- Ted

P.S.  One thing wihch I'd like to suggest is for folks to use "fix
lock ordering" instead of "fix lockdep warning".  I've been guilty of
using "lockdep warning" mmyself, and I've realized that when searching
to see if a reported hang might have been fixed, the brain has a
tendency to skip over a summary line that says "warning"; and a commit
that fixes a lockdep warning is more serious, than say, for example,
fixing some whining warning message from gcc.
