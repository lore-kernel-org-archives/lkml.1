Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZGJSaC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZGJSaC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:30:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZGJS3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:29:52 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:41739 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZGJS3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:29:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GDy4vp+hckeJil3RVD94iKQNukBtjW31nBcSVhGxKwRXHHnM0m0RJxkbaTmoZW6r7e
         +AIf6Y9JtMkvdnH4rq44R+ZXNz1sWvAk83YWOP/nGsT+UgmK5RChfLPrLDLbr4cVu4qv
         dJ2PlEHVMMVET/o66nUSre6QfeaM0vXu3oaGc=
Date: Fri, 10 Jul 2009 20:29:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Move the sleeping while atomic checks early in
	cond_resched()
Message-ID: <20090710182947.GB5271@nowhere>
References: <20090710161034.GB22049@elte.hu> <1247246098-5627-1-git-send-email-fweisbec@gmail.com> <1247247810.6042.5.camel@laptop> <20090710180801.GA5271@nowhere> <1247249622.6042.7.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247249622.6042.7.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 08:13:42PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-07-10 at 20:08 +0200, Frederic Weisbecker wrote:
> 
> > > Right, how about renaming these to _cond_resched_{lock,softirq}, and
> > > added a __might_sleep() definition for !DEBUG_SPINLOCK_SLEEP and add
> > > macro wrappers to sched.c for these two as well?
> > 
> > I did that first but thought that might_sleep() would fail in a spinlock
> > held or softirq context, right?
> 
> Ah, right.. maybe we can add a preempt_count_offset parameter to
> __might_sleep() such that it will compensate for the pending
> spin_unlock()/local_bh_enable().


Good idea, I'm trying that.

