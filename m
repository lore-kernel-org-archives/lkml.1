Return-Path: <linux-kernel-owner+w=401wt.eu-S965870AbXJPVRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965870AbXJPVRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965436AbXJPVRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:17:45 -0400
Received: from smtp-out-43.synserver.de ([217.119.50.43]:1042 "HELO
	smtp-out-43.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S965408AbXJPVRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:17:45 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2007 17:17:44 EDT
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
Date: Tue, 16 Oct 2007 23:11:01 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL (updated)] kbuild updates
Message-ID: <20071016211101.GA4093@gentoox2.trippelsdorf.de>
References: <20071015205018.GA24467@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071015205018.GA24467@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 10:50:18PM +0200, Sam Ravnborg wrote:
> 
> The kbuild patches has been rebased on top of -linus after
> the x86 merge.
> The patch that caused ARCH to be unset has been withdrawn for
> now. It had additional issues and I need to do additional changes
> to get it included - in other words it will await next merge window.
> 
> The following patches does almost clear my patch queue. I have some
> fixes pending but need some more time to check them out.
> On top of this I have a few reports from -mm that needs attention too.
> So in other words I expect a smaller set of patches for -rc1 or -rc2
> as my time permits.
> 
> In addition to latest pull request this one includes:
> - rename of
> 	CFLAGS => KBUILD_CFLAGS
> 	AFLAGS => KBUILD_AFLAGS
> 	CPPFLAGS => KBUILD_CPPFLAGS
>     rationale behind this was two-fold:
>     1) Do not let the CFLAGS environment variable impact all builds
>     2) Allow one to specify addition gcc options on the commandline
>        as make CLFAGS=-Os ...
> - introducing ccflags-y, asflags-y and ldflags-y as the future
>   replacement of the EXTRA_* variants.
> 
> 
> The majority (line wise) is update of generated files.
> The rest is almost all one-liners so nothing controversial.
> The file with most lines changed is makefiles.txt!
> 

Bisecting shows that:

commit f77bf01425b11947eeb3b5b54685212c302741b8
	Author: Sam Ravnborg <sam@neptun.(none)>
 	Date:   Mon Oct 15 22:25:06 2007 +0200

    kbuild: introduce ccflags-y, asflags-y and ldflags-y

breaks booting with grub here. Grub stops with error 28: 
Selected item cannot fit into memory.

Reverting the commit fixes the problem.
-- 
Markus
