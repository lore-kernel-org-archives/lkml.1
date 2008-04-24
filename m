Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbYDXOud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbYDXOud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYDXOuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:50:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbYDXOuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:50:21 -0400
Message-ID: <48109DFB.900@redhat.com>
Date: Thu, 24 Apr 2008 07:49:31 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       michael.kerrisk@gmail.com, linux-man@vger.kernel.org
Subject: Re: [PATCH] alternative to sys_indirect, part 1
References: <200804240403.m3O43us8028699@devserv.devel.redhat.com>	 <20080424112514.055d8071@the-village.bc.nu> <517f3f820804240534r3bbbdc52s52a6dfe3f2d14b7f@mail.gmail.com>
In-Reply-To: <517f3f820804240534r3bbbdc52s52a6dfe3f2d14b7f@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Michael Kerrisk wrote:
> * dup2() -- use fcntl(F_DUPFD) instead

Wrong.  You cannot implement dup2 with fcntl since the latter won't use
a file descriptor which is already in use.


> So the alternative to sys_indirect(), at least for the purpose of
> O_CLOEXEC and similar, would be to create 5 new system calls (or six,
> if one finds the signalfd() hack too ugly, which perhaps it is; or 7
> if one doesn't like Alan's suggestion for socket()

Without changing the socket interfaces (plural, socketpair) there would
have to be 7 new syscalls, with changing socket* to an IMO cleaner
interface 9.


Or we just add sys_indirect (which is also usable for other syscall
extensions, not just the CLOEXEC stuff) and let userlevel (i.e., me)
worry about adding new interfaces to libc.  As you can see, for the more
recent interfaces like signalfd I have already added an additional
parameter so the number of interface changes would be reduced.

Somebody please make a call and then let's go on with life.  I don't
care much either way anymore.  I do hope nobody thinks this is an issue
which can be completely ignored (see, e.g., the bug I pointed to the
other day).

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIEJ372ijCOnn/RHQRAorwAJ4u78MYFrJbPqcqW1fPae2liLxxhwCfa7e7
r2vc7FnEpzyJmqEKU6aCd5E=
=EG3n
-----END PGP SIGNATURE-----
