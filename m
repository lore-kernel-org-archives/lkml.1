Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbYCVDLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbYCVDLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYCVDLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:11:37 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57636 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYCVDLg (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:11:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Hoo-fscking-ray - (was Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
In-Reply-To: Your message of "Fri, 21 Mar 2008 21:12:11 BST."
             <20080321201211.GA21609@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu> <20080312003227.a94580e8.akpm@linux-foundation.org> <4351.1205374751@turing-police.cc.vt.edu> <20080321134128.GO27245@elte.hu> <3343.1206128318@turing-police.cc.vt.edu> <20080321195813.GC16179@elte.hu> <4945.1206129958@turing-police.cc.vt.edu>
            <20080321201211.GA21609@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1206155478_2925P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Mar 2008 23:11:18 -0400
Message-ID: <3370.1206155478@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1206155478_2925P
Content-Type: text/plain; charset=us-ascii

On Fri, 21 Mar 2008 21:12:11 BST, Ingo Molnar said:
> 
> * Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> 
> > On Fri, 21 Mar 2008 20:58:13 BST, Ingo Molnar said:
> > 
> > > no, we frequently regenerate the x86.git tree so the dates have little 
> > > relevance. If for any particular pull, x86/base is good and x86/latest 
> > > is bad, then the bug is somewhere in those 200-300 patches inbetween. 
> > > They are lined up linearly so should be perfectly bisectable.
> > 
> > OK, off to go try the last few bisects then...
> 
> well ... your git bisection log does look suspiciously 'good', so 
> something is wrong thee i think :-(
> 
> the chance to get 8 'good' bisection points in a row is 1:256. OTOH, the 
> freshest x86 patches are always at the 'end' of the queue - which are 
> also the ones most likely to break anything.

On the other hand, this was broken in 25-rc3-mm1, so it's not a "fresh"
patch...

> Are you sure the x86/base point is indeed 'good'? You can check it via:
> 
>  git-checkout -b tmp x86/base
> 
> and build+boot it.

Did that, and it's good (as in 'shutdown -h now' powers off rather than BUG and
hanging).

"You're at Witt's End" -- Adventure, c. 1978

OK.. so far I've got:

25-rc3-mm1 is bad
25-rc5-mm1 is bad, and bisected down to git-x86.patch
x86/base as pulled last week is good
bisected to within the last 9 entries of x86/latest is good.

So I can't seem to replicate it using the git-x86 tree, but bisecting -mm
implicates it.  How very strange.

I even went and pulled Andrew's mmotm pile as of this afternoon, and got that
to built after having to heave only a dozen patches over the side and one or
two hand-fixes of patches - and *that* one is good too.

So I'm thinking that it was some "bump in the night" that was broken in the
x86 tree when Andrew pulled it for 25-rc5-mm1, but was fixed by the time I
pulled it a few days later to start git-bisecting it.

Given that -mmotm isn't showing the problem, I'm having a hard time coming
up with enthusiasm to keep chasing it.  If I see it happen again in a -mm
or Linus kernel, I'll restart the chase then....



--==_Exmh_1206155478_2925P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH5HjWcC3lWbTT17ARApZtAKDTfayZsU8cY5Qh4hdCzrZ7WHBM+QCgyRDY
Gk7OKaPH26DlswWkVNd6U/Y=
=Ypv0
-----END PGP SIGNATURE-----

--==_Exmh_1206155478_2925P--
