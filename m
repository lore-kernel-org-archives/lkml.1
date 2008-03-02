Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbYCBKHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbYCBKHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 05:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbYCBKGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 05:06:51 -0500
Received: from www.tglx.de ([62.245.132.106]:50054 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYCBKGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 05:06:51 -0500
Date: Sun, 2 Mar 2008 11:06:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Subject: Re: [patch 1/2] infrastructure to debug (dynamic) objects
In-Reply-To: <1204411377.6240.13.camel@lappy>
Message-ID: <alpine.LFD.1.00.0803021055180.11084@apollo.tec.linutronix.de>
References: <20080301100019.640027768@linutronix.de>  <20080301100325.593267564@linutronix.de>  <20080301025134.d9c74110.akpm@linux-foundation.org>  <alpine.LFD.1.00.0803011215490.11084@apollo.tec.linutronix.de> <1204411377.6240.13.camel@lappy>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Mar 2008, Peter Zijlstra wrote:
> On Sat, 2008-03-01 at 12:44 +0100, Thomas Gleixner wrote:
> > On Sat, 1 Mar 2008, Andrew Morton wrote:
> 
> > > > +
> > > > +#define ODEBUG_HASH_SIZE	4096
> > > 
> > > power-of-2 is said to be a very poor size for a hash table.
> > 
> > The hash is not a randomized hash as one would expect. It's purely
> > generated from the object address to simplify the lookup during the
> > free check. So the power of 2 size is a good thing :) /me adds
> > comment.
> 
> Power of two buckets work when used along with a golden ratio based hash
> map - as done by linux/hash.h.
> 
> Power of two hash maps otoh suck royally.

Well, using a real hash algorithm sucks royally if you need to do the
reverse check on *free(). With the direct object address to hash
bucket mapping we have usually only one bucket to look at, otherwise
we end up looking at multiple buckets and doing the list walk on each
of them. We have to decide which suckage is worse :)

Thanks,
	tglx

