Return-Path: <linux-kernel-owner+w=401wt.eu-S1762127AbZJJVS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762127AbZJJVS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 17:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762079AbZJJVS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 17:18:56 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:54225 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762055AbZJJVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 17:18:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AbHyWJSaEzNcD4qLhMeIx/IfMYsmOJ54KLMHQyupLKxg7rCEHndk2sLYt4YPGf1JSw
         NSnq+LEZnS5cNNqmupEgSmgetvkaPbuTDzd3sJuZw/abfrIoYTDDcXqMdmwwHyg5rnLB
         CNnazS4vJI2kt1d37mgUv4KzduequdffAiI8s=
Date: Sat, 10 Oct 2009 23:18:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH RFC] BKL not necessary in cpuid_open
Message-ID: <20091010211812.GG5150@nowhere>
References: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain> <20091007201338.GE5903@nowhere> <alpine.LFD.2.00.0910072259230.9428@localhost.localdomain> <alpine.LFD.2.00.0910072356050.15183@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910072356050.15183@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 11:58:20PM +0200, John Kacur wrote:
> 
> 
> On Wed, 7 Oct 2009, Thomas Gleixner wrote:
> 
> > On Wed, 7 Oct 2009, Frederic Weisbecker wrote:
> > > Hmm, I'm discovering that in tip:rt/kill-the-bkl
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commitdiff;h=55968ede164ae523692f00717f50cd926f1382a0
> > > 
> > > Looks like we have overlaped.
> > > 
> > > Thomas it would be nice to post these patches on LKML (or I missed
> > > them?) and may be to merge them into tip:master, so that they are
> > > visible and then we lower the risk of any duplicate works in this area.
> > 
> > Now guess why I mentioned this branch sevaral times at the rt summit
> > last week. It's even documented in Jonathans excellent meeting
> > minutes on lwn.net :)
> > 
> 
> Well, the overlap is unfortunate but I did do a git diff with 
> tip/core/kill-the-BKL BEFORE I posted.
> 
> not sure what the difference is between
> tip/kill-the-BKL
> and 
> tip/core/kill-the-BKL
> btw


Ah yeah, may be you've made a confusion.

tip/kill-bkl = tip/core/bkl = a branch created by Ingo inside which the
bkl has been turned into a regular mutex. This branch was helpful to find
the points where the bkl was acquired recursively, and how it
gained bad dependencies once turned into a regular sleeping lock because
it makes it analyzable by lockdep.

We did some work on this tree (various bkl pushdown and removals, also
the removal in reiserfs started there).
But this tree is not active currently, although it could still be (and its
key piece makes it useful to debug the bkl).

But currently, the tree that gathers the work in this area is rt/kill-the-bkl

Although it's possible Thomas might choose another name if it's scheduled
for .33 ?


 
> Also
> git describe 55968ede164ae523692f00717f50cd926f1382a0
> v2.6.31-rc6-4-g55968ed
> 
> Not sure what to make of that either, since my patch was against the 
> latest linus updated this morning.
> 
> Frederic: what was your method to discover that patch from Thomas?


I looked at the rt/kill-the-bkl in my local git :)

