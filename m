Return-Path: <linux-kernel-owner+w=401wt.eu-S934983AbXJPVYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934983AbXJPVYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761564AbXJPVYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:24:25 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62019 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbXJPVYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:24:24 -0400
Date: Tue, 16 Oct 2007 14:23:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL (updated)] kbuild updates
Message-Id: <20071016142336.f9129f40.randy.dunlap@oracle.com>
In-Reply-To: <20071016211101.GA4093@gentoox2.trippelsdorf.de>
References: <20071015205018.GA24467@uranus.ravnborg.org>
	<20071016211101.GA4093@gentoox2.trippelsdorf.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 23:11:01 +0200 Markus Trippelsdorf wrote:

> On Mon, Oct 15, 2007 at 10:50:18PM +0200, Sam Ravnborg wrote:
> > 
> > The kbuild patches has been rebased on top of -linus after
> > the x86 merge.
> > The patch that caused ARCH to be unset has been withdrawn for
> > now. It had additional issues and I need to do additional changes
> > to get it included - in other words it will await next merge window.
> > 
> > The following patches does almost clear my patch queue. I have some
> > fixes pending but need some more time to check them out.
> > On top of this I have a few reports from -mm that needs attention too.
> > So in other words I expect a smaller set of patches for -rc1 or -rc2
> > as my time permits.
> > 
> > In addition to latest pull request this one includes:
> > - rename of
> > 	CFLAGS => KBUILD_CFLAGS
> > 	AFLAGS => KBUILD_AFLAGS
> > 	CPPFLAGS => KBUILD_CPPFLAGS
> >     rationale behind this was two-fold:
> >     1) Do not let the CFLAGS environment variable impact all builds
> >     2) Allow one to specify addition gcc options on the commandline
> >        as make CLFAGS=-Os ...
> > - introducing ccflags-y, asflags-y and ldflags-y as the future
> >   replacement of the EXTRA_* variants.
> > 
> > 
> > The majority (line wise) is update of generated files.
> > The rest is almost all one-liners so nothing controversial.
> > The file with most lines changed is makefiles.txt!
> > 
> 
> Bisecting shows that:
> 
> commit f77bf01425b11947eeb3b5b54685212c302741b8
> 	Author: Sam Ravnborg <sam@neptun.(none)>
>  	Date:   Mon Oct 15 22:25:06 2007 +0200
> 
>     kbuild: introduce ccflags-y, asflags-y and ldflags-y
> 
> breaks booting with grub here. Grub stops with error 28: 
> Selected item cannot fit into memory.
> 
> Reverting the commit fixes the problem.

Wow.  I had a similar issue with lilo, but I had no idea
what may have caused it.  Thanks.


Fatal: Kernel /boot/kernel-2.6.23-git10 is too big
ERROR:  Failed to run lilo.


---
~Randy
