Return-Path: <linux-kernel-owner+w=401wt.eu-S933396AbZC0Akx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396AbZC0Akx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933373AbZC0Ako
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:40:44 -0400
Received: from outbound-mail-139.bluehost.com ([67.222.39.29]:52445 "HELO
	outbound-mail-139.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933372AbZC0Akn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:40:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pBLzUde4TFEwxsB7BYH5ZyGx4GGLAEyQcAx5+dOexESEnWi4otNlC/Qvu7hafoQY7B+bNQeoC8vXM2mwp+5hSrHt+Mu6vHV7Rg13gRg2wp/JbJJhFIswtFilYIn0t7AF;
Date: Thu, 26 Mar 2009 17:40:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326174037.4948f020@hobbes>
In-Reply-To: <20090326235936.GK6239@mit.edu>
References: <20090325185824.GO32307@mit.edu>
	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	<20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326113705.GV32307@mit.edu>
	<20090326140312.GB14822@elte.hu>
	<20090326152815.GB6239@mit.edu>
	<20090326230240.GA18808@elte.hu>
	<20090326235936.GK6239@mit.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 19:59:36 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Fri, Mar 27, 2009 at 12:02:40AM +0100, Ingo Molnar wrote:
> > This isnt me streaming gigs of data in and out of the system 
> > dirtying 90% of all RAM. This is a trivial workload barely 
> > scratching the RAM and CPU capabilities of the system.
> 
> Have you tried with maxcpus set to say, 2?  My guess is you won't see
> the problems in that case.  So I'm not sure saying "barely scratching
> the CPU capabilities of the system" is completely fair.  I can
> probably get be able to get temporary access to a 16 CPU system, but
> that's not the kind of system that I normally get to use for my kernel
> devleopment.

Nope, I saw this with my dual CPU machine too (before I upgraded to
quad core)... Just doing kernel builds and/or icecream and/or VMware.
It didn't take much.  I have 8G of memory now but I used to have less
(3G iirc) and saw it then too.

> My normal development is not all that different from yours (make
> -j<numcpus*2>) and I do edit and save files while the compile is
> going.  I use emacs, but it calls fsync() when saving files, just like
> vim does.  The big difference is that for me, numcpus is normally 2.
> And my machine has 4 gigs of memory, not 12 gigs.  So I don't see
> these problems.  I agree that what you have isn't an "oddball
> workload"; as far as whether it is an "oddball system", it is
> certainly a system I would lust after.  And I acknowledge the world is
> a bit different from when Linus declared that 99% of the world was 1
> or 2 CPU's.  I suspect the percentage of machines with 16 CPU's is
> still somewhat small, though.

I'm surprised you haven't seen this then... Maybe your journal is
bigger?  Or some other config difference...

-- 
Jesse Barnes, Intel Open Source Technology Center
