Return-Path: <linux-kernel-owner+w=401wt.eu-S1760479AbXHAHrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbXHAHrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 03:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbXHAHrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 03:47:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbXHAHrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 03:47:12 -0400
Date: Wed, 1 Aug 2007 00:46:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric St-Laurent <ericstl34@sympatico.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm2
 (vm-dont-run-touch_buffer-during-buffercache-lookups.patch)
Message-Id: <20070801004625.46a24a26.akpm@linux-foundation.org>
In-Reply-To: <1185953790.6393.20.camel@perkele>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	<1185953790.6393.20.camel@perkele>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 03:36:30 -0400 Eric St-Laurent <ericstl34@sympatico.ca> wrote:

> On Tue, 2007-31-07 at 23:09 -0700, Andrew Morton wrote:
> 
> > +vm-dont-run-touch_buffer-during-buffercache-lookups.patch
> > 
> >  A little VM experiment.  See changelog for details.
> 
> > We don't have any tests to determine the effects of this, and nobody will
> > bother setting one up, so ho hum, this remains in -mm for ever.
> 
> > I don't think there's any point in doing this until we have some decent
> > testcases.
> 
> 
> Hi Andrew,
> 
> 
> For which problem this patch was coded?

Good question.  I think the current behaviour is just wrong.  What the
effect of changing it will be is hard to predict - probably little.

>  Is it a potential fix to the
> updatedb problem?

That's one workload which is particularly susceptible to the problemn which
that patch addresses, yes.  But in my (brief) testing it didn't make musch
difference.

> Is the patch effective without the filesystem dependant change you talk
> about?  (I use reiserfs)

Yes, it'll work as designed with reiserfs.

> I've been thinking about a test case for the updatedb problem:
> 
> 1. Script or program that create a large number of directories and zero
> sized files.  Same setup for everyone to have reproducible results.
> 
> 2. Run updatedb on those.
> 
> 3. Observe the effects (with vmstat, slabinfo and meminfo) before,
> during and after the updatedb run.
> 
> 4. Do something to trigger some reclaim like copying a large file.
> 
> 5. See the effects.
> 
> 
> What do you think? What would be the ideal test case for the problem in
> your opinion?

Sounds good, yes.

Or you could do something more real-worldly like start up OO, firefox and
friends, then run /etc/cron.daily/everything and see what the
before-and-after effects are.  The aggregate info we're looking for is
captured in /proc/meminfo: swapped, Mapped, Cached, Buffers.


