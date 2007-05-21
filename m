Return-Path: <linux-kernel-owner+w=401wt.eu-S1760661AbXEUTSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661AbXEUTSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbXEUTRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:17:54 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:35663
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037AbXEUTRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:17:53 -0400
Date: Mon, 21 May 2007 12:17:21 -0700
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] lockdep: lock contention tracking
Message-ID: <20070521191721.GD4442@gnuppy.monkey.org>
References: <1179657026.5915.10.camel@lappy> <20070521060446.GA4593@gnuppy.monkey.org> <20070521060828.GB20277@elte.hu> <20070521064150.GC4442@gnuppy.monkey.org> <20070521075013.GA9419@elte.hu> <20070521091848.GB4593@gnuppy.monkey.org> <20070521093639.GA29025@elte.hu> <20070521095547.GA10697@infradead.org> <20070521105803.GA17096@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521105803.GA17096@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 12:58:03PM +0200, Ingo Molnar wrote:
> and nobody pushed strong enough to get it included. But ... Peter's 
> patch could perhaps be extended to cover similar stats as lockmeter, 
> ontop of the existing lockdep instrumentation. Peter, can you see any 
> particular roadblocks with that?

Definitely. Lockmeter isn't terribly Linux-ish from my examination of
that patch a while back. Doing it against lockdep is definitely the
right thing to do in that it unifies lock handling through initializer
keys that lockmeter doesn't, from my memory.

The spin time tracking can be put into the slow path of the spin, like
what peter has now, so that it has minimal impact against the uncontended
case. Updating the times would then be a trivial pointer dereference
plus add and hopefully won't have instrumentation side effects against
the rest of the locking behavior in the system.

bill

