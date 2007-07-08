Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbXGHRmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbXGHRmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 13:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbXGHRml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 13:42:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbXGHRmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 13:42:40 -0400
Message-ID: <469121DA.6030600@redhat.com>
Date: Sun, 08 Jul 2007 10:41:46 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer	dereference
 - git-bisect result
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de> <20070708012016.455ce8d5.akpm@linux-foundation.org> <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de> <469119A3.6030409@redhat.com> <20070708173416.GG21668@ftp.linux.org.uk>
In-Reply-To: <20070708173416.GG21668@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> Like hell.  At the very least you want it to be opened for write.
> And even that is dubious, since "process has write access to file"
> is not quite the same thing as "somebody had given the process a
> descriptor opened for write".

But the real permissions tests are performed in notify_change.  I think
all this is consistent with how, for instance, fchmod works.  The
additional tests in fchmod which aren't here (IS_RDONLY and IS_APPEND)
would also apply to the case where a file name is given.  So, either the
code was inconsistent already are these tests are really not needed.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGkSHa2ijCOnn/RHQRAp0RAJ9ouvOd52feTPuFurxj8LzHZuGZsACgwxA8
ybEo1xmvakkKVenWc07PYhs=
=5DBy
-----END PGP SIGNATURE-----
