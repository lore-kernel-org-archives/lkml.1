Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbYCMCUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbYCMCUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 22:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYCMCTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 22:19:55 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39806 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYCMCTy (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 22:19:54 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
In-Reply-To: Your message of "Wed, 12 Mar 2008 00:32:27 PDT."
             <20080312003227.a94580e8.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu>
            <20080312003227.a94580e8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1205374751_3120P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Mar 2008 22:19:11 -0400
Message-ID: <4351.1205374751@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1205374751_3120P
Content-Type: text/plain; charset=us-ascii

On Wed, 12 Mar 2008 00:32:27 PDT, Andrew Morton said:
> On Thu, 06 Mar 2008 22:58:45 -0500 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Tue, 04 Mar 2008 01:19:28 PST, Andrew Morton said:
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/
2.6.25-rc3-mm1/
> > 
> > Dell Latitude D820, x86_64, Core2 Duo T7200
> > 
> > 'shutdown -h' blows up at the very end. shutdown -r works OK.
> 
> Did rc5-mm1 fix this?

Nope, still blows up with exactly the same traceback.

I may have to try again to figure out how to bisect the git-x86 tree - Ingo
send me a pointer to his git-x86 cheat sheet, I looked at it but I couldn't
figure out how to tell 'git bisect' that the starting good spot was "whatever
corresponded to the git-x86 patch in 24-rc8-mm1" and bad was "25-rc3-mm1". I
tried using the first commit ID listed in the patch, but that gave me this:

(looking at first few lines of the git-x86.patch in the 25-rc3-mm1 broken-out):

commit fa70e201463a7f3d86b995249e57a8e27b31b5f8
Author: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Date:   Sun Feb 24 11:57:22 2008 +0100

but then:

% git bisect bad fa70e201463a7f3d86b995249e57a8e27b31b5f8
fatal: Needed a single revision
Bad rev input: fa70e201463a7f3d86b995249e57a8e27b31b5f8

And I didn't see any release tags in the x86 git tree that I could specify
either.

(Once I get the good and bad markers set, it "should be easy" - I've managed
to git-bisect through Linus's git tree before, but that was always easy
because "bad" was HEAD and "good" had a nice v2.6.2mumble-rcN tag to specify...


--==_Exmh_1205374751_3120P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH2I8fcC3lWbTT17ARAgqRAKDki9Ea7T/XTZurKfGAZhTYN3NbNwCdE3Jc
xD0VokuJAJBkq8zWTK2kGo8=
=n1Jd
-----END PGP SIGNATURE-----

--==_Exmh_1205374751_3120P--
