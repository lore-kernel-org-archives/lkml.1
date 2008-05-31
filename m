Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYEaEin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYEaEin (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 00:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYEaEif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 00:38:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbYEaEie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 00:38:34 -0400
Message-ID: <4840D63F.2090407@redhat.com>
Date: Fri, 30 May 2008 21:38:23 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
References: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com> <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> Is it possible? I dunno.

Once again not without limitations which are too low.  The main problem
is that there is far more information needed on the reader side.  There
are two counters and a number of bits for state information.  Which
means the counters can be at most 14 bits in size.

A counter this low also means I cannot unconditionally increment them
(since there can be more than 2^14 threads sharing one page).  This
means you get in the cache line race I described in the last mail.  You
first have to load a word and then perform a the write operation while
at the same time other threads competing with you for the same cache line.


> I personally suspect it is. I also suspect you 
> didn't even try.

I have to disappoint you.  I thought of that and had to reject it.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhA1j8ACgkQ2ijCOnn/RHTUXQCgnkUy6PNSuUI4O6BD4abxqqKr
PzMAn2qcvrXGM4qrhOytk1Yie0BsMeVa
=zvxZ
-----END PGP SIGNATURE-----
