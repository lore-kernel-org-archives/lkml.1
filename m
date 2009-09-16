Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbZIPPx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbZIPPx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZIPPxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:53:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbZIPPxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:53:54 -0400
Subject: Re: fanotify as syscalls
From: Eric Paris <eparis@redhat.com>
To: Jamie Lokier <jamie@shareable.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org
In-Reply-To: <20090916125658.GF29359@shareable.org>
References: <20090914140720.GA8564@ioremap.net>
	 <1252955295.2246.35.camel@dhcp231-106.rdu.redhat.com>
	 <20090915201620.GB32192@ioremap.net>
	 <1253051699.5213.18.camel@dhcp231-106.rdu.redhat.com>
	 <alpine.LFD.2.01.0909151643540.4950@localhost.localdomain>
	 <1253064391.5213.37.camel@dhcp231-106.rdu.redhat.com>
	 <20090916075219.GA22024@shareable.org>
	 <20090916114111.2228f0fc@linux.intel.com>
	 <20090916114107.GB29359@shareable.org>
	 <20090916130127.439c9222@lxorguk.ukuu.org.uk>
	 <20090916125658.GF29359@shareable.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Sep 2009 11:53:00 -0400
Message-Id: <1253116380.5213.121.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 13:56 +0100, Jamie Lokier wrote:
> Alan Cox wrote:
> > > You can't rely on the name being non-racy, but you _can_ reliably
> > > invalidate application-level caches from the sequence of events
> > > including file writes, creates, renames, links, unlinks, mounts.  And
> > > revalidate such caches by the absence of pending events.
> > 
> > You can't however create the caches reliably because you've no idea if
> > you are referencing the right object in the first place - which is why
> > you want a handle in these cases. I see fanotify as a handle producing
> > addition to inotify, not as a replacement (plus some other bits around
> > open blocking for HSM etc)
> 
> There are two sets of events getting mixed up here.  Inode events -
> reads, writes, truncates, chmods; and directory events - renames,
> links, creates, unlinks.

My understanding of you argument is that fanotify does not yet provide
all inotify events, namely those of directories operations and thus is
not suitable to wholesale replace everything inotify can do.  I've
already said that working towards that goal is something I plan to
pursue, but for now, you still have inotify.

The mlocate/updatedb people ask me about fanotify and it's on the todo
list to allow global reception of of such events.  The fd you get would
be of the dir where the event happened.  They didn't care, and I haven't
decided if we would provide the path component like inotify does.  Most
users are perfectly happy to stat everything in the dir.

It's hopefully feasible, but it's going to take some fsnotify hook
movements and possibly so arguments with Al to get the information I
want where I want it.  But there is nothing about the interface that
precludes it and it has been discussed and considered.

Am I still missing it?

-Eric

