Return-Path: <linux-kernel-owner+w=401wt.eu-S1765148AbYA2RWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765148AbYA2RWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbYA2RWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:22:43 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51324 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbYA2RWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:22:42 -0500
Date: Tue, 29 Jan 2008 18:22:32 +0100
From: Jan Kara <jack@suse.cz>
To: Al Boldi <a1426z@gawab.com>
Cc: Chris Snook <csnook@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Message-ID: <20080129172232.GA9770@atrey.karlin.mff.cuni.cz>
References: <200801242336.00340.a1426z@gawab.com> <4799393A.5090605@redhat.com> <200801260828.07459.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801260828.07459.a1426z@gawab.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Chris Snook wrote:
> > Al Boldi wrote:
> > > Greetings!
> > >
> > > data=ordered mode has proven reliable over the years, and it does this
> > > by ordering filedata flushes before metadata flushes.  But this
> > > sometimes causes contention in the order of a 10x slowdown for certain
> > > apps, either due to the misuse of fsync or due to inherent behaviour
> > > like db's, as well as inherent starvation issues exposed by the
> > > data=ordered mode.
> > >
> > > data=writeback mode alleviates data=order mode slowdowns, but only works
> > > per-mount and is too dangerous to run as a default mode.
> > >
> > > This RFC proposes to introduce a tunable which allows to disable fsync
> > > and changes ordered into writeback writeout on a per-process basis like
> > > this:
> > >
> > >       echo 1 > /proc/`pidof process`/softsync
> > >
> > >
> > > Your comments are much welcome!
> >
> > This is basically a kernel workaround for stupid app behavior.
> 
> Exactly right to some extent, but don't forget the underlying data=ordered 
> starvation problem, which looks like a genuinely deep problem maybe related 
> to blockIO.
  It is a problem with the way how ext3 does fsync (at least that's what
we ended up with in that konqueror problem)... It has to flush the
current transaction which means that app doing fsync() has to wait till
all dirty data of all files on the filesystem are written (if we are in
ordered mode). And that takes quite some time... There are possibilities
how to avoid that but especially with freshly created files, it's tough
and I don't see a way how to do it without some fundamental changes to
JBD.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
