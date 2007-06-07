Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbXFGUEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbXFGUEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756647AbXFGUDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:03:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbXFGUDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:03:51 -0400
Message-ID: <4668644F.80708@redhat.com>
Date: Thu, 07 Jun 2007 13:02:23 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7> <20070606235906.72439d16@the-village.bc.nu> <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com> <20070607001932.35c9591c@the-village.bc.nu> <466741BD.20106@redhat.com> <20070607110432.73be7960@the-village.bc.nu> <B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com> <20070607151243.22caab9e.dada1@cosmosbay.com> <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Davide Libenzi wrote:
> Uli, would it be OK to rely only on base randomization and use a LIFO 
> instead? We have base randomization, plus LIFO does not mean strictly 
> sequential like legacy allocator, just more compatc and cache friendly.

If FIFO is slowing things down it's certainly OK to you LIFO.  If there
is wiggle room (i.e., choose between two descriptors without additional
cost) then taking advantage of this would be of advantage.  A policy
which enforces that only the last closed descriptor is not reused
immediately might might be enough.  Maybe that's too specific for
people's taste.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGaGRP2ijCOnn/RHQRAv2qAJ0WzyKvOPx01PviCp4L/mUmNaehtQCfdKF5
4Qc7Uj47zY8jdqUZf+Ht3gs=
=jRfN
-----END PGP SIGNATURE-----
