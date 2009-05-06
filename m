Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZEFLl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZEFLl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbZEFLlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:41:15 -0400
Received: from THUNK.ORG ([69.25.196.29]:42442 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZEFLlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:41:14 -0400
Date: Wed, 6 May 2009 07:40:51 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4/jbd2: remove stray markers
Message-ID: <20090506114051.GA4964@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>, linux-ext4@vger.kernel.org
References: <20090506104436.GA24047@lst.de> <20090506110354.GG25203@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506110354.GG25203@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 01:03:54PM +0200, Ingo Molnar wrote:
> 
> > Ted, I think you have some TRAVE_EVENT patches for ext4 pending, 
> > but is it okay to queue up this removal in the tracing tree?  That 
> > way we can remove the markers leftovers there completely as soon 
> > as the 2.6.31 merge window opens.
> 
> i think these markers are still in active use, so i'd not remove 
> them before Ted's TRACE_EVENT() changes are included. We can/should 
> do that in a single topic - in a work flow that suits Ted best.

My complaint with Cristoph's is that it will conflict with patches I
have pending which replaces the markers with tracepoints --- and I
*am* using the tracepoints actively.  The only reason why these
patches aren't in -stable is they have a dependency one of Rostedt's
changes.  (Not a syntactic dependency, but if we merge in the wrong
order, and the rcu_read_lock/unlock() calls aren't around the
TP_PRINTK callpoint, then in certain CONFIG_PREEMPT configurations and
if there is more than one active ext4 filesystem while the ext4 or
jbd2 tracepoints are active, there's a potential race.)

> We can do a -git based special-purpose topic branch in -tip, or we 
> can do it in tip/tracing, or we can pull a (-git based) branch from 
> Ted. Or we can delay it all to the v2.6.31 merge window. Ted's 
> choice.

My plan was to wait for the tracing patches to get pushed during the
2.6.31 merge tree, at which point I would then push my changes which
replace the markers with TRACE_EVENT changes.  So no matter which way
we do this, the ext4 markers will be gone by the end of the 2.6.31
merge window.

Christoph, if you have some desire to completely remove the
CONFIG_MARKERS support code, and I'm holding up your ability to do
work, I can take the ext4 TRACE_EVENT patches, and queue them up in
tip/tracing.  It's less work than if we take your markers removal
patches, since then I would have to resolve all of the conflicts with
my patches which replace all of the ext4 and jbd2 markers with
TRACE_EVENTS macros.

My preference is for the former, mainly because my patches are already
set up for that, and I'm a lazy bastard; the latter wouldn't be much
work, though.  I'm guessing your preference would be for the latter?

	      		       	      - Ted
