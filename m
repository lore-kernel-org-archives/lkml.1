Return-Path: <linux-kernel-owner+w=401wt.eu-S1751423AbZERTkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbZERTkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 15:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZERTkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 15:40:37 -0400
Received: from ist.d-labs.de ([213.239.218.44]:42331 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbZERTkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 15:40:36 -0400
Date: Mon, 18 May 2009 21:40:22 +0200
From: Florian Mickler <florian@mickler.org>
To: Rob Landley <rob@landley.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: http://www.kernel.org/doc/local/git-quick.html#bisect
Message-ID: <20090518214022.632d5d20@schatten>
In-Reply-To: <200905180254.20748.rob@landley.net>
References: <20090515121829.60de2210@schatten>
	<200905151820.05246.rob@landley.net>
	<20090517231135.3c740ab2@schatten>
	<200905180254.20748.rob@landley.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/HtW.aD0yY+f7.5sRd6/=yUD";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HtW.aD0yY+f7.5sRd6/=yUD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 May 2009 02:54:20 -0500
Rob Landley <rob@landley.net> wrote:


> You've managed that, yes.
good. please, i'm a friendly guy.. at least i think so. i'm
terribly sorry if i upset you.=20


>=20
> > ("B" being the bug-introducing changeset, "1" the first tested
> > commit, "2" the 2nd tested commit, "-" some other commit and "+"
> > some merge or branchpoint. )
> >
> > you guess wrong at 1 (this means you classify 1 good.)
> > second commit is 2 which is good, as there the bug B was never
> > introduced. so you get 2 as good. which is not the opposite of your
> > guess.
>=20
> If you converge all the way to a single changeset and it doesn't
> reproduce the bug, you guessed wrong and have to back up.  As
> described.

but in this case the changeset (mergecommit) has the bug, as the
mergecommit is on-top of 1 which is on top of B.=20

reverting it is probably non-trivial. replaying with all the
guesses reverted needs 2^[nr-of-guesses] compiles. which is not
feasible if there are many buildbreakages.=20

>=20
> No mechanism can automatically find a bug that was introduced in a
> group of revisions that doesn't build for you, or cannot otherwise
> get far enough to reproduce the bug.  (For that you have to patch the
> source to get it to work will enough you can test for that specific
> bug.)

yes.

> So the fact they introduced that feature before "skip" was
> implemented doesn't enter into this somehow?

well, maybe if one is interested at the _history_ of
git-quick.html and git-bisect...  but i'm more interested in the
present and future of things. :) (if you know what i mean)


> > > > (and that really sucks, because all your compiliations after
> > > > that one are _worthless_ ).
> > >
> > > No, they demonstrate that the bug isn't in that fork, at which
> > > point you back up and check the other fork.
> >
> > no... you never know because you
> > have no way of knowing if the bisection succeeded or not.
>=20
> You can always either find the first commit that reproduced the bug,
> or confirm that the bug was introduced in a versions that doesn't
> build for you. The automation doesn't have any more information to
> work with than the manual method does; it can't do more than that
> either.
>=20
> Apparently, you don't understand the method I described.  Obviously,
> my description of this method was crap.

well, maybe i didn't tried hard enough to understand it? but i think
guessing is best to be deferred to the _end_ of the bisection.=20


> > if you use git-bisect skip there is the (large) chance that your
> > skipped commit is based ontop of a test-able commit which already
> > has the bug=20
>=20
> If it's testable, why are you skipping it?
no. i try again.=20

how i imagine patching: you apply one patch on top of the other. so
that you get a 'pile' :) there is a 'base' and a 'tip'.=20

and here's what i meant to say:

given this 'pile of commits':
base---xxxxxxxx--B-xxxxxxxx---tip

x are commits that don't build, B is the bug-introducing changeset and
- are other commits.=20

if you skip all the (x) commits, then you never guess but get a
completely right and sane bisection result pointing to B. because you
can test the commit right after B (which is BAD), and right before B
which is good.=20

so you never guessed and you never replayed, you just skipped all the
way through those not building commits and have pinpointed the B-Commit
nonetheless... see?

with 'git bisect visualize' (which fires gitk up, only showing the
commits framed by your nearest good and bad decision)  you can even look
in the log for the corresponding build-fix and test that commit instead.


on the other hand:

base---xxxBxxx---tip

in this situation, skipping dosn't do any good. but it dosn't hurt
also. you just get this none-building range of commits as containing
the bug.=20


but if:

base-xx--xxBxx--xx--tip

you win, because those 4 outer nonbuilding commits are ''cut off'' and
you just get to choose between 5 commits instead.

>=20
> Why would the chance be larger for it to have the bug than to not
> have the bug?  (And if you think it has the bug, guess that it's bad
> then.)

what i meant: if you bisect through the kernel (2^17 commits from 2.6.27
to 2.6.30-rc5) your chance is large that any nonbuilding-patch-range is
small and cut-off  from your bug-introducing commit. (that is there are
building commits that are either good or bad between B and the
build-breakage)



>=20
> Why are you telling _me_ about your dissatisfaction with a quote from
> the git-bisect man page?
It was just because, well,  you quoted it. I'm  sorry.=20


> You're insisting that the mention of "git-bisect skip" I added a year
> ago wasn't sufficient, and what's there is potentially misleading and
> harmful to minors and so on, and thus it is vitally important that
> several screens worth of material be removed.  (Despite the technique
> working for me just fine.)
>=20
> *shrug*  I never claimed to be a git expert.  I leave that to you.
>=20
> I've removed the potentially misleading document from kernel.org.
> There are plenty of other git tutorials, written by people who
> know/care far more about git than I do, and I have no intention of
> distracting you from them.
>=20
> Rob

but you are working overtime with this method! perhaps it's ok, if you
don't have to do too many guesses and i never tried your method. but if
i tried to explain git bisect the way i _think_ it is right and
understandable , and you are satisfied with it, would you consider
putting it back up?

as it is already pretty high in google, it would be a shame to just
take it down. especially as this was the only thing that tripped me up.=20
(and not finding the adress to send a corrected paragraph freaked me
out, then. again, i'm sorry. )


Sincerely,
Florian

--Sig_/HtW.aD0yY+f7.5sRd6/=yUD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoRuasACgkQPjqCkyL3Kv3Z+gCghf3+ioAarvvAwgNw6C+uQeoQ
L20AoKo8pY2DnbSFhtv4neUb6SslN5Qe
=x7tc
-----END PGP SIGNATURE-----

--Sig_/HtW.aD0yY+f7.5sRd6/=yUD--
