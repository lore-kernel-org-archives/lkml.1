Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbXFIRLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbXFIRLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 13:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbXFIRKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 13:10:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840AbXFIRKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 13:10:52 -0400
Message-ID: <466ADEAB.7080202@redhat.com>
Date: Sat, 09 Jun 2007 10:08:59 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <4669A674.4080309@redhat.com> <alpine.LFD.0.98.0706081206430.4205@woody.linux-foundation.org> <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org> <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com> <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com> <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com> <20070609165454.GE4095@ftp.linux.org.uk>
In-Reply-To: <20070609165454.GE4095@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> That's simply not true.  On the current kernel nothing stops you from e.g.
> picking a random number and using F_DUPFD.

Of course there are things stopping one from doing this (aside from the
kernel not allowing this in the moment at all since the highest fd
number is limited severely):

- - this scheme would only be use if it would be possible to have
completely random descriptor values.  But what has been said here
already is that this is too costly.  Hence the approach to randomize
only the base value.

- - there are two interface to use: open + fcntl.  This is racy.  And
don't tell me this doesn't matter.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGat6r2ijCOnn/RHQRAiatAKCs7RLZmpgAU5NyT58c8ueJum4fgwCgjqP0
jPVCCWEdIHVQS05oIjdsZYs=
=7UX+
-----END PGP SIGNATURE-----
