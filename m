Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbZEFLop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbZEFLop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbZEFLoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:44:34 -0400
Received: from verein.lst.de ([213.95.11.210]:49381 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbZEFLod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:44:33 -0400
Date: Wed, 6 May 2009 13:44:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4/jbd2: remove stray markers
Message-ID: <20090506114415.GA26947@lst.de>
References: <20090506104436.GA24047@lst.de> <20090506110354.GG25203@elte.hu> <20090506114051.GA4964@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506114051.GA4964@mit.edu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 07:40:51AM -0400, Theodore Tso wrote:
> My complaint with Cristoph's

Christoph, still :)

> is that it will conflict with patches I
> have pending which replaces the markers with tracepoints --- and I
> *am* using the tracepoints actively.  The only reason why these
> patches aren't in -stable is they have a dependency one of Rostedt's
> changes.  (Not a syntactic dependency, but if we merge in the wrong
> order, and the rcu_read_lock/unlock() calls aren't around the
> TP_PRINTK callpoint, then in certain CONFIG_PREEMPT configurations and
> if there is more than one active ext4 filesystem while the ext4 or
> jbd2 tracepoints are active, there's a potential race.)

Also without Steve's updates you can't actually use them in a module.

> My plan was to wait for the tracing patches to get pushed during the
> 2.6.31 merge tree, at which point I would then push my changes which
> replace the markers with TRACE_EVENT changes.  So no matter which way
> we do this, the ext4 markers will be gone by the end of the 2.6.31
> merge window.
> 
> Christoph, if you have some desire to completely remove the
> CONFIG_MARKERS support code, and I'm holding up your ability to do
> work, I can take the ext4 TRACE_EVENT patches, and queue them up in
> tip/tracing.  It's less work than if we take your markers removal
> patches, since then I would have to resolve all of the conflicts with
> my patches which replace all of the ext4 and jbd2 markers with
> TRACE_EVENTS macros.

I was planning to do make sure it's all gone.  Once we are into the
2.6.31 merge dinwo I fear that the final patches will miss the window
due to all these interdependencies.  But Ingo didn't seem to be too
interested in taking the other patches that would be required for it,
so I guess I'll try to somehow get it done in the merge window and
otherwise we'll have to wait for 2.6.32.

