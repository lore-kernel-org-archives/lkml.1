Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZGXXqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZGXXqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 19:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755241AbZGXXqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 19:46:18 -0400
Received: from mail2.shareable.org ([80.68.89.115]:37027 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbZGXXqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 19:46:18 -0400
Date: Sat, 25 Jul 2009 00:46:15 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, david@lang.hm, jengelh@medozas.de,
       aviro@redhat.com, mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in, pavel@suse.cz
Subject: Re: fanotify - overall design before I start sending patches
Message-ID: <20090724234615.GQ27755@shareable.org>
References: <1248466429.3567.82.camel@localhost> <20090724224813.GK27755@shareable.org> <1248477951.3567.110.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248477951.3567.110.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:
> On Fri, 2009-07-24 at 23:48 +0100, Jamie Lokier wrote:
> > Eric Paris wrote:
> > > It is a new notification system that has a limited set of events (open,
> > > close, read, write) in which notification not only comes with metadata
> > > the describes what happened it also comes with an open file descriptor
> > > to the object in question.  fanotify will also allow the listener to
> > > make access decisions on open and read events.  This allows the
> > > implementation of hierarchical storage management systems or an access
> > > file scanning or integrity checking.
> > 
> > My first thought was to wonder, why not make it the same set of events
> > that inotify and dnotify provide?  That is: open, close, read, write,
> > create, delete, rename, attribute change?  In other words, I don't see
> > a good reason for it to be a subset of events.
> 
> The two real reasons?
> 
> 1) These were the only 4 my original use case cared about.
> 2) These are the only 4 where the notification hook has enough
> information to open a fd in the context of the listener.
> 
> In the kernel most notification is done with either an inode or a dentry
> as that is enough for inotify, dnotify, audit_watch and audit_tree.
> Opening a file descriptor, and thus fanotify, requires a dentry and a
> vfsmnt, which is much harder to come by in the kernel.
>
> Maybe as future work I'll try to convince Al to allow me to have that
> information in more places, but for today, those 4 are the only ones I
> can probably slip past him...

For the other events, maybe there is no need for a file descriptor
anyway.

-- Jamie
