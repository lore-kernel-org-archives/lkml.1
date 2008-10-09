Return-Path: <linux-kernel-owner+w=401wt.eu-S1758405AbYJIGxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405AbYJIGxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYJIGxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:53:42 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35142 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbYJIGxl (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:53:41 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: [PATCH] documentation: explain memory barriers
In-Reply-To: Your message of "Fri, 10 Oct 2008 04:35:47 +1100."
             <200810100435.48010.nickpiggin@yahoo.com.au>
From: Valdis.Kletnieks@vt.edu
References: <20080911101616.GA24064@agk.fab.redhat.com> <20081008181223.6954c7b2.randy.dunlap@oracle.com> <8119.1223517003@turing-police.cc.vt.edu>
            <200810100435.48010.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1223535137_7177P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Oct 2008 02:52:18 -0400
Message-ID: <36155.1223535138@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1223535137_7177P
Content-Type: text/plain; charset=us-ascii

On Fri, 10 Oct 2008 04:35:47 +1100, Nick Piggin said:
> On Thursday 09 October 2008 12:50, Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 08 Oct 2008 18:12:23 PDT, Randy Dunlap said:
> > > +
> > > +24: All memory barriers {e.g., barrier(), rmb(), wmb()} need a comment
> > > in the +    source code that explains the logic of what they are doing
> > > and why.
> >
> > "what they are doing" will almost always be "flush value to RAM" or
> > similar.
> 
> Memory barriers don't flush anything anywhere.

That's what I get for commenting on stuff when I'm into a 40-hour week by
Wednesday. :)

I was speaking of the generic programmer who does stuff like:

	x = 10; /* set x to 10 */ 

for "what they are doing".  You know the type. ;)

"flush value to RAM", "force memory barrier operation", and I think I've seen
a few kzalloc()'s that have "allocate zero'ed memory" on them. "what they are
doing" is usually not worth writing down, but being verbose for the *why*
is almost always good, especially for things like memory barriers that
almost nobody can get their brains wrapped around (how many flame-fests per
year do we have about "volatile"? ;)

>  /*
>   * If we don't do a wmb() here, the store to the RBFROBNIZ,
>   * above, might reach the device before the store X, below.
>   * 
>   * If that happens, then the XU293  card will get confused
>   * and wedge the hardware...
>   */
>   wmb();
> 
> If you don't comment like that, then how does the reader know that the wmb
> is not *also* supposed to order the store with any other of the limitless
> subsequent stores until the next memory ordering operation? Or any of the
> previous stores since the last one?

Even better (as I missed the "also supposed to know" case).  My general point
was that a concrete example would improve Randy's original patch by showing
what sort of things should be in the comment, and your correction pointed
out *why* a concrete example was needed. ;)


--==_Exmh_1223535137_7177P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI7aohcC3lWbTT17ARApnfAJ9VYSE7fIOJInHBCy/1b+9hrmmqggCfRIyv
p7ewgHWdw5DSu08DW9GqgFs=
=njM0
-----END PGP SIGNATURE-----

--==_Exmh_1223535137_7177P--
