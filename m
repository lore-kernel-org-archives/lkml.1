Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbXLGBS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbXLGBS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 20:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXLGBST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 20:18:19 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:44775 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXLGBSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 20:18:18 -0500
Subject: Re: [PATCH 3/3] printer port driver: semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux@bohmer.net, jonathan@jonmasters.org,
       matthias.kaehlcke@gmail.com
In-Reply-To: <47588610.5010804@gmail.com>
References: <20071206021857.826386004@mvista.com>
	 <20071206021909.131993721@mvista.com>  <20071206102334.GE17299@elte.hu>
	 <1196958847.1568.98.camel@jnielson-xp.ddns.mvista.com>
	 <47588610.5010804@gmail.com>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 17:05:15 -0800
Message-Id: <1196989515.1568.131.camel@jnielson-xp.ddns.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-06 at 19:30 -0400, Kevin Winchester wrote:
> Daniel Walker wrote:
> > On Thu, 2007-12-06 at 11:23 +0100, Ingo Molnar wrote:
> >> * Daniel Walker <dwalker@mvista.com> wrote:
> >>
> >>> The port_mutex is actually a semaphore, so easily converted to a 
> >>> struct mutex.
> >>>
> >>> Signed-off-by: Daniel Walker <dwalker@mvista.com>
> >> Acked-by: Ingo Molnar <mingo@elte.hu>
> >>
> >> cool. How far away are we from being able to remove all the semaphore 
> >> code? :-)
> > 
> > I wish my 7 patches made a dent, but it's hasn't done much. ;(
> > 
> > I would guess at least a week just to mop up the relatively easy ones..
> > I've got 12 in my queue, and there still ~50 hopefully trivial ones
> > still to be looked at.. Then another ~30 more difficult ones (that use
> > init_MUTEX_LOCKED, or sema_init with 0 instead of 1) ..
> > 
> 
> I didn't realise there were so many of these patch sets still to go.  I
> could probably help out with some of them.  Is there somewhere we could
> keep track of which ones are left to do, and who is handling them?  If
> it would be helpful, I could go through all of the semaphore uses in the
> tree and try to figure out which (if any) are true counting semaphores
> that cannot be converted, and then I could post/send the list of
> convertible cases.  Would that be helpful, or has it already been done
> somewhere else?

I've posted all the ones I've done so far ..

ftp://source.mvista.com/pub/dwalker/sem2mutex-2.6.24-rc4/

Feel free to review or test them.. I've found it pretty easy to simply
grep for certain class of semaphore usage, check if it's conforming to
the mutex requirements, then convert it or not.. Checking them is
getting to be a habit, so I don't think a list would help me.. However,
someone else might be able to use it..

Daniel



