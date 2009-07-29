Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZG2UM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZG2UM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZG2UMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:12:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33528 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbZG2UMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:12:24 -0400
Subject: Re: fanotify - overall design before I start sending patches
From: Eric Paris <eparis@redhat.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jamie Lokier <jamie@shareable.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       malware-list@dmesg.printk.net, Valdis.Kletnieks@vt.edu, greg@kroah.com,
       jcm@redhat.com, douglas.leeder@sophos.com, tytso@mit.edu,
       arjan@infradead.org, jengelh@medozas.de, aviro@redhat.com,
       mrkafk@gmail.com, alexl@redhat.com, jack@suse.cz,
       tvrtko.ursulin@sophos.com, a.p.zijlstra@chello.nl, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, mmorley@hcl.in
In-Reply-To: <20090727175225.GA27999@ioremap.net>
References: <1248466429.3567.82.camel@localhost>
	 <alpine.DEB.1.10.0907241340580.28013@asgard.lang.hm>
	 <1248469278.3567.88.camel@localhost> <20090724214401.GJ27755@shareable.org>
	 <20090727175225.GA27999@ioremap.net>
Content-Type: text/plain
Date: Wed, 29 Jul 2009 16:11:03 -0400
Message-Id: <1248898263.2597.56.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 21:52 +0400, Evgeniy Polyakov wrote:
> Hi.
> 
> On Fri, Jul 24, 2009 at 10:44:01PM +0100, Jamie Lokier (jamie@shareable.org) wrote:
> > > No, I will NOT EVER pass a pathname.  Period.  End of story.  I stated
> > > the if userspace wants to deal with pathnames (and they understand the
> > > system setup well enough to know if pathnames even make sense to them)
> > > they can use readlink(2) on /proc/self/fd
> > 
> > That makes sense.
> > 
> > In most cases where events trigger userspace cache or index updates,
> > userspace already has enough information to calculate the path (and
> > any derived data) from the inode number (in the case of non-hard-link
> > files) or from the inode number of the parent directory and the name
> > (not full path).
> 
> Except that rlimits may forbid to open new file descriptor while queue
> length is enough to put another event with the full or partial path
> name.
> 
> I will read initial mail next, but if it is not described there, how
> rlimit problem is handled?

At the moment if you run out of rlimit fds you start getting (useless)
events with the fd equal to some errno (don't remember what hitting
rlimit errno is offhand)

-Eric

