Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYEDBh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYEDBh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 21:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYEDBhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 21:37:16 -0400
Received: from smtp.enter.net ([216.193.128.24]:1652 "EHLO smtp.enter.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbYEDBhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 21:37:14 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Strange linux-next build error
Date: Sat, 3 May 2008 21:37:07 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Sam Ravnborg <sam@ravnborg.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       linux-next@vger.kernel.org
References: <200805030121.39831.dhazelton@enter.net> <200805031825.50914.dhazelton@enter.net> <20080503224018.GB18344@elte.hu>
In-Reply-To: <20080503224018.GB18344@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805032137.09302.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 May 2008 18:40:18 Ingo Molnar wrote:
> * Daniel Hazelton <dhazelton@enter.net> wrote:
> > > Can you try to do a:
> > > make V=1 and post the output a few screen fulls before and until
> > > the bug triggers.
> > > They I will see if I can work out what is happening.
> > >
> > > Thanks,
> > > 	Sam
> >
> > I've been unable to trigger it with "make V=1 bzImage" - does the
> > verbosity change, somehow, the default number of makes that get run ?
> >
> > If it does, I could try adding -j2 or similar to see if that causes it
> > to trigger.
>
> try something like:
>
>    make -j2 V=1 bzImage >log.txt 2>&1
>
> and see whether the error shows up in log.txt. Console output caused by
> the increased verbosity (especially if it's a slower console like an
> xterm) can hide build races.
>
> 	Ingo

And this appears to have been a false alarm. For the tests I did a clean pull 
of the tree and started the build. When I kept *NOT* getting a build error on 
the clean tree I started checking permissions and, while the files that this 
error was happening for (and the containing directory) all had good 
permissions, the correct ownerand all that - so I didn't look deeper. On 
doing a deeper look it seems that there were some files and directories that 
belonged to "root" and had 0644 for permissions.

After doing "make mrproper" and the reconfiguration I reset the owner/group on 
the entire tree of files to be non-root and the build (at -j4) has finished 
without a problem.

Sorry about that.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
