Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbXDDWGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbXDDWGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXDDWGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:06:07 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53509 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbXDDWGG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:06:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Andrea Arcangeli <andrea@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
In-Reply-To: Your message of "Wed, 04 Apr 2007 08:35:30 PDT."
             <Pine.LNX.4.64.0704040830500.6730@woody.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070329075805.GA6852@wotan.suse.de> <Pine.LNX.4.64.0703291324090.21577@blonde.wat.veritas.com> <20070330024048.GG19407@wotan.suse.de> <20070404033726.GE18507@wotan.suse.de>
            <Pine.LNX.4.64.0704040830500.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175724355_4061P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Apr 2007 18:05:55 -0400
Message-ID: <6701.1175724355@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175724355_4061P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 Apr 2007 08:35:30 PDT, Linus Torvalds said:

> Although I don't know how much -mm will do for it. There is certainly not 
> going to be any correctness problems, afaik, just *performance* problems. 
> Does anybody do any performance testing on -mm?

I have to admit I don't do anything more definite than "wow, this goes oink"...

> That's an example of an app that actually cares about the page allocation 
> (or, in this case, the lack there-of). Not an important one, but maybe 
> there are important ones that care?

I'd not be surprised if there's sparse-matrix code out there that wants to
malloc a *huge* array (like a 1025x1025 array of numbers) that then only
actually *writes* to several hundred locations, and relies on the fact that
all the untouched pages read back all-zeros.  Of course, said code is probably
buggy because it doesn't zero the whole thing because you don't usually know
if some other function already scribbled on that heap page.

This would probably be more interesting if we had a userspace API for
"Give me a metric buttload of zero page frames" that malloc() and friends
could leverage.....

--==_Exmh_1175724355_4061P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGFCFDcC3lWbTT17ARAkaMAKC1t7k+Vp8jNmXti0Lo1j4JVvGhiACgi4Ve
Px3K6ou1dKC8hS9yVlYeqww=
=RAk6
-----END PGP SIGNATURE-----

--==_Exmh_1175724355_4061P--
