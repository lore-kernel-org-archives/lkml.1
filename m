Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbYEaDPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbYEaDPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 23:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYEaDOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 23:14:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbYEaDOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 23:14:48 -0400
Message-ID: <4840C29B.6030507@redhat.com>
Date: Fri, 30 May 2008 20:14:35 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
References: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> We've had a 32-bit rwsemaphore in the kernel for a *long* time.

You misread what I wrote.

Semaphores are fine.  The problem are reader/writer locks where we need
three counters and some flags.  It is absolutely not acceptable to limit
the number of threads to 512 to make this fit.


> I think it's totally stupid for glibc to even *try* to do something like 
> this, since almost nobody will have a kernel with 64-bit futex support for 
> a long time in the wild anyway. So you need to support a 32-bit semaphore 
> in practice, and it's been done before.

Again, misread.  This is not functionality which is not available.
Semaphores are *of course* fine with 32 bits.  And there is a
reader/writer lock implementation.  It is just very slow compared to
what is possible.  The transition between systems miss the 64-bit
support and those which have it is completely transparent.  The same
glibc binary will work for both.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhAwpsACgkQ2ijCOnn/RHS7PACdGvdgI9pv+IcsSPkXPVwFJ5ZF
YNQAn01fm1wEc4EI/fwOVuM57XtCy9Dq
=LcpJ
-----END PGP SIGNATURE-----
