Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbXI3MF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbXI3MF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 08:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXI3MFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 08:05:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:48129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629AbXI3MFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 08:05:49 -0400
Date: Sun, 30 Sep 2007 14:05:45 +0200
From: Nick Piggin <npiggin@suse.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Paul McKenney <paulmck@us.ibm.com>, David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [rfc][patch] i386: remove comment about barriers
Message-ID: <20070930120545.GB7697@wotan.suse.de>
References: <20070929132848.GA21169@wotan.suse.de> <Pine.LNX.4.64.0709291200590.13643@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709291200590.13643@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 12:12:52PM -0700, Davide Libenzi wrote:
> On Sat, 29 Sep 2007, Nick Piggin wrote:
> 
> > [ This is true for x86's sfence/lfence, but raises a question about Linux's
> > memory barriers. Does anybody expect that a sequence of smp_wmb and smp_rmb
> > would ever provide a full smp_mb barrier? I've always assumed no, but I
> > don't know if it is actually documented? ]
> 
> No, that can't be. rmb+wmb can't be considered a full mb.

Oh I realise it doesn't work with current implementations (powerpc at
least also would be broken I think). And I've always assumed no... But
the question was just whether the Linux memory model requires it (it
theoretically could require that smp_rmb is sequentially ordered WRT
smp_wmb without actually sequentially ordering stores around itself).



> There was a 
> recent discussion about this in the thread originated by peterz scalable 
> rw_mutex patches.

OK, good to hear it has been discussed. I didn't see anything explicit
in the documentation about it.  A lot of the literature often says that
"barrier instructions" have a sequential ordering, so it could be useful
to explicitly say this isn't the case for Linux for rmb vs wmb.

