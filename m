Return-Path: <linux-kernel-owner+w=401wt.eu-S1755641AbXKTD3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbXKTD3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 22:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755496AbXKTD3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 22:29:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054AbXKTD3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 22:29:23 -0500
Message-ID: <47425470.2000608@redhat.com>
Date: Mon, 19 Nov 2007 19:28:48 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv3 0/4] sys_indirect system call
References: <200711170531.lAH5VaXR025225@devserv.devel.redhat.com> <473FED5F.2010303@zytor.com> <474007B3.30205@redhat.com> <47409484.8040304@zytor.com>
In-Reply-To: <47409484.8040304@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

H. Peter Anvin wrote:
> What bothers me about the sys_indirect approach is that it will get
> increasingly expensive as time goes on, and in doing so it does a
> user-space memory reference, which are extra expensive.  The extra table
> can be colocated with the main table (a structure, in effect) so they'll
> share the same cache line.

You assume that using sys_indirect will be the norm.  It won't.  We
mustn't design system calls deliberately wrong so that they require the
indirection.

Beside, if the number of syscalls which has to be handled this way grows
we can use something more efficient for large numbers of test than a
switch statement.  It could even be a word next to the system call table.

But I still don't see that the magic encoding is a valid solution, it
doesn't address the limited parameter number.  Plus, using sys_indirect
could in future be used to transport entire parameters (like a sigset_t)
along with other information, thereby saving individual copy operations.

I think the sys_indirect approach is the way forward.  I'll submit a
last version of the patch in a bit.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHQlRw2ijCOnn/RHQRApifAKDE1nZqRbm4cJxbhobBb7jCx1T00QCgiSa0
EXKjL2Gwu3atSLSD+Rb4yO4=
=6ZGt
-----END PGP SIGNATURE-----
