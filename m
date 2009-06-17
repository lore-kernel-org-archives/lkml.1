Return-Path: <linux-kernel-owner+w=401wt.eu-S1760014AbZFQT3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014AbZFQT3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 15:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbZFQT2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 15:28:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52825 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038AbZFQT2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 15:28:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090617185219.GJ8633@ZenIV.linux.org.uk>
References: <20090617185219.GJ8633@ZenIV.linux.org.uk> <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int> <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain> <20090617183745.GI8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906171142580.16802@localhost.localdomain> 
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Date: Wed, 17 Jun 2009 20:28:29 +0100
Message-ID: <29139.1245266909@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> wrote:

> ... so we need a syscall that would do that "drop the caches" operation.
> _After_ having decided that it's really needed for symlinks.

If you want to support disconnected operation, then you need a way to (a) lock
an object in the cache, (b) unlock an object in the cache, (c) pull an object
into the cache, (d) kick an object out of the cache, (e) ban an object from the
cache, (f) reserve space in the cache for an object, (g) release the
reservation on an object and (h) find out the lock/ban/reservation status of an
object in the cache, and you'd need to support them for _all_ file types,
including dirs, symlinks, dev files and fifos.  Probably not UNIX sockets,
though.

I can add a system call for each of these operations.  I need some of them
anyway to implement kAFS if I'm not allowed pioctl().

<sarcasm> In fact, why don't I just make each AFS pioctl function a full-blown
syscall?  That satisfies Linus's semantics requirement, and avoids the need for
a 'typeless' multiplexor that so offends people.  OTOH, the master syscall mux
_is_ a typeless multiplexor... </sarcasm>

David
