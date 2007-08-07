Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbXHGL6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbXHGL6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 07:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXHGL6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 07:58:44 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:38701 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbXHGL6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 07:58:42 -0400
To: jlayton@redhat.com
CC: miklos@szeredi.hu, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mikulas@artax.karlin.mff.cuni.cz, zippel@linux-m68k.org,
       joel.becker@oracle.com, wli@holomorphy.com, dhowells@redhat.com,
       bfennema@falcon.csc.calpoly.edu
In-reply-to: <20070807072729.71f15109.jlayton@redhat.com> (message from Jeff
	Layton on Tue, 7 Aug 2007 07:27:29 -0400)
Subject: Re: [fuse-devel] [PATCH 01/25] VFS: move attr_kill logic from
 notify_change into helper function
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
	<E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
	<20070806141333.0f54ab17.jlayton@redhat.com>
	<E1II7JR-0005BN-00@dorka.pomaz.szeredi.hu>
	<1186427063.6616.59.camel@localhost>
	<E1II8Nw-0005XH-00@dorka.pomaz.szeredi.hu>
	<1186435419.6616.136.camel@localhost>
	<E1III7U-0006ju-00@dorka.pomaz.szeredi.hu> <20070807072729.71f15109.jlayton@redhat.com>
Message-Id: <E1IINct-0007Se-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 07 Aug 2007 13:53:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On the other hand, the filesystem writers here are declaring their own
> setattr operation. Is it unreasonable for them to take responsibility
> for handling this too? 

We have about half of all the in-tree filesystems declaring
->setattr(), and out of those only two that we know would use this.
Others haven't commented, which proably means, they just don't care
about this issue.

And even if most of them would make use of this feature, a inode flag
or filesystem flag for a smooth and backward compatible migration is
just so much better than risking to break filesystems.

And yes, I'm thinking about in-tree filesystems as well.  I'm sure you
did a thorough audit of all filesystems, but we are all human and can
make mistakes.  It is _always_ safer to not change an API which could
cause silent breakage.  And IMO, that's far more important than the
beauty of an interface (and ->setattr() is not beautiful with or
without an inode flag).

> Another alternative might be to rename notify_change(). I don't really
> like gratuitously breaking the API, though, and that function is
> referenced in a lot of documentation. Changing it might be confusing...

Oh no.  I'd like less breakage not more.

Miklos
