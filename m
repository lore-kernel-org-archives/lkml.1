Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbYA3ObV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbYA3ObV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYA3ObH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:31:07 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:60608 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbYA3ObF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:31:05 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
Date: Wed, 30 Jan 2008 09:29:21 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jan Kara <jack@suse.cz>, Chris Snook <csnook@redhat.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801242336.00340.a1426z@gawab.com> <20080129172232.GA9770@atrey.karlin.mff.cuni.cz> <200801300904.48299.a1426z@gawab.com>
In-Reply-To: <200801300904.48299.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801300929.21778.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008, Al Boldi wrote:
> Jan Kara wrote:
> > > Chris Snook wrote:
> > > > Al Boldi wrote:
> > > > > This RFC proposes to introduce a tunable which allows to disable
> > > > > fsync and changes ordered into writeback writeout on a per-process
> > > > > basis like this:
> > > > >
> > > > >       echo 1 > /proc/`pidof process`/softsync
> > > >
> > > > This is basically a kernel workaround for stupid app behavior.
> > >
> > > Exactly right to some extent, but don't forget the underlying
> > > data=ordered starvation problem, which looks like a genuinely deep
> > > problem maybe related to blockIO.
> >
> >   It is a problem with the way how ext3 does fsync (at least that's what
> > we ended up with in that konqueror problem)... It has to flush the
> > current transaction which means that app doing fsync() has to wait till
> > all dirty data of all files on the filesystem are written (if we are in
> > ordered mode). And that takes quite some time... There are possibilities
> > how to avoid that but especially with freshly created files, it's tough
> > and I don't see a way how to do it without some fundamental changes to
> > JBD.
>
> Ok, but keep in mind that this starvation occurs even in the absence of
> fsync, as the benchmarks show.
>
> And, a quick test of successive 1sec delayed syncs shows no hangs until
> about 1 minute (~180mb) of db-writeout activity, when the sync abruptly
> hangs for minutes on end, and io-wait shows almost 100%.

Do you see this on older kernels as well?  The first thing we need to 
understand is if this particular stall is new.

-chris
