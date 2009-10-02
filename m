Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZJBVTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZJBVTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZJBVTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:19:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36613 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbZJBVTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:19:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Helsley <matthltc@us.ibm.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/19] freezer: don't get over-anxious while waiting
Date: Fri, 2 Oct 2009 23:21:11 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Oren Laadan <orenl@librato.com>, Pavel Machek <pavel@ucw.cz>,
       jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       pm list <linux-pm@lists.linux-foundation.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <4AC658C2.6070406@librato.com> <20091002210445.GE4189@count0.beaverton.ibm.com>
In-Reply-To: <20091002210445.GE4189@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910022321.11796.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 October 2009, Matt Helsley wrote:
> On Fri, Oct 02, 2009 at 03:47:14PM -0400, Oren Laadan wrote:
> > 
> > 
> > Rafael J. Wysocki wrote:
> > > On Thursday 01 October 2009, Pavel Machek wrote:
> > >>> Freezing isn't exactly the most latency sensitive operation and
> > >>> there's no reason to burn cpu cycles and power waiting for it to
> > >>> complete.  msleep(10) instead of yield().  This should improve
> > >>> reliability of emergency hibernation.
> > >> i don't see how it improves reliability, but its probably ok.
> 
> From what little of the patch I can see at this point I agree. 
> On a single cpu system the yield gives up the cpu so other tasks
> are more likely to make the progress necessary to become freezable.
> 
> > >>
> > >> Well... for hibernation anyway. I can imagine cgroup users where
> > >> freeze is so fast that this matters. rjw cc-ed.		pavel
> 
> It doesn't (more below), though I appreciate your keeping us in mind.
> 
> > > 
> > > Thanks.  I'd like to hear from the cgroup freezer people about that.
> > > 
> > 
> > [Adding Matt Helsley to the CC list]
> > 
> > To checkpoint or migrate an application, the cgroup to which it belongs
> > must be frozen first.
> > 
> > It's a bit down the road, but if one seeks minimum application downtime
> > during application checkpoint and/or migration, then a (minimum of)
> > 10ms - or multiples of it - may result in a visible/undesired hick-up.
> > 
> > Perhaps avoid it when freezing a cgroup ?  or maybe a way for the user
> > to control this behavior per cgroup ?
> 
> This is already the case.
> 
> The cgroup freezer does not use this yield-loop to iterate over all the tasks.
> Instead of yield() the cgroup freezer has its own "loop". It changes its
> own state to FREEZING and returns to userspace so that userspace can decide
> what to do -- sleep? keep trying to freeze? go back to THAWED? etc. 
> 
> [ In the future this may change depending on the blocking/non-blocking
> flag of the open freezer.state cgroup file handle. ]

OK, thanks for the info.

Tejun, do you want me to take the patch or is it more convenient to you to
push it yourself?

Also, care to respond to my previous comment?

Rafael
