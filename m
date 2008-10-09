Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbYJIQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYJIQES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 12:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbYJIQEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 12:04:08 -0400
Received: from lazybastard.de ([212.112.238.170]:54432 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbYJIQEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 12:04:07 -0400
Date: Thu, 9 Oct 2008 18:03:47 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC - size tool for kernel build system
Message-ID: <20081009160347.GB17179@logfs.org>
References: <48EBD268.50208@am.sony.com> <20081009152151.GB17013@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081009152151.GB17013@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 October 2008 18:21:51 +0300, Adrian Bunk wrote:
> 
> The building blocks that would be useful are IMHO:
> - a make target that generates a report for one kernel
>   (like the checkstack or export_report targets)
> - a script that compares two such reports and outputs the
>   size differences
> 
> That's also easy to do, and if that's what's wanted I can send a patch 
> that does it.
> 
> Everything else is IMHO overdesigned.

Please do.

> The real problem is that dumping some scripts into the kernel sources 
> or publishing some data on a webpage doesn't make people use them.
> 
> Like if you run "make checkstack" on the kernel today you can see that 
> drivers allocate arrays > 1 kB on the stack despite checkstack being 
> available...

Funny you should mention that.  Yesterday I noticed that make checkstack
had been ported to five more architectures since my last look at the
code.  It doesn't seem likely that those ports were required by some
pointy-haired boss for feature-completeness.  Someone must actually be
using it.

The very beauty of make checkstack is that you don't even notice whether
it is being used or not.  You point to some drivers that apparently
didn't use it, which is fine.  But how many drivers _did_ use it?  How
many problems have been solved before the patches have ever been posted
for review?  Noone knows.  And that is a good thing.  We want the
problems to get solved and not become visible in the first place.

Bloatwatch imo has the design flaw that it is a central tool hosted on
some server somewhere and only documents the damage once it has
happened.  It would be much better if every developer could run
something simple locally and clean up the mess before anyone else
notices.

I partially agree with you in one point.  It would be even better if
checkstack, bloatcheck, etc. were run automatically on every kernel
compile and developers were forced to look at any problems that come up.
But that would increase compile time, which is bad.  So there needs to
be an off button as well, as there is for sparse - where off is the
default.

Jörn

-- 
But this is not to say that the main benefit of Linux and other GPL
software is lower-cost. Control is the main benefit--cost is secondary.
-- Bruce Perens
