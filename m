Return-Path: <linux-kernel-owner+w=401wt.eu-S938505AbXG1AYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938505AbXG1AYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 20:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936614AbXG1AYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 20:24:31 -0400
Received: from waste.org ([66.93.16.53]:56347 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933273AbXG1AYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 20:24:30 -0400
Date: Fri, 27 Jul 2007 19:24:03 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric St-Laurent <ericstl34@sympatico.ca>,
       Rene Herman <rene.herman@gmail.com>,
       Jesper Juhl <jesper.juhl@gmail.com>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-ID: <20070728002403.GK11166@waste.org>
References: <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com> <1185341449.7105.53.camel@perkele> <46A6E1A1.4010508@yahoo.com.au> <2c0942db0707250909r435fef75sa5cbf8b1c766000b@mail.gmail.com> <20070725215717.df1d2eea.akpm@linux-foundation.org> <2c0942db0707252333uc7631fduadb080193f6ad323@mail.gmail.com> <20070725235037.e59f30fc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725235037.e59f30fc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 11:50:37PM -0700, Andrew Morton wrote:
> On Wed, 25 Jul 2007 23:33:24 -0700 "Ray Lee" <ray-lk@madrabbit.org> wrote:
> 
> > > So.  We can
> > >
> > > a) provide a way for userspace to reload pagecache and
> > >
> > > b) merge maps2 (once it's finished) (pokes mpm)
> > >
> > > and we're done?
> > 
> > Eh, dunno. Maybe?
> > 
> > We're assuming we come up with an API for userspace to get
> > notifications of evictions (without polling, though poll() would be
> > fine -- you know what I mean), and an API for re-victing those things
> > on demand.
> 
> I was assuming that polling would work OK.  I expect it would.
> 
> > If you think that adding that API and maintaining it is
> > simpler/better than including a variation on the above hueristic I
> > offered, then yeah, I guess we are. It'll all have that vague
> > userspace s2ram odor about it, but I'm sure it could be made to work.
> 
> Actually, I overdesigned the API, I suspect.  What we _could_ do is to
> provide a way of allowing userspace to say "pretend process A touched page
> B": adopt its mm and go touch the page.  We in fact already have that:
> PTRACE_PEEKTEXT.
> 
> So I suspect this could all be done by polling maps2 and using PEEKTEXT. 
> The tricky part would be working out when to poll, and when to reestablish.
> 
> A neater implementation than PEEKTEXT would be to make the maps2 files
> writeable(!) so as a party trick you could tar 'em up and then, when you
> want to reestablish firefox's previous working set, do a untar in
> /proc/$(pidof firefox)/

Sick. But thankfully, unnecessary. The pagemaps give you more than
just a present bit, which is all we care about here. We simply need to
record which pages are mapped, then reference them all back to life..

-- 
Mathematics is the supreme nostalgia of our time.
