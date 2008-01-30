Return-Path: <linux-kernel-owner+w=401wt.eu-S1760155AbYA3D32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760155AbYA3D32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbYA3D2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:28:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbYA3DZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:25:54 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <479901A8.3000706@oracle.com>
References: <479901A8.3000706@oracle.com> <20080123172038.11107.86025.stgit@warthog.procyon.org.uk> <20080123172246.11107.62216.stgit@warthog.procyon.org.uk>
To: chuck.lever@oracle.com, Trond.Myklebust@netapp.com
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 24/27] NFS: Use local caching [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 30 Jan 2008 03:25:01 +0000
Message-ID: <18686.1201663501@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Chuck Lever <chuck.lever@oracle.com> wrote:

> This patch really ought to be broken into more manageable atomic
> changes to make it easier to review, and to provide more fine-grained
> explanation and rationalization for each specific change via
> individual patch descriptions.

Hmmm....  I broke the patch up as Trond stipulated - at least, I thought I
had.

In many ways this request doesn't make sense.  You can't do NFS caching
without all the appropriate bits, so logically they should be one patch.
Breaking it up won't help git-bisect since the option to enable all this is
the last (or nearly last) patch.

However, I can do it (when I get back from LCA next week).

> This should no longer be necessary.  The latest mount.nfs subcommand
> from nfs-utils supports text-based mounts when running on kernels
> 2.6.23 and later.

Okay.  I'll update my patches to reflect this.  Note, however, I've got
someone reporting a bug that seems to show otherwise.  I'll have to
investigate this more next week.

> I hope you intend to provide updates to nfs(5) that describe the new
> mount options you introduce in this and later patches.  You don't
> mention it, but I assume that "nofsc" is the default behavior.

I should make SteveD do that, the options was his idea:-)  But I'll deal with
it.

> Add comments like this in a separate clean up patch.

????

> A suggestion: fs/nfs/fsc-index.c might be a better name.

If you wish, though I'd prefer to use a name that isn't like to clash with a
name that's going to appear in fs/fscache/ (or include/linux/ - I'd really
like to rename fs/nfs/fscache.h as dealing with two fscache.h's is annoying.

> > +struct nfs_fh_auxdata {
> > +	struct timespec	i_mtime;
> > +	struct timespec	i_ctime;
> > +	loff_t		i_size;
> > +};
> 
> It might be useful to explain here why you need to supplement the
> mtime, ctime, and size fields that already exist in an NFS inode.

Supplement?  I don't understand.

> > +		key->port = clp->cl_addr.sin_port;
> 
> Not sure why you are using the server's port here.  In almost every
> case the server side port number will be 2049, so it really doesn't
> add any uniquification.

The reason lies is "in almost every case".  It's possible to configure it
such that a server is running two separate NFS servers on different ports.

> If you're going for the client side port number, that changes after
> every connection, so it would be useless to identify a cache after a
> reboot (or even after the connection idles out!).

I'm going for the server side port number.  Using the client side port number
would be silly.

> I strongly recommend you use the existing IPv6 address conversion
> macros for this instead of open-coding yet another way of mapping an
> IPv4 address to an IPv6 address.
> 
> However, since AF_INET6 support is being introduced in the NFS client
> in 2.6.24, I recommend you take a look at these source files after
> Trond has pushed his NFS_ALL for 2.6.24.

I'll look at them.

> See below: the NFS cache-related stats should be added to nfs_iostats.

I believe I asked Trond, but I'll check.

I've got to move, so I'll deal with the rest of your email later.

David
