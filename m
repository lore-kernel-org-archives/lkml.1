Return-Path: <linux-kernel-owner+w=401wt.eu-S1763255AbXEKUhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763255AbXEKUhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759541AbXEKUhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:37:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759588AbXEKUhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:37:22 -0400
Date: Fri, 11 May 2007 13:36:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jan Kratochvil <honza@jikos.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] PIE randomization
Message-Id: <20070511133651.63f8a14d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz>
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
	<20070511125629.3df919cf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007 22:18:16 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Fri, 11 May 2007, Andrew Morton wrote:
> 
> > >    I sent this patch 5 days ago, nobody replied. So I am giving it 
> > > second attempt. Andrew, is it possible to test this in -mm branch? 
> > > Original mail follows:
> > >     this is something like reaction to this thread: 
> > > http://lkml.org/lkml/2007/1/6/124. I hope I was able to separate the 
> > > PIE randomization part correctly.
> > I don't know what to do with this.  The changelog doesn't tell me what PIE
> > randomization _is_, nor why the kernel would want to do it. "Randomizing 
> > -pie compiled binaries" sounds fairly undesirable, actually ;)
> 
> I think it's precisely what we want to do in case the randomize_va_space 
> is set to 1, don't we? (I haven't yet gone throught the patch though, so I 
> am not sure whether this is the case).

erm, I was being funny.  If you randomize a binary it won't run any more. 
cp /dev/random /bin/login.  Oh well.

My point is, we're not being told what is being randomized here.  Is it the
virtual starting address of the main executable mmap?  Of the shared
libraries also?  Is it the stack location?  What?

I could reverse-engineer that info from the patch, I guess, but I'd prefer
to go in the opposite direction: you tell us what the patch is trying to
do, then we look at it and see if we agree that it is in fact doing that.

> We already have stack randomization and mmap() base randomization but 
> executable base randomization (which is of course only feasible for -pie 
> executables) and brk() randomization still seem to be missing to make it 
> complete.


