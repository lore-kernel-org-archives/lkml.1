Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbYGRLxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbYGRLxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYGRLxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:53:14 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:48393 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYGRLxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:53:14 -0400
Subject: Re: [PATCH] cpu hotplug, sched:
	Introduce	cpu_active_map	and	redoscheddomainmanagment (take 2)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>, mingo@elte.hu,
       dmitry.adamushko@gmail.com, torvalds@linux-foundation.org, pj@sgi.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <487F6972.BA47.005A.0@novell.com>
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
	 <487DAD86.BA47.005A.0@novell.com> <487E6BD7.3020006@qualcomm.com>
	 <487E7B6C.BA47.005A.0@novell.com> <487EF1E9.2040101@qualcomm.com>
	 <487EFB71.BA47.005A.0@novell.com> <487F9509.9050802@qualcomm.com>
	 <487F6972.BA47.005A.0@novell.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 13:53:44 +0200
Message-Id: <1216382024.28405.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-17 at 13:46 -0600, Gregory Haskins wrote:
> >>> On Thu, Jul 17, 2008 at  2:52 PM, in message <487F9509.9050802@qualcomm..com>,
> Max Krasnyansky <maxk@qualcomm.com> wrote: 
> > Gregory Haskins wrote:
> >>
> >> Hi Max,
> >>   Thanks for the pointers.  I see that I did indeed misunderstand the intent 
> >> of the patch.  It seems you already solved the rebuild problem, and were
> >> just trying to solve the "migrate to a dead cpu" problem that Linus mentions
> >> as a solution with cpu_active_map.
> >
> > Yes. btw they are definitely related, because the reason we were blowing 
> > away the domains is to avoid "migration to a dead cpu". ie We were relying
> > on the fact that domain masks never contain cpus that are either dying or
> > already dead.
> 
> Agreed.
> 
> >> 
> >> Thoughts?
> >
> > None at this point :). I need to run right now and will try to look at this
> > later today. My knowledge of the internal sched structs is definitely 
> > lacking so I need to look at the rq->rd thing to have and opinion.
> 
> Sounds good, Max.  Thanks!

I'm thinking doing it explicitly with the new cpu mask is clearer and
easier to understand than 'hiding' the variable in the root domain and
having to understand all the domain/root-domain stuff.

I think this was Linus' main point. It should be easier to understand
this code.


So, if there is functional overlap with the root domain stuff, it might
be good to remove that bit and use the cpu_active_map stuff for that
instead.



