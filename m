Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402AbYLLTNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402AbYLLTNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYLLTNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:13:32 -0500
Received: from virgo.iok.hu ([212.40.97.103]:57056 "EHLO virgo.iok.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYLLTNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:13:31 -0500
Date: Fri, 12 Dec 2008 19:53:47 +0100
From: Miklos Vajna <vmiklos@frugalware.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplified GIT usage guide
Message-ID: <20081212185347.GK5691@genesis.frugalware.org>
References: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PyWBHxIrsGpYNMFw"
Content-Disposition: inline
In-Reply-To: <20081212182827.28408.40963.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PyWBHxIrsGpYNMFw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 12, 2008 at 06:28:27PM +0000, David Howells <dhowells@redhat.com> wrote:
> + (1) File objects.
> +
> +     A file object contains the contents of a source file and the attributes of
> +     that file (such as file mode).

This is incorrect, a 'blob' contains only the contents of the blob, the
file mode is stored in the 'tree' object.

> + (2) Directory objects.
> +
> +     A directory object contains the attributes of that directory plus a list
> +     of file and directory objects that are members of this directory.  The
> +     list includes the names of the entries within that directory and the
> +     object ID of each object.
> +
> + (3) Commit objects.
> +
> +     A commit object contains the attribute of that commit (the author and the
> +     date for instance), a textual description of the change imposed by that
> +     commit as provided by the committer, a list of object IDs for the commits
> +     on which this commit is based, and the object ID of the root directory
> +     object representing the result of this commit.
> +
> +     Note that a commit does not literally describe the changes that have been
> +     made in the way that, say, a diff file does; it merely carries the current
> +     state of the sources after that change, and points to the commits that
> +     describe the state of the sources before that change.  GIT's tools then
> +     infer the changes when asked.
> +
> +     A commit object will typically refer to one base commit when someone has
> +     merely committed some changes on top of the current state, and two base
> +     commits when a couple of trees have been merged.

Is there any reason you hide the tag object?

> +where %HOUR is the hour you want it to go off every day.  For my local mirror
> +of Linus's upstream kernel, I use:
> +
> +	#!/bin/sh
> +	cd /warthog/git/linux-2.6 || exit $?
> +	exec git pull >/tmp/git-pull.log
> +
> +and:
> +
> +	0 6 * * *       /home/dhowells/bin/do-git-pull.sh
> +
> +which will do the update every day at 6am.

Using git clone --mirror would be much efficient, I think.

> +The "-l" tells git clone that the source (mirror) repository is on the local
> +machine, that it shouldn't go over the internet for it, and that it should
> +hardlink GIT objects from the source repository rather than copying them where
> +possible.

Here and later below, IIRC -l is the default for local clones.

> +	cd /my/git/trees
> +	git clone -n --bare %UPSTREAM_REPO %MY_DIR

--bare implies -n.

> +If you haven't yet committed your changes, you'll have to siphon them off into
> +a file:
> +
> +	git diff >a.diff
> +
> +and deapply them:
> +
> +	patch -p1 -R <a.diff
> +
> +You can then update your tree from the upstream tree with no fear of a conflict
> +(assuming you don't also have changes that you have committed).  Once you've
> +updated your tree, you can reapply your changes:
> +
> +	patch -p1 <a.diff

Why not using git stash and git stash pop?

Or at least git apply and git checkout - leaving out patch(1) from the
game.

--PyWBHxIrsGpYNMFw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklCszsACgkQe81tAgORUJaxZwCglotfKRzufazRLtPg9Eq4xOmw
2usAnjyUgTeJ0gzE5D7EZDFdf2kmW7oM
=VKpR
-----END PGP SIGNATURE-----

--PyWBHxIrsGpYNMFw--
