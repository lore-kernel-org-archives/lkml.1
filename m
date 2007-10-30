Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbXJ3Pzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbXJ3Pzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 11:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbXJ3Pz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 11:55:27 -0400
Received: from styx.suse.cz ([82.119.242.94]:47174 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753892AbXJ3Pz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 11:55:27 -0400
Date: Tue, 30 Oct 2007 16:55:25 +0100
From: Jan Kara <jack@suse.cz>
To: Rik van Riel <riel@redhat.com>
Cc: Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: OOM notifications
Message-ID: <20071030155525.GF9702@duck.suse.cz>
References: <20071018201531.GA5938@dmt> <20071030145720.GB27039@atrey.karlin.mff.cuni.cz> <20071030112346.4b48bfe5@cuia.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030112346.4b48bfe5@cuia.boston.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30-10-07 11:23:46, Rik van Riel wrote:
> On Tue, 30 Oct 2007 15:57:20 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> >   Hello,
> > 
> > > AIX contains the SIGDANGER signal to notify applications to free up some
> > > unused cached memory:
> > > 
> > > http://www.ussg.iu.edu/hypermail/linux/kernel/0007.0/0901.html
> > > 
> > > There have been a few discussions on implementing such an idea on Linux,
> > > but nothing concrete has been achieved.
> > > 
> > > On the kernel side Rik suggested two notification points: "about to
> > > swap" (for desktop scenarios) and "about to OOM" (for embedded-like
> > > scenarios).
> > > 
> > > With that assumption in mind it would be necessary to either have two
> > > special devices for notification, or somehow indicate both events
> > > through the same file descriptor.
> >   Actually, wouldn't a generic netlink interface be more elegant? Then
> > we could connect it with DBUS and it would be much easier for
> > applications (Desktop) to handle such events.
> >   I agree that near-to-oom conditions are quite volatile and maybe we
> > want a technically simple (and thus more reliable) mechanism for the
> > notification but I anyway wanted to point to this possibility.
> 
> There's nothing wrong with being able to get this info via DBUS,
> but we cannot expect every database and JVM out there (big targets
> for the "reduce your memory footprint" thing on servers) to grow
> a DBUS interface.
  Hmm, that's right, but still the kernel->userspace interface could be via
netlink (which is much more flexible than signals etc.) and then in userspace
we could implement also some simple interface (UNIX socket?) for server like
apps...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
