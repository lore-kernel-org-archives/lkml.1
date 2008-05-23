Return-Path: <linux-kernel-owner+w=401wt.eu-S1758480AbYEWSTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758480AbYEWSTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYEWSTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:19:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753047AbYEWST3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:19:29 -0400
Date: Fri, 23 May 2008 11:17:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: peter.oberparleiter@de.ibm.com, linux-kernel@vger.kernel.org,
       ltp-coverage@lists.sourceforge.net, sam@ravnborg.org,
       oberparleiter@googlemail.com
Subject: Re: [PATCH 6/7] kbuild: make source and include paths absolute
Message-Id: <20080523111707.89df9f67.akpm@linux-foundation.org>
In-Reply-To: <20080523171840.GD28257@cs181133002.pp.htv.fi>
References: <48313E08.8070904@de.ibm.com>
	<20080522201724.cf4bd471.akpm@linux-foundation.org>
	<20080523171840.GD28257@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 20:18:40 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> On Thu, May 22, 2008 at 08:17:24PM -0700, Andrew Morton wrote:
> > On Mon, 19 May 2008 10:44:56 +0200 Peter Oberparleiter <peter.oberparleiter@de.ibm.com> wrote:
> > 
> > > From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> > > 
> > > Change all source and include paths to absolute form when
> > > CONFIG_GCOV_PROFILE is enabled.
> > > 
> > > Example:
> > > 
> > >   gcc -Idir1 -c a.c -o a.o
> > > 
> > > will become
> > > 
> > >   gcc -I/path/to/dir1 -c /path/to/a.c -o a.o
> > > 
> > > Required by the gcov profiling infrastructure: when compiling with
> > > option -fprofile-arcs, gcc stores file names inside object files.
> > > Relative paths prevent the gcov tool from finding corresponding source
> > > files.
> > 
> > I don't like this.  It converts the compiler error messages from
> > relative paths to absolute paths which is rather obnoxious when
> > all kernel developent is (or should be) base-directory-agnostic.
> 
> The compiler error messages are already absolute paths when using O=
> (see e.g. all error messages sent by me in recent years).
> 

Well I guess that's understandable with O=.

But I find it rather nasty.  (I guess it'd be less nasty if I were to
get off my butt and work out how to teach rxvt that "/" is a word
separator).

What do others think?
