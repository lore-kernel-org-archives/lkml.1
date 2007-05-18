Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbXERRth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbXERRth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbXERRt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:49:28 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43659 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874AbXERRt1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:49:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Anand Jahagirdar <anandjigar@gmail.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>, linux-kernel@vger.kernel.org,
       Coywolf Qi Hunt <coywolf@sosdg.org>
Subject: Re: Fork Bombing Attack
In-Reply-To: Your message of "Fri, 18 May 2007 22:52:15 +0530."
             <25ae38200705181022l35e0b364p98fc39e5739612b@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <25ae38200705170745t4a80e7eer413b3c2bb0c5a327@mail.gmail.com> <4051.1179414105@turing-police.cc.vt.edu> <25ae38200705180413s741cac1bw9fe0dc57cecc2a91@mail.gmail.com> <1865922a0705180619g2a997c2ch5d13be3e023630e0@mail.gmail.com>
            <25ae38200705181022l35e0b364p98fc39e5739612b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1179510556_4061P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 18 May 2007 13:49:16 -0400
Message-ID: <11733.1179510556@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1179510556_4061P
Content-Type: text/plain; charset=us-ascii

On Fri, 18 May 2007 22:52:15 +0530, Anand Jahagirdar said:

> output is 8050. when root or any other user changes ulimit by typing
> "ulimit -u value",.ulimit value is changed for that session and not
> permantely.

Right.  That value is only applied to that process, and its children. Or more
correctly, those children that don't themselves change the value again - the
distinction is crucial in this case.

>             actually ulimit should help to prevent fork bombing attack

Right. It *helps* prevent it.  But it isn't by itself a total cure.

> but it wont and fork bombing attack still take down the machine having
> latest linux distributions.
> 
> will any please tell me why this is so?

Because it only requires *one* process not subject to the ulimit, or a group of
cooperating processes subject to the limit, to bypass that particular
protection.

ulimits are a fairly good and inexpensive way to guard against *accidental*
runaway processes from trashing the system.  They're at best a 95% solution,
and won't stop *every* case.

Consider - you determine that a small fork bomb that launches more than
7,500 processes will kill your system, so you set the ulimit to 7000.

I, as an attacker, am using a compromised userid on your system (think about
it for a moment - if I'm a *legit* user of the system, and use my own userid
for it, I'm a self-limiting problem, as I can only do it once, after which I
have to worry about getting fired, possible legal/criminal action, etc).

1) Fork bomb 6,500 processes - and have each one check the 'ulimit -m' value
and proceed to malloc() and then dirty that amount minus 5 or 10 megabytes.

2) Instead of using *one* compromised userid, I use two, and launch 6,000
processes from each...

3) Lots of *other* possibilities.....

--==_Exmh_1179510556_4061P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGTecccC3lWbTT17ARAsu7AJ4yTl6bvA2UhziYQkEoxxStQlRowgCfZEMG
mikQT0IRzSrL2zTJ4NfrvsA=
=cbps
-----END PGP SIGNATURE-----

--==_Exmh_1179510556_4061P--
