Return-Path: <linux-kernel-owner+w=401wt.eu-S1763945AbXFCEw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763945AbXFCEw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 00:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbXFCEwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 00:52:49 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:53211 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbXFCEws (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 00:52:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: david@lang.hm
Cc: David Wagner <daw-usenet@taverner.cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
In-Reply-To: Your message of "Sat, 02 Jun 2007 12:51:27 PDT."
             <Pine.LNX.4.64.0706021235590.954@asgard.lang.hm>
From: Valdis.Kletnieks@vt.edu
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <f3il25$pcp$1@taverner.cs.berkeley.edu> <20070524144726.GB3920@ucw.cz> <12508.1180719875@turing-police.cc.vt.edu> <f3qrp6$ftn$1@taverner.cs.berkeley.edu> <14604.1180770021@turing-police.cc.vt.edu> <Pine.LNX.4.64.0706020723030.954@asgard.lang.hm> <6419.1180811687@turing-police.cc.vt.edu>
            <Pine.LNX.4.64.0706021235590.954@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180846357_3873P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 03 Jun 2007 00:52:37 -0400
Message-ID: <17681.1180846357@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180846357_3873P
Content-Type: text/plain; charset=us-ascii

On Sat, 02 Jun 2007 12:51:27 PDT, david@lang.hm said:

> this is Security 101 (or even more basic), if you grant a program access 
> to do something you can't prevent that program from doing that something.

And Security 102 is "most of the *real* trouble starts when authorized programs
access authorized things in unintended ways".

> if you want to control what commands one program can send to another you 
> need a security proxy between them. that isn't what AppArmor or SELinux 
> are trying to do so don't blame them for not doing it.

I'm not blaming them. I'm blaming the people who are trying to sell AppArmor
as doing much more than a small bandaid on the totality of the security issue.

There's *lots* of attacks.  AppArmor only addresses a very small segment of
them, and it's quite arguably not even addressing the ones you should worry
about.

> > I'm not convinced that it's solving enough *actual* problems, given that we've
> > rejected a lot of other "helps a little in some cases" code for kernel
> > inclusion.
> 
> you seem to want a 'only let the system do what the programmer intended' 
> command, and anything less isn't solving the actual problem. by that logic 
> we shouldn't bother with passwords either, since they don't completely 
> solve the problem

No, I'm saying that we've had a *lot* of partial solutions, from Grsecurity
to signed-modules, that didn't go in to the tree because they were too intrusive
for the partial security they provided.

> you first want to knock off all the things in that 'most attacks' catagory 
> so that you can pay close attention to the threats that are targeted 
> directly at you.

Quite frankly, if you've configured your system properly, and kept things
patched, and all the other things you should be doing *anyhow*, the vast
majority of "most attacks" really shouldn't be much more than "The daily
report showed another 2,395 probes for that year-old exploit".

Remember - if you're getting hit by a "background noise" random attempt,
it is almost certainly *not* a 0-day, because any attacker who's clued enough
to *have* a 0-day has enough sense to save it for when he has a targeted attack
planned.  So there's 2 possibilities:

1) It's a random attack, and it's a *known* attack and other things (patches,
IPS, and so on) should already be mitigating the attack.

2) You're a specific target, and the fact that AppArmor stopped the attack
just means that a different attack will be made.

> For example, this means that it probably won't be allowed to run bash and 
> provide a shell to the outside attacker.

No, but I can mmap an area, make it executable, and download a block of
executable code and branch to it, giving me a shell anyhow.

> It also means that locally exploitable bugs are less likely to be able to 
> be combined with remotely exploitable bugs into complete machine takeovers 
> becouse the remotely exploitable server would have to have permission to 
> access the locally exploitable software.

Right. Instead, the locally exploitable bug is combined with an exploitable
browser bug instead. :)

> if you can't see any advantage to this then you would be happy doing a 

Oddly enough, I don't see an advantage to only closing off half the avenues of
attack. If you go digging through the SELinux and LSM archives, you'll probably
find me arguing against the SELinux 'targeted' policy, for many of the same
reasons.  And the 'targeted' policy does a better containment of things than
the AppArmor model.

> chmod -R 777 / on your system (becouse normal user permissions are a much 
> more restricted way of limiting the same type of access)

Bad analogy.  You meant "chmod -R 777 /var /etc because the file permissions
on the /lib and /usr trees are enough to stop most random attacks".

Yes, normal access permissions, being DAC, *are* a very limited way of
applying MAC.  And if you go back and read the LSM archives, the decision
was made to apply permissions/ACLS DAC first, and then apply LSM MAC, mostly
for performance and least-surprise reasons.  There's absolutely no big
theoretical reason why you couldn't chmod 777 everything, if you loaded an
LSM that implemented the necessary MAC.




--==_Exmh_1180846357_3873P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGYkkVcC3lWbTT17ARAr/SAJwJaK57HEGuNEzBrPHneQHw68c7MgCfREwt
pTRnD7xZA5jgRirjZEFFFRw=
=VKWs
-----END PGP SIGNATURE-----

--==_Exmh_1180846357_3873P--
