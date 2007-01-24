Return-Path: <linux-kernel-owner+w=401wt.eu-S932833AbXAXWwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833AbXAXWwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932846AbXAXWwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:52:11 -0500
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:52342
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833AbXAXWwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:52:10 -0500
Date: Wed, 24 Jan 2007 14:52:05 -0800
To: Ingo Molnar <mingo@elte.hu>
Cc: "Chen, Tim C" <tim.c.chen@intel.com>, linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [PATCH] lock stat for -rt 2.6.20-rc2-rt2.2.lock_stat.patch
Message-ID: <20070124225205.GA5220@gnuppy.monkey.org>
References: <9D2C22909C6E774EBFB8B5583AE5291C019998CA@fmsmsx414.amr.corp.intel.com> <20061229232618.GA11239@gnuppy.monkey.org> <20061230111940.GA8412@elte.hu> <20070103074124.GA25594@gnuppy.monkey.org> <20070124113115.GA12667@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124113115.GA12667@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 12:31:15PM +0100, Ingo Molnar wrote:
> * Bill Huey <billh@gnuppy.monkey.org> wrote:
> 
> > Patch here:
> > 
> > 	http://mmlinux.sourceforge.net/public/patch-2.6.20-rc2-rt2.2.lock_stat.patch
> 
> hm, most of the review feedback i gave has not been addressed in the 
> patch above. So i did it myself: find below various fixups for problems 
> i outlined plus for a few other problems as well (ontop of 
> 2.3.lock_stat).

Sorry, I've been siliently keeping your suggested change in my private
repo without announcing it to the world. I'll reply to the old email in
another message at length.

	http://mmlinux.sourceforge.net/public/patch-2.6.20-rc2-rt2.4.lock_stat.patch

> While it's now markedly better it's still not quite mergeable, for 
> example the build fails quite spectacularly if LOCK_STAT is disabled in 
> the .config.

I'll look into it. I've been focused on clean up and a couple of other
things regard the stability of this patch. Making small changes in it
tends to make the kernel crash hard and I suspect that it's an interaction
problem with lockdep and that I need to turn lockdep off when hitting
"lock stats" locks. I'm going to move to "__raw_..." locks...

Meanwhile please wait until I hand interpret and merge your changes to an
older patch into my latest stuff. If it's takes too long, I suggest keeping
out of the tree for a bit until I finish this round unless something is
pressing for this to happen now like a mass change to the spinlock macros
or something. I stalled a bit trying to get Peter Zijlstra an extra feature.

> Also, it would be nice to replace those #ifdef CONFIG_LOCK_STAT changes 
> in rtmutex.c with some nice inline functions that do nothing on 
> !CONFIG_LOCK_STAT.

I'll look into it. Not sure what your choice in style is here and I'm
open to suggestions. I'm also interested in a reduction of #define
identifier length if you or somebody else has some kind of good convention
to suggest.

> but in general i'm positive about the direction this is heading, it just 
> needs more work.

Sorry, for the lag. Trying to juggle this and the current demands of my
employeer contributed to this lag unfortunately.

bill

