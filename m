Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbXL3G2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbXL3G2z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 01:28:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXL3G2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 01:28:47 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42102 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbXL3G2q (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 01:28:46 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: TOMOYO Linux Security Goal
In-Reply-To: Your message of "Sun, 30 Dec 2007 14:29:50 +0900."
             <200712301429.FEF05784.FtFOVJHOOLMSQF@I-love.SAKURA.ne.jp>
From: Valdis.Kletnieks@vt.edu
References: <20071226164230.GA14210@sergelap.austin.ibm.com> <200712272200.IIJ73936.OHOFFLMOQJVFtS@I-love.SAKURA.ne.jp> <20071227145431.GB5161@sergelap.austin.ibm.com> <200712282332.EGC57888.OFFQHJOLVSMtFO@I-love.SAKURA.ne.jp> <27904.1198862631@turing-police.cc.vt.edu>
            <200712301429.FEF05784.FtFOVJHOOLMSQF@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198996100_3779P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 30 Dec 2007 01:28:20 -0500
Message-ID: <7781.1198996100@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198996100_3779P
Content-Type: text/plain; charset=us-ascii

On Sun, 30 Dec 2007 14:29:50 +0900, Tetsuo Handa said:

> Use of "learning mode" is independent from "correct policy".

My point *exactly*.

> The "learning mode" merely takes your duty of appending permissions to policy.
> We can develop and share procedures for how to exercise infrequently used code
> paths, like how to confirm that your SMTP service won't relay spams.
> This problem is nothing but "developing and sharing procedures for how to
> exercise infrequently used code paths" has not started yet.

And I don't have an issue with the concept that you let a "learning mode"
develop 95% of the policy for you - as long as you make clear that you *do*
need to do some work to ensure all code paths are tested, or otherwise verify
that the generated policy is in fact correct.  For instance, semantic analysis
of the program source can identify what directories a program *should* create
files in - if some directories aren't in fact listed in the policy, they need
to be added.  If the actual learned policy includes directories that shouldn't
have been learned, you've got a *bigger* problem.  And yes, I have worked with
more than one case where a "benchline" measurement of a system happened to
include an actual intrusion....

> By the way, what is the definition of "correct policy"?

> The definition of "correct policy" depends on the user.
> 
> Some users may think that
> 
>   "A ready-made policy is better than a manually-made policy
>    even if the ready-made policy contains unused/unneeded permissions.
>    Being unable to handle infrequently used code paths is worse than
>    leaving a room for not knowing/understanding what can happen."
> 
> but other users may think that
> 
>   "A manually-made policy is better than a ready-made policy
>    even if the manually-made policy lacks permissions for infrequently
>    used code paths.
>    Leaving a room for not knowing/understanding what can happen is worse than
>    being unable to handle infrequently used code paths."

Neither.

Policy *correctness* is a measure of how well the policy allows those
events that should properly happen, and rejects those events that should not
happen.  What you discuss here is what the relative impact of various *errors*
in the policy - basically, false-negative versus false-positive identification
of policy-violating activity.  Your first example says that it's preferable
to false-negative and fail to flag a violation, your second that it's
preferable to false-positive and flag something that should have been allowed.

In neither case are you actually talking about *correct* policy - which
would *properly* describe the desired behavior.  Note that how the policy
was *created* does not affect the *actual* correctness of the policy - it's
quite possible to create both correct and incorrect policies via both
manual and ready-made methods.

The *true* security question is:  What method minimizes your *total* cost of
both developing the policy and dealing with *both* the false positives and
negatives of a possibly incorrect policy?

> Since the definition of "correct policy" is not a globally agreed word,
> I think we can't say that "learning mode unlikely produces correct policy".

I'm pretty sure that most of the security community agrees on what "correct"
means - the disagreement is in the most cost-effective way to *create* one.

Notice that I never said "learning mode is *unlikely* to produce correct policy".
What I said was "Learning mode *may* produce a correct policy, but there is a
non-zero probability that needed things will remain unlearned unless care is
taken to ensure they are learned".

And I've been in this industry long enough to have *many* teeth marks where
I've been bitten by very small but non-zero probabilities.... :)


--==_Exmh_1198996100_3779P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHdzqEcC3lWbTT17ARAgPYAKCyxu0bhB/LNjjf77nCtDEkPfAzgACfcmus
ZpWvdX0wZ20TSqJ35WNq1CI=
=GAR8
-----END PGP SIGNATURE-----

--==_Exmh_1198996100_3779P--
