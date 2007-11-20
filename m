Return-Path: <linux-kernel-owner+w=401wt.eu-S1761292AbXKTQRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761292AbXKTQRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 11:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759494AbXKTQRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 11:17:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759554AbXKTQRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 11:17:44 -0500
Message-ID: <47430871.7000306@redhat.com>
Date: Tue, 20 Nov 2007 08:16:49 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: dean gaudet <dean@arctic.org>
CC: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com> <20071119145224.31ee5242.dada1@cosmosbay.com> <4741A7DD.1030407@redhat.com> <20071119164329.5a580b84.dada1@cosmosbay.com> <4741B047.9080601@redhat.com> <20071119171455.c05793a0.dada1@cosmosbay.com> <20071119190826.GD12650@elte.hu> <alpine.DEB.0.99999.0711200609240.765@twinlark.arctic.org>
In-Reply-To: <alpine.DEB.0.99999.0711200609240.765@twinlark.arctic.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

dean gaudet wrote:
> as an application writer how do i access accept(2) with FD_CLOEXEC 
> functionality?  will glibc expose an accept2() with a flags param?

Not yet decided.  There is the alternative to extend the accept()
interface to have both interfaces:

  int accept(int, struct sockaddr *, socklen_t *);
and
  int accept(int, struct sockaddr *, socklen_t *, int);

We can do this with type safety even in C nowadays.


> if so... why don't we just have an accept2() syscall?

If you read the mails of my first submission you'll find that I
explained this.  I talked to Andrew and he favored new syscalls.  But
then I talked to Linus and he favored this approach.  Probably
especially because it can be used for syslets as well.  And it is less
code and data than introducing new syscalls.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHQwhx2ijCOnn/RHQRAnezAKCkFmGwlwDZjpfKTRSUN4yLIeGTkACgtMK/
OcHdIaR8wbp848D3GU2iNYQ=
=nTu9
-----END PGP SIGNATURE-----
