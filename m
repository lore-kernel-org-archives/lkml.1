Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbXHZR2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbXHZR2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 13:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbXHZR2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 13:28:47 -0400
Received: from smtp003.mail.ukl.yahoo.com ([217.12.11.34]:27568 "HELO
	smtp003.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752565AbXHZR2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 13:28:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Op9vlGlrESK0p+eWYVqXj+I+6QPEqgTZT+QzZaWx2vMNmo9H0Vjwl2t7AyOVFbUyP83fLxyuGNq6ecEbBf/1mVPoucCEhmcSTPn/z6WZ/+7ngIQI/P4P6zwW5aVYNd+jr/JWY2/gUqMJsQqw+DPrD0YQyfU3FVGfgfeZdN/+K08=  ;
X-YMail-OSG: 0EZDKBkVM1nes1Ai3T_Ifl6x1cxYk9gJVLcYLKR6zuKboguOE4zr7ikisU5QYYQeeWz7LGlZ2de4iTIkfxrUBkBB.JAYZ_f1X6yjxLDnbONS0qiZ
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 3/6] UML - Userspace files should call libc directly
Date: Sun, 26 Aug 2007 19:28:28 +0200
User-Agent: KMail/1.9.7
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070817194341.GA8754@c2.user-mode-linux.org>
In-Reply-To: <20070817194341.GA8754@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1308845.BBC9Uh8dEh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708261928.33082.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1308845.BBC9Uh8dEh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On venerd=EC 17 agosto 2007, Jeff Dike wrote:
> A number of files that were changed in the recent removal of tt mode
> are userspace files which call the os_* wrappers instead of calling
> libc directly.  A few other files were affected by this, through

> os_print_error has no remaining callers, so it is deleted.

Actually, os_print_error() (or some other interface to perror()) should be=
=20
reintroduced and used more for error messages (and also strsignal() should=
=20
be, for "Kernel mode signal N"). Problem debugging is hard, but there is no=
=20
reason make it harder (or rather, not to simplify it for users).

Btw, the inlined abs() call is not very nice; on the other hand, it's a sim=
ple=20
solution to make it robust, and we do not to be extra-optimal on these debu=
g=20
code paths.

Bye
=2D-=20
"Doh!" (cit.), I've made another mistake!
Paolo Giarrusso, aka Blaisorblade
Linux registered user n. 292729
http://www.user-mode-linux.org/~blaisorblade

--nextPart1308845.BBC9Uh8dEh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG0bhBqH9OHC+5NscRApv2AJ977THK+aBgVvnWB0zcitovTju7jgCglalY
3u+udiiweE+VZlpqtOYoOz4=
=9Msy
-----END PGP SIGNATURE-----

--nextPart1308845.BBC9Uh8dEh--
