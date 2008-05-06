Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYEFC6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYEFC6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 22:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYEFC6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 22:58:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbYEFC6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 22:58:32 -0400
Message-ID: <481FC94C.8090203@redhat.com>
Date: Mon, 05 May 2008 19:58:20 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davidel@xmailserver.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 02/18] flag parameters: socket and socketpair
References: <200805050342.m453gktl029817@devserv.devel.redhat.com>	<20080505185850.789d870a.akpm@linux-foundation.org>	<481FC38A.6070805@redhat.com> <20080505194221.4349418b.akpm@linux-foundation.org>
In-Reply-To: <20080505194221.4349418b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> Sorry to sound slow, but what do we gain from all this?  Your covering
> description was heavy in references to some earlier discussion to which I
> obviously paid little attention and now I'm lost.

What we gain is that the only change for a new flag is a new entry in
the appropriate table.  The reference to non-sequential file descriptors
refers to

  http://lwn.net/Articles/236724/

Not this specific incarnation of the functionality, but something like this.

A few more points:

- - for the socket functions we can share the table

- - in most cases the loop isn't even entered since the flag value is
  zero.  In any case, the loop is ended once all flags have been mapped

- - in case this code is really called often, than the code is in the
  cache and it is shorter than each of possible multiple copies of the
  unrolled loop


Anyway, we spent already far too much time on this.  If you want to see
it changed tell me.  It's really not important.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIH8lM2ijCOnn/RHQRAta6AKC39ty8FdiRYjRxxHDoG2T/N1hhywCeKPcZ
L/iDtbf9DozMmEfoLY8nlbk=
=B+YO
-----END PGP SIGNATURE-----
