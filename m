Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbXFCUrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbXFCUrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbXFCUqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:46:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbXFCUqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:46:37 -0400
Message-ID: <4663289D.5030109@redhat.com>
Date: Sun, 03 Jun 2007 13:46:21 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
References: <send-serie.davidel@xmailserver.org.24319.1180825146.2> <4663067C.9050002@redhat.com> <Pine.LNX.4.64.0706031127220.13247@alien.or.mcafeemobile.com> <466319DB.80800@redhat.com> <Pine.LNX.4.64.0706031311490.13247@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0706031311490.13247@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
>> If randomizing each allocator is too expensive then randomize at the
>> very least the number of the first descriptor you give out.
> 
> Can you tell me how this can be a problem, and in which way making a 
> random thing would help?

In attacking an application every bit of known data can be used in an
exploit.  Be it something as simple as having a predetermined value at a
certain point in the program since it loaded a file descriptor into a
register.

But what I'm mostly thinking about is the case where I/O could be
redirected.  The intruding program could call dup2() and suddenly the
program wanting to write a password to disk could be directed to send it
over a socket.  One could imagine countless such attacks.

I don't say such an attack exists today.  But this is no reason to not
implement these extra security measures.  The cost of a randomized star
base (offset from 2^30) should be zero.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGYyid2ijCOnn/RHQRAjRoAJ9XsAazZtc9V3AxaPjiNMjK8jPUZgCdG/Eg
KPug5Sq9REHd6H3AR0ax2aU=
=9iUM
-----END PGP SIGNATURE-----
