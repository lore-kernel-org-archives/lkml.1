Return-Path: <linux-kernel-owner+w=401wt.eu-S1762364AbZEGUTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762364AbZEGUTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZEGUT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:19:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38472 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbZEGUT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:19:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Date: Thu, 7 May 2009 22:18:49 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905072133.48917.rjw@sisk.pl> <20090507130202.34cbe37a.akpm@linux-foundation.org>
In-Reply-To: <20090507130202.34cbe37a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905072218.50782.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, Andrew Morton wrote:
> On Thu, 7 May 2009 21:33:47 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Thursday 07 May 2009, Andrew Morton wrote:
> > > On Thu, 7 May 2009 20:09:52 +0200
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > > > > I'm suspecting that hibernation can allocate its pages with
> > > > > > > __GFP_FS|__GFP_WAIT|__GFP_NORETRY|__GFP_NOWARN, and the page allocator
> > > > > > > will dtrt: no oom-killings.
> > > > > > > 
> > > > > > > In which case, processes_are_frozen() is not needed at all?
> > > > > > 
> > > > > > __GFP_NORETRY alone causes it to fail relatively quickly, but I'll try with
> > > > > > the combination.
> > > > > 
> > > > > OK.  __GFP_WAIT is the big hammer.
> > > > 
> > > > Unfortunately it fails too quickly with the combination as well, so it looks
> > > > like we can't use __GFP_NORETRY during hibernation.
> > > 
> > > hm.
> > > 
> > > So where do we stand now?
> > > 
> > > I'm not a big fan of the global application-specific state change
> > > thing.  Something like __GFP_NO_OOM_KILL has a better chance of being
> > > reused by other subsystems in the future, which is a good indicator.
> > 
> > I'm not against __GFP_NO_OOM_KILL, but there's been some strong resistance to
> > adding new _GPF _FOO flags recently.
> 
> We have six or seven left - hardly a crisis.
> 
> >  Is there any likelihood anyone else we'll
> > really need it any time soon?
> 
> Dunno - people do all sorts of crazy things.  But it's more likely to
> be reused than a PM-specific global!
> 
> I have no strong feelings really, but slotting into the existing
> technique with something which might be reusable is quite a bit tidier.

OK, let's try with __GFP_NO_OOM_KILL first.  If there's too much disagreement,
I'll use the freezer-based approach instead.
