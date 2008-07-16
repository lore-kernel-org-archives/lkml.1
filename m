Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbYGPUIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbYGPUIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYGPUI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:08:27 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54190 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYGPUI1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:08:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Cheradenine Zakalwe <sc.contact@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The state of linux security
In-Reply-To: Your message of "Wed, 16 Jul 2008 16:05:07 -0000."
             <67b4e5f30807160905n224a7808tf346dd4d506edd25@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <67b4e5f30807160905n224a7808tf346dd4d506edd25@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1216238905_16143P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 16 Jul 2008 16:08:25 -0400
Message-ID: <29361.1216238905@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1216238905_16143P
Content-Type: text/plain; charset=us-ascii

On Wed, 16 Jul 2008 16:05:07 -0000, Cheradenine Zakalwe said:
> This (for most people I'd guess) is far more dangerous than simply
> having their computers crash.  Also, I'd bet that many security bugs
> aren't triggerable under any normal workload.  If my machines have
> been running for 2 months why bother bringing them down in order to
> bugfix something that doesn't seem to affect them anyway?

You just convinced me that you've never *really* thought about it the way
a security professional would.

The key point you overlooked is that if it's only triggered under an abnormal
workload, the attacker can usually *arrange* said workload.  Need at least
10K processes for something to trigger, and there's usually only 400 on the
box? No problem, just fork-bomb yourself 9,600 processes and then run the
exploit.  You can only avoid the reboot for a bugfix if you can *prove*
that the setup condition(s) cannot possibly happen on the system unless
the security has already been breached (for example, "we don't need to
reboot to fix this because there is a system-wide process limit of 1,250
per user, there are only 7 userids on the system, and you need to already
be root to reset the limit").

Just woe unto you if you add an 8th userid before you reboot.. :)

> Obfuscating the risk people are exposed to means you have no real
> accountability and thus no incentive to not put so many security bugs
> there in the first place.  If other developers or users don't know how
> bad things are how can they make informed decisions about development
> processes or where they can afford to deploy linux?

If I wrote up a 'DoS Advisory' for every time I manage to find another way
to oops or panic a -mm kernel, I'd probably have a a very large pile of
advisories.  However, the fact that I managed to oops or panic their software
has almost always been incentive enough for the maintainers to fix it, there's
no need to add more.

> know what I've been exposed to and for how long.  From the looks of
> what the paxteam has been saying, it seems linux security is pretty
> bad and has been getting worse.  This must be in no small part to you
> putting your head in the sand, sticking your fingers in your ears and
> going "lalalalala".

It should however be noted that a number of people who take security seriously
think the paxteam is totally out to lunch with some of their ideas.  The last
time I looked at their "security patch" (admittedly, that was back around
2.6.17 or so), a large chunk of it was pretty much cargo-cult security that
addressed specific gotcha's that have in the past been used (like symlink races
in /tmp), rather than address the *actual* security issue (for instance,
"compilers shouldn't overwrite system config files") in a comprehensive manner.
A big chunk of the rest was their version of execshield, which required
cutting the available address space in half (a big issue for 32-bit archs).
The telling point is that they didn't see this as being possibly a problem for
some users.

> If it turns out that the current development model has produced too
> many security problems then the development model must change.

You've apparently overlooked the fact that although there are probably still
a lot of security bugs in the kernel, an attacker is *always* going to
approach the path of least resistance. No sense in looking for a kernel
exploit, when it's probably a lot easier to find one you can package up
in Firefox, or OpenOffice, or the pcre library, or any of the zillions
of other packages that get security advisories all the time...

And tell me - how many is "too many"?  Who gets to judge?  You don't like
the way Linus and Andrew handle it, there's this guy Theo, you can go talk
to him....

> One more thing I'd like to throw out there on the issue of
> accountability is this:  How do I know that some developers have not
> been paid to specifically introduce some obscure security flaw?

Which is more likely - that somebody will manage to sneak a malicious patch
past the relevant subsystem maintainer, and Andrew Morton, *and* Linus,
without anybody being the wiser, or that they'll drop their malicious code
into one of the *other* 5,932 packages currently in Fedora Rawhide?

Go read up on the Underhanded C contest. Then go read Ken Thompson's Turing
Award Lecture "On Trusting Trust" - and then go see if anybody's audited the
gcc tree lately, while thinking about what Thompson wrote.  Or audited
the *other 5,931 packages besides the kernel and gcc...

(Incidentally, the "unnamed Air Force Document" that Ken mentions is none
other than Karger&Schell's paper on Multics security - also a good read,
as it discusses a *lot* of attack methods you may not have really thought
about in detail...)






--==_Exmh_1216238905_16143P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIflU5cC3lWbTT17ARAuCAAJ4loaKEAWiu2G0YhxKM2Wl/qTEmowCgqt93
sHSgbokbEZ+q8jkNLDcEn18=
=t103
-----END PGP SIGNATURE-----

--==_Exmh_1216238905_16143P--
