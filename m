Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbYBCMhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbYBCMhr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 07:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762826AbYBCMhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 07:37:32 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:58288 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765028AbYBCMhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 07:37:31 -0500
Date: Sun, 3 Feb 2008 13:37:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-git7: section mismatches woes
Message-ID: <20080203123734.GH20810@uranus.ravnborg.org>
References: <200801301950.44403.rjw@sisk.pl> <200802022347.29916.rjw@sisk.pl> <20080203101245.GB20810@uranus.ravnborg.org> <200802031332.01827.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802031332.01827.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > suspend to RAM working?
> > I dunno - never used it I'm afraid. And do not know how to do it either.
> 
> # echo mem > /sys/power/state
> 
> (better do it after a fresh boot for the first time in case it fails).

Will try later - thanks.

> > The way to approach it is straightforward but boring.
> > 
> > You can add:
> > ccflags-y += -fno-inline-functions-called-once
> > to the Makefiles where you think this can have caused troubles until
> > you find the problematic directory.
> > kbuild will pick up that gcc options changed and rebuild
> > all relevant files.
> > 
> > When the problematic directory is located then
> > remove the ccflags-y assignment and do it file-by-file
> > using the CFLAGS_xxx.o syntax:
> > 
> > CFLAGS_file.o := -fno-inline-functions-called-once
> 
> Do I have to pass any special options to "make"?

When you do it this way by tweaking the Makefiles - no.
And you do not have to delete .o files manually to get them
rebuild.

	Sam
