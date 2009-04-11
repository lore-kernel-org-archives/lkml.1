Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZDKHx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZDKHx7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbZDKHxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:53:46 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:41628 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbZDKHxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:53:45 -0400
Date: Sat, 11 Apr 2009 09:55:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jike Song <albcamus@gmail.com>, David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MN10300: Move arch headers to arch dir
Message-ID: <20090411075549.GA30873@uranus.ravnborg.org>
References: <19057.1239370935@redhat.com> <20090410192529.GA25551@uranus.ravnborg.org> <df9815e70904102042r2cd2e3e3ue6159f348e4c192e@mail.gmail.com> <20090411054516.GA29493@uranus.ravnborg.org> <20090411064300.GT26366@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090411064300.GT26366@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 11, 2009 at 07:43:00AM +0100, Al Viro wrote:
> On Sat, Apr 11, 2009 at 07:45:16AM +0200, Sam Ravnborg wrote:
> > On Sat, Apr 11, 2009 at 11:42:01AM +0800, Jike Song wrote:
> > > On Sat, Apr 11, 2009 at 3:25 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> > > >
> > > > .gitignore is left in include/asm-mn10300.
> > > >
> > > > As the content of that file is obsoleted by your last patch it can safely be deleted.
> > > > Linus - can I ask you to do so?
> > > >
> > > >        Sam
> > > 
> > > off topic: there is also a .gitignore left in include/asm-arm.
> > But its there for a reason.
> > Arm generates mach-types.h and it should be ignored.
> > 
> > include/asm-arm is no longer a sensible place for these files,
> > but for now I have no better place for them so they will
> > stay there for a while.
> 
> How about a single directory for *all* generated headers?  Only linux/version.h
> has many places including it and even that can be dealt with for a moment with
> linux/version.h consisting of #include <gen/version.h>.  The rest doesn't
> need anything like that even for transition period - too few includes to care.

So you suggest: include/gen/

asm-offsets.h, mach-types.h and version.h is the ones with the highest count.

And version.h is an exported header which we cannot move in our exported
set of headers. Fortunately I have just checked in a patch so we can specify
an alternative destination when exporting so this should deal with version.h.

asm-offsets.h and mach-types.h require a small helper file as you suggest,
otherwise it would be a _huge_ patch.

We can later migrate more generated files to this location.
(autoconf.h, config/* etc).

	Sam

