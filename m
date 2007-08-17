Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbXHQMbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbXHQMbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 08:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbXHQMa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 08:30:59 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3828 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbXHQMa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 08:30:58 -0400
Subject: Re: RFHelp:  Splitting MAINTAINERS into maintainers/*
	and	Makefile/Kconfig support
From: Joe Perches <joe@perches.com>
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46C53F3F.5060108@redhat.com>
References: <1187297496.5906.113.camel@localhost>
	 <46C53F3F.5060108@redhat.com>
Content-Type: text/plain
Date: Fri, 17 Aug 2007 05:30:41 -0700
Message-Id: <1187353841.822.60.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-17 at 02:25 -0400, Chris Snook wrote:
> The whole point of MAINTAINERS is to have one central repository for this 
> information, instead of scattering it throughout the various source files.  If 
> that file is getting too unwieldy (and I don't think it is) then I could 
> understand splitting it up hierarchically, for example having a 
> drivers/net/MAINTAINERS that listed the info for all the net drivers.

The individual MAINTAINERS files eliminates what Linus
described as their "hotness".
No shared updates by multiple parties.

> What you're suggesting is a less efficient equivalent to putting the info 
> directly into the source files.

I believe that wrong.

Maintainer patterns frequently look like:

F:	arch/i386/kernel/cpu/cpufreq/
F:	drivers/cpufreq/
F:	include/linux/cpufreq.h

If in source, this would currently require 21 + 12 + 1 
modifications instead of 1.

> If that approach was enough to make people 
> happy, we wouldn't have MAINTAINERS to begin with.

I think the insertion of maintainers into source
itself is wrong.  It's freeform, error prone and
requires significant modifications to source files
as maintainers come and go.
 
> Perhaps with a little automation it could be revived,

Which is the help I'm looking for.

Can someone please help here on ideas or implementation
adding a makefile target for MAINTAINERS from files
in a specific subdirectory?

> though I think that adding a path pattern 
> removes the need, while keeping it easier to parse by scripts.
> I appreciate the effort to make MAINTAINERS more useful,
> but please don't add  another 600 files to the tree.

In the distributed form, you'll still end up with
~400 new files spread all over the tree.

Either way, you'll have hundreds of files.

$ grep "^F:" MAINTAINERS |  sed -e "s/[A-Za-z0-9\_\*\.\-]*$//" | sort |
uniq | wc -l
415

Centralized as maintainers/* or distributed as ../../../Maintainers

Pick one, I don't much care, but I'm still looking for
Makefile/KConfig help reassembling it into a single
MAINTAINERS block similar to the current form.

Help?

cheers, Joe

