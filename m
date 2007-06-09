Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbXFIQ16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbXFIQ16 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 12:27:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbXFIQ1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 12:27:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbXFIQ1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 12:27:50 -0400
Message-ID: <466AD4BA.80407@redhat.com>
Date: Sat, 09 Jun 2007 09:26:34 -0700
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
References: <4669A351.4010403@redhat.com> <20070608184650.GA4095@ftp.linux.org.uk> <4669A674.4080309@redhat.com> <alpine.LFD.0.98.0706081206430.4205@woody.linux-foundation.org> <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org> <20070609003622.GB4095@ftp.linux.org.uk> <466A0020.50406@redhat.com> <20070609014140.GC4095@ftp.linux.org.uk> <466A0BFB.3070908@redhat.com> <20070609151521.GD4095@ftp.linux.org.uk>
In-Reply-To: <20070609151521.GD4095@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> So which code is supposed to do that open/write in your example?  Library?
> Unmodified application?  Application specifically modified to make *that*
> open() randomized?

Why should that matter?  All of the above.  Any piece of code can of
course choose to not be safe but it should have the opportunity to be,
too.  Currently that's not the case.  With an O_NONSEQFD flag to open it
would be trivial to change any code.  Or one can introduce a new set of
userlevel interfaces to create and write new files which then can do
even more.

In whatever way you look at it, there currently is a problem which
cannot be solved except with truly horrible, horrible hack (open N
descriptors and randomly select one to use; yep, horrible, I said so).

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGatS62ijCOnn/RHQRAqcfAJ9vMc6GUFxlgxOZ9rhAcTV9N95kUACguUpq
ER8Y64pIp80NHiMHXwMxxK0=
=ytei
-----END PGP SIGNATURE-----
