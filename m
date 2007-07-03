Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbXGCP2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbXGCP2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbXGCP2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:28:45 -0400
Received: from smtp003.mail.ukl.yahoo.com ([217.12.11.34]:42837 "HELO
	smtp003.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755547AbXGCP2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:28:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=qfSnj7meiRUJqjLOt4cqKhNFNSsD19w2HoKZCH7khwPRpUP8YGAMonGxPuZLkyPTF7K5vVoaB6N+bsjp9Bivfe0y0d/wIXIfWAcX0FJ/QfakzMzc57fL2CYzbhohlbgZvwO/Zj+0J4tKdNSNDJ6mzUyxuw7bx5whvv2shAS+LbQ=  ;
X-YMail-OSG: C6zgyZwVM1kegEJE43n3n7._Pd6ipXTgsG3p1HLiAc6ZDJeGU9V2ccJCdru44X7ifhCJFYokQjzsGXJ60ZllSdeXMG93U2cGDxUmiKc4K3huzERJ
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 4/5] UML - Simplify helper stack handling
Date: Tue, 3 Jul 2007 17:28:30 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Dike <jdike@addtoit.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070614202655.GA9647@c2.user-mode-linux.org> <20070627233701.8e53f3cb.akpm@linux-foundation.org>
In-Reply-To: <20070627233701.8e53f3cb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1472843.a5S91qz8GL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707031728.36472.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1472843.a5S91qz8GL
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On gioved=EC 28 giugno 2007, Andrew Morton wrote:
> So I'm running the generic version of this on i386 with 8k stacks (below),
> with a quick LTP run.
>
> Holy cow, either we use a _lot_ of stack or these numbers are off:
>
> vmm:/home/akpm> dmesg -s 1000000|grep 'bytes left'
> khelper used greatest stack depth: 7176 bytes left
> khelper used greatest stack depth: 7064 bytes left
> khelper used greatest stack depth: 6840 bytes left
> khelper used greatest stack depth: 6812 bytes left
> hostname used greatest stack depth: 6636 bytes left
> uname used greatest stack depth: 6592 bytes left
> uname used greatest stack depth: 6284 bytes left
> hotplug used greatest stack depth: 5568 bytes left
> rpc.nfsd used greatest stack depth: 5136 bytes left
> chown02 used greatest stack depth: 4956 bytes left
> fchown01 used greatest stack depth: 4892 bytes left

> That's the sum of process stack and interrupt stack, but I doubt if this
> little box is using much interrupt stack space.
>
> No wonder people are still getting stack overflows with 4k stacks...

=46irst, those numbers pretend to be _unused_ stack space.

Well, UML tends to use more stack space than the rest of kernel. Apart it h=
as=20
a bit more layering (even if less than in the past), we must use libc's=20
function too, and they're not written to be executed on an 8k stack.

We've reimplemented libc's printf() in terms of kernel sprintf() because it=
=20
used 32K of stack.
=2D-=20
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade

--nextPart1472843.a5S91qz8GL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGimskqH9OHC+5NscRAoa3AJ0aoVZAsSCUack5plKhHUgAuIP1cgCfVkUo
AYs4QvjRsHgXU75C5JT9SDI=
=YpvS
-----END PGP SIGNATURE-----

--nextPart1472843.a5S91qz8GL--
