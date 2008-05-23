Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbYEWTJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbYEWTJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 15:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbYEWTJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 15:09:12 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45465 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbYEWTJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 15:09:11 -0400
Date: Fri, 23 May 2008 21:09:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, peter.oberparleiter@de.ibm.com,
       linux-kernel@vger.kernel.org, ltp-coverage@lists.sourceforge.net,
       oberparleiter@googlemail.com
Subject: Re: [PATCH 6/7] kbuild: make source and include paths absolute
Message-ID: <20080523190950.GA32541@uranus.ravnborg.org>
References: <48313E08.8070904@de.ibm.com> <20080522201724.cf4bd471.akpm@linux-foundation.org> <20080523171840.GD28257@cs181133002.pp.htv.fi> <20080523111707.89df9f67.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080523111707.89df9f67.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 11:17:07AM -0700, Andrew Morton wrote:
> On Fri, 23 May 2008 20:18:40 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > On Thu, May 22, 2008 at 08:17:24PM -0700, Andrew Morton wrote:
> > > On Mon, 19 May 2008 10:44:56 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> > > 
> > > > From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> > > > 
> > > > Change all source and include paths to absolute form when
> > > > CONFIG_GCOV_PROFILE is enabled.
> > > > 
> > > > Example:
> > > > 
> > > >   gcc -Idir1 -c a.c -o a.o
> > > > 
> > > > will become
> > > > 
> > > >   gcc -I/path/to/dir1 -c /path/to/a.c -o a.o
> > > > 
> > > > Required by the gcov profiling infrastructure: when compiling with
> > > > option -fprofile-arcs, gcc stores file names inside object files.
> > > > Relative paths prevent the gcov tool from finding corresponding source
> > > > files.
> > > 
> > > I don't like this.  It converts the compiler error messages from
> > > relative paths to absolute paths which is rather obnoxious when
> > > all kernel developent is (or should be) base-directory-agnostic.
> > 
> > The compiler error messages are already absolute paths when using O=
> > (see e.g. all error messages sent by me in recent years).
> > 
> 
> Well I guess that's understandable with O=.
> 
> But I find it rather nasty.  (I guess it'd be less nasty if I were to
> get off my butt and work out how to teach rxvt that "/" is a word
> separator).
> 
> What do others think?

That the gcov tool has a bug if it insist on using absolute paths.
And thus we should fix gcov and not workaround it in the kernel.

	Sam
