Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZGOKvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZGOKvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbZGOKvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:51:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41765 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbZGOKvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:51:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1247598200.6122.122.camel@heimdal.trondhjem.org>
References: <1247598200.6122.122.camel@heimdal.trondhjem.org> <1247161851.5766.44.camel@heimdal.trondhjem.org> <1552.1247160463@redhat.com> <6404.1247593654@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: dhowells@redhat.com, steved@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] NFS: Propagate 'fsc' mount option through automounts
Date: Wed, 15 Jul 2009 11:50:52 +0100
Message-ID: <12455.1247655052@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> > > Why not just use the mount path as the default uniquifier?

In fact, why change it from being blank?  If I do this:

	The natural thing would be to use the mount path that is required to
	locate the super block's root dentry on the server (i.e. the mount
	path for sb->s_root).

then it may as well be blank, since the FSID is a sufficient uniquifier, and
that's also included in the key.


Where a uniquifier is needed is when someone sets up two mounts of the same
thing, but with different network parameters as these aren't recorded in the
key.  Under such a circumstance, manual intervention is required in the form
of a supplied uniquifier on one of the mounts.

That uniquifier should also only apply to the superblock actually being
mounted, I think; but it's probably okay to apply it to all the intervening
transient superblocks from root that nfs_follow_remote_path() causes to exist,
and just accept that you might get a little bit of rubbish in the cache once
we start caching directories.

Also, the uniquifier would be applied to all superblocks that get created by
automounts under a superblock that has a uniquifier.

David
