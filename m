Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZHHAbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZHHAbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 20:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbZHHAbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 20:31:35 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:39600 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZHHAbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 20:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CeIianY0bMiRbHRXwq6pOGbJDwa0bHTtHXB9AyzFO3EXddPlykB13AIi/kCKvju8ss
         JGA4YqDsf1h0oqTX0q4TIkOlDvKYVWE825Dvd1lSjC+7LHT751g1ndOHAsE1tcsd0Prr
         J23FwAXhDgez1Wl1aYQ9LPvsYjvrpELlwAhsI=
Date: Sat, 8 Aug 2009 02:31:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Mark Gross <mgross@linux.intel.com>
Subject: Re: [PATCH 1/2] pm_qos: remove BKL
Message-ID: <20090808003130.GJ4999@nowhere>
References: <20090806135841.46682114@bike.lwn.net> <20090806135953.7706e57d@bike.lwn.net> <20090807055412.GB9182@nowhere> <20090807090818.064d3647@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807090818.064d3647@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 07, 2009 at 09:08:18AM -0600, Jonathan Corbet wrote:
> On Fri, 7 Aug 2009 07:54:13 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > May be the last doubt could be the blocking_notifier_call_chain() call from
> > update_target(). Not sure if these notifier handlers can expect to be called
> > concurrently?
> 
> I will confess that I hadn't audited the notifiers.  One could easily
> argue that concurrent calls to update_target() are entirely possible
> with the current code (only one of the callers had BKL protection),
> but, then, I'm supposed to be trying to make things better.
> 
> The notifier call chain is already protected against concurrent
> modification, but, since an rwsem is used, concurrent calls to the
> notifiers themselves are possible.  A quick grep shows that, in 2.6.31-rc5,
> there is exactly one notifier registered.  It's in
> drivers/cpuidle/cpuidle.c; here's the whole thing:
> 
> static void smp_callback(void *v)
> {
> 	/* we already woke the CPU up, nothing more to do */
> }
> 
> After deep meditation on possible race condition scenarios, I am force to
> conclude that this particular notifier already has all of the protection it
> needs, and that any extra locking is likely to be superfluous.


Hehe :-)

So it would be nice to apply these patches.
Ingo?

 
> Thanks for looking at the patch,
> 
> jon

