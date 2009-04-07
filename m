Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbZDGFYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbZDGFYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbZDGFYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:24:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:12903 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZDGFYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=U0ByxUKLTTE6WyH+jJa2gSFMtZEzbtEyge+wsE3o6pdoMqO0Mq6EYZTWU4cARwMeVk
         71aTdJ5hLm5+LpUoLiDCB5v8/ZVbJAQ5Ao7t6oopkQ8e4l1Czi4C1+zvXCkyux+aPMQa
         ZRU4Vy9h5l5Hg2L6lwZFsofnb4H9U60ULbCqo=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Trenton D. Adams'" <trenton.d.adams@gmail.com>
Cc: "'Chris Mason'" <chris.mason@oracle.com>, "'Theodore Tso'" <tytso@mit.edu>,
       "'Jens Axboe'" <jens.axboe@oracle.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>  <20090406151054.GD5178@kernel.dk>  <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>  <20090406183157.GD7376@mit.edu>  <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>  <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>  <1239076379.17426.23.camel@think.oraclecorp.com>  <9b1675090904062113r2bd2b209hea1061cc54a0b9c0@mail.gmail.com>  <alpine.LFD.2.00.0904062120560.4010@localhost.localdomain> <9b1675090904062148k7081be9bs26b5852d71a0a45c@mail.gmail.com> <alpine.LFD.2.00.0904062156180.4010@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904062156180.4010@localhost.localdomain>
Subject: RE: [PATCH 0/8][RFC] IO latency/throughput fixes
Date: Mon, 6 Apr 2009 22:23:31 -0700
Message-ID: <006f01c9b741$00c70510$02550f30$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acm3Po5M4qfoe24fTje4bWI/KGVbNwAATisw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The (small) set of people that rely on "ordered" understand 
the problem, as long as they are aware of the change (no, I 
don't think reading through all changelogs from their old 
kernel to the new one is a realistic option).

So a config option should be good enough to get them to notice
the change (I assume a missing default will force them to 
choose an option), and therefore explicitly add the -o ordered 
option to their scripts.

On the other hand a run-time tunable has no real point.

> -----Original Message-----
> From: Linus Torvalds [mailto:torvalds@linux-foundation.org]
> Sent: Monday, April 06, 2009 10:02 PM
> To: Trenton D. Adams
> Cc: Chris Mason; Theodore Tso; Hua Zhong; Jens Axboe; Linux Kernel
> Mailing List
> Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
> 
> 
> 
> On Mon, 6 Apr 2009, Trenton D. Adams wrote:
> >
> > What about a procfs setting instead?  Is there a policy about why
> > something should be in procfs or /sys, or as a kernel config option?
> > That's basically as small as the patch you just made, right?
> 
> I'm never really against making things dynamically tunable, but this
> already was, and that wasn't really the issue.
> 
> Sure, you can just re-mount your filesystem with different options.
> That's
> what I did while testing - my /home is on a drive of its own, so I
> would
> just log out and as root unmount and re-mount with
> data=ordered/writeback,
> and log in and test again.
> 
> So dynamic tuning is good. But at the same time, having a tuning option
> is
> _never_ an excuse for not getting the default right in the first place.
> It's just a cop-out to say "hey, the default may be wrong for you, but
> you
> can always tune it locally with XYZ".
> 
> The thing is, almost nobody does that. Partly because it needs effort
> and
> knowledge, partly because after a few years the number of tuning knobs
> are
> in the hundreds for every little thing.
> 
> So instead, leave the tuning for the _really_ odd cases (if you use
> your
> machine as an IP router, you hopefully know enough to tune it if you
> really care). Not for random general-purpose "use for whatever" kind of
> thing.
> 
> > I'm just thinking that something like this, where people want one
> > thing or the other, but may not know it when they install Linux,
> might
> > like to change it realtime.  Especially if they are a Linux newbie,
> > and don't know how to compile their own kernel.  Or don't have time
> to
> > maintain their own kernel installs.
> 
> Oh absolutely. I'm not expecting people to compile their own kernels.
> I'm
> expecting that within a few months, most modern distributions will have
> (almost by mistake) gotten a new set of saner defaults, and anybody who
> keeps their machine up-to-date will see a smoother experience without
> ever
> even realizing _why_.
> 
> 			Linus

