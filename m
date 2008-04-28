Return-Path: <linux-kernel-owner+w=401wt.eu-S934674AbYD1OOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674AbYD1OOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 10:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933315AbYD1ONu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 10:13:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932454AbYD1ONt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 10:13:49 -0400
Message-ID: <4815DB8B.7060606@redhat.com>
Date: Mon, 28 Apr 2008 07:13:31 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] paccept, socket, socketpair w/flags
References: <200804262224.m3QMOP3a006296@devserv.devel.redhat.com> <517f3f820804280252h753c8cacv7fe9580f96dcf1ce@mail.gmail.com>
In-Reply-To: <517f3f820804280252h753c8cacv7fe9580f96dcf1ce@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Michael Kerrisk wrote:
> This is ugly.  Why invent a diffent set of flags here.  I agree with
> your earlier statement that new syscalls would be cleaner.

Don't lay words in my mouth.  I do think that different flags are
needed.  The name of the flag must indicate what it is for and you don't
want to mix flags with different prefixes for the same flags parameter.
 Not introducing separate flags would mean all the functions would have
to accept the same set of flags which will sooner or later create
problems.  I really don't see the problem here.


> then *please* let's go the hwole way cleanly, and have new syscalls
> also for socketpair() and socket(), and make all of the new syscalls
> use the same flags.

Hell, no, that's worse than everything else proposed.  We don't have the
luxury to have a separate parameter to indicate close-on-exec or not.
For efficiency it has to be a multi-purpose flags parameter and the
flags each syscall takes are different since the functionality is different.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIFduL2ijCOnn/RHQRAhV5AKDK924ANx9HO5qDbPyB6m4uegbABACgpkFA
AOO7/HaCFNe/GNmNlEJXBag=
=18Bc
-----END PGP SIGNATURE-----
