Return-Path: <linux-kernel-owner+w=401wt.eu-S1753053AbYHMP4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbYHMP4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 11:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYHMP4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 11:56:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbYHMP4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 11:56:35 -0400
Message-ID: <48A303EE.8070002@redhat.com>
Date: Wed, 13 Aug 2008 08:55:26 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arjan van de Ven <arjan@infradead.org>, akpm@linux-foundation.org,
       hugh@veritas.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       briangrant@google.com, cgd@google.com, mbligh@google.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: pthread_create() slow for many threads; also time to revisit
 64b context switch optimization?
References: <af8810200808121736q76640cc1kb814385072fe9b29@mail.gmail.com> <af8810200808121745h596c175bk348d0aaeeb9bcb45@mail.gmail.com> <20080813104445.GA24632@elte.hu> <20080813063533.444c650d@infradead.org> <48A2EE07.3040003@redhat.com> <20080813142529.GB21129@elte.hu> <48A2F157.7000303@redhat.com> <20080813151007.GA8780@elte.hu> <48A2FC17.9070302@redhat.com> <20080813154043.GA11886@elte.hu>
In-Reply-To: <20080813154043.GA11886@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ingo Molnar wrote:
> Btw., can you see any problems with option #1: simply removing MAP_32BIT 
> from 64-bit stack allocations in glibc unconditionally?

Yes, as we both agree, there are still such machines out there.

The real problem is: what to do if somebody complains?  If we would have
the extra flag such people could be accommodated.  If there is no such
flag then distributions cannot just add the flag (it's part of the
kernel API) and they would be caught between a rock and a hard place.
Option #2 provides the biggest flexibility.

I upstream kernel truly doesn't care about such machines anymore there
are two options:

- - really do nothing at all

- - at least reserve a flag in case somebody wants/has to implement option
  #2

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkijA+4ACgkQ2ijCOnn/RHRhLQCdGNvwikwY4hMHBuYUP4WDqsy3
cfcAn2hrN1MoOkN3UIC4iSUCtqD2Yl6W
=yG5T
-----END PGP SIGNATURE-----
