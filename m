Return-Path: <linux-kernel-owner+w=401wt.eu-S934064AbYDWBga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbYDWBga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758827AbYDWBgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:36:20 -0400
Received: from ns2.suse.de ([195.135.220.15]:57543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758590AbYDWBgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:36:18 -0400
Date: Wed, 23 Apr 2008 03:36:17 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       peterz@infradead.org, sam@ravnborg.org
Subject: Re: [PATCH 2/11] x86: convert to generic helpers for IPI function calls
Message-ID: <20080423013617.GB23192@wotan.suse.de>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-3-git-send-email-jens.axboe@oracle.com> <alpine.LFD.1.10.0804221157220.2779@woody.linux-foundation.org> <20080422191213.GA6370@elte.hu> <alpine.LFD.1.10.0804221218410.2779@woody.linux-foundation.org> <20080422192601.GB12588@elte.hu> <alpine.LFD.1.10.0804221244350.2779@woody.linux-foundation.org> <20080423011153.GB17572@wotan.suse.de> <alpine.LFD.1.10.0804221817050.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804221817050.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 06:22:17PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 23 Apr 2008, Nick Piggin wrote:
> > 
> > The "too expensive to check the shared queue" is one aspect of it. The
> > shared queue need not have events *for us* (at least, unless Jens has
> > changed the implementation a bit) but it can still have events that we
> > would need to check through.
> > 
> > I don't think deadlock is a problem (any more than with multiple vectors).
> 
> I'm happy with it either way, but as pointed out by Ralf, for the MIPS 
> version of the patch there aren't even other vectors available.
 
Yep.

> So sharing the vector is going to be a requirement on other architectures, 
> maybe we should look at whether we can make it generic and peform well 
> regardless?

I don't think it will perform terribly _poorly_ by sharing the vector.
If you have a look at how serialised the old code is...

If there is a noticable slowdown anywhere, we could I suppose create a
2nd variant for small numbers of CPUs, or shared vector case, but I'd
say the existing code should be fine I think.
