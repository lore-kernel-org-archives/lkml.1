Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbZISW3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbZISW3I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 18:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZISW3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 18:29:07 -0400
Received: from [195.41.46.236] ([195.41.46.236]:38865 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbZISW3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 18:29:06 -0400
Date: Sun, 20 Sep 2009 00:29:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ro Achterberg <ro@greyhat.nl>
Cc: linux-kernel@vger.kernel.org, spender@grsecurity.net
Subject: Re: bug/section mismatches on 2.6.31 ?
Message-ID: <20090919222902.GA26425@merkur.ravnborg.org>
References: <20090919215914.147CC4015D@smtp10.online.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919215914.147CC4015D@smtp10.online.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 19, 2009 at 11:59:13PM +0200, Ro Achterberg wrote:
> Hi all,
> 
> I'm experiencing a kernel build problem that I haven't seen before. For some reason, make is telling me 'WARNING: modpost: Found 3133 section mismatch(es).' during the process. The currently running kernel is a 2.6.29.4-grsec (custom configuration) on CentOS 5.2. Gcc's version is 4.1.2, which I left untouched. I've built kernels on this machine before, without problems.
> 
> I've attached a log of 'make CONFIG_DEBUG_SECTION_MISMATCH=y' which is not making a lot of sense to me, which is why I'm forwarding it to you, hoping that you might be able to tell me what I'm doing wrong here or whether perhaps I've encountered a bug here. Any insights would be greatly appreciated!
> 

Hi Ro.

I assume your are trying to build latest kernel.
I could not reproduce it here - and from your logs
nothing told me what is wrong at your side.

What I see is that modpost complain about a reference from .data to .text.
And this is ok - so there is nothing to complain about.

I see a lot of warnings in your build that I do not see here.
You seem to have more warnings enabled than is standard - but I do not see
how this happens in your case.
kbuild should ignore CFLAGS settings from the environment but maybe we fail
to ignore CFLAGS for host programs??

First step is to isolate where to look for the issue.
Try to run modpost manually:

    modpost arch/x86/crypto/aes-x86_64.o


Does it generate the same warnigns as seen in your log - I hope so.

Then try to run modpost on the same .o file on another machine
that does not exhibit this issue.
Does the other machine now suddenly show the warnings?

In other words is this due to something in the .o file
or due to something with modpost?
I assume the latter.

You could also try to debug modpost a little - try to insert
a breakpoint around check_section_mismatch() and see when we trigger
a mismatch.
That may give you a clue too.
[You need to adjust HOSTCFLAGS so -O2 is replaced with -g to do this.
See top-level Makefile.

	Sam
