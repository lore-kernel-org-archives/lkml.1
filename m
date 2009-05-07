Return-Path: <linux-kernel-owner+w=401wt.eu-S1762462AbZEGUI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762462AbZEGUI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760476AbZEGUIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:08:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762761AbZEGUIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:08:01 -0400
Date: Thu, 7 May 2009 13:02:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Message-Id: <20090507130202.34cbe37a.akpm@linux-foundation.org>
In-Reply-To: <200905072133.48917.rjw@sisk.pl>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<200905072009.53406.rjw@sisk.pl>
	<20090507114807.d7c6d26a.akpm@linux-foundation.org>
	<200905072133.48917.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 21:33:47 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday 07 May 2009, Andrew Morton wrote:
> > On Thu, 7 May 2009 20:09:52 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > > > > I'm suspecting that hibernation can allocate its pages with
> > > > > > __GFP_FS|__GFP_WAIT|__GFP_NORETRY|__GFP_NOWARN, and the page allocator
> > > > > > will dtrt: no oom-killings.
> > > > > > 
> > > > > > In which case, processes_are_frozen() is not needed at all?
> > > > > 
> > > > > __GFP_NORETRY alone causes it to fail relatively quickly, but I'll try with
> > > > > the combination.
> > > > 
> > > > OK.  __GFP_WAIT is the big hammer.
> > > 
> > > Unfortunately it fails too quickly with the combination as well, so it looks
> > > like we can't use __GFP_NORETRY during hibernation.
> > 
> > hm.
> > 
> > So where do we stand now?
> > 
> > I'm not a big fan of the global application-specific state change
> > thing.  Something like __GFP_NO_OOM_KILL has a better chance of being
> > reused by other subsystems in the future, which is a good indicator.
> 
> I'm not against __GFP_NO_OOM_KILL, but there's been some strong resistance to
> adding new _GPF _FOO flags recently.

We have six or seven left - hardly a crisis.

>  Is there any likelihood anyone else we'll
> really need it any time soon?

Dunno - people do all sorts of crazy things.  But it's more likely to
be reused than a PM-specific global!

I have no strong feelings really, but slotting into the existing
technique with something which might be reusable is quite a bit tidier.

