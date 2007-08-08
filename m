Return-Path: <linux-kernel-owner+w=401wt.eu-S964992AbXHHRch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964992AbXHHRch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760168AbXHHRc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:32:28 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33410 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbXHHRc1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:32:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] x86_64: ticket lock spinlock
In-Reply-To: Your message of "Wed, 08 Aug 2007 06:24:44 +0200."
             <20070808042444.GF11018@wotan.suse.de>
From: Valdis.Kletnieks@vt.edu
References: <20070808042234.GE11018@wotan.suse.de>
            <20070808042444.GF11018@wotan.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1186594318_5422P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Aug 2007 13:31:58 -0400
Message-ID: <20906.1186594318@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1186594318_5422P
Content-Type: text/plain; charset=us-ascii

On Wed, 08 Aug 2007 06:24:44 +0200, Nick Piggin said:

> After this, we can no longer spin on any locks with preempt enabled,
> and cannot reenable interrupts when spinning on an irq safe lock, because
> at that point we have already taken a ticket and the would deadlock if
> the same CPU tries to take the lock again.  These are hackish anyway: if
> the lock happens to be called under a preempt or interrupt disabled section,
> then it will just have the same latency problems. The real fix is to keep
> critical sections short, and ensure locks are reasonably fair (which this
> patch does).

Any guesstimates how often we do that sort of hackish thing currently, and
how hard it will be to debug each one?  "Deadlock if the same CPU tries to
take the lock again" is pretty easy to notice - are there more subtle failure
modes (larger loops of locks, etc)?

--==_Exmh_1186594318_5422P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGuf4OcC3lWbTT17ARAnzNAKCv9on7T8cbTFwQeDnPhZJZQoKCZQCg6nS4
A9DbYhG4UhU1m/to4O1YQD0=
=czI8
-----END PGP SIGNATURE-----

--==_Exmh_1186594318_5422P--
