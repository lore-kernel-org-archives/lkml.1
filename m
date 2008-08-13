Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbYHMOOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbYHMOOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbYHMOOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:14:18 -0400
Received: from daemonizer.de ([87.230.16.230]:48242 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbYHMOOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:14:17 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH] acpi: Avoid dropping rapid hotkey events (or other GPEs) on Asus EeePC
Date: Wed, 13 Aug 2008 15:36:51 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, hmh@hmh.eng.br, stable@kernel.org
References: <487D23C3.5070301@student.cs.york.ac.uk> <20080813034628.0ef51866.akpm@linux-foundation.org> <48A2CAAA.7010405@tuffmail.co.uk>
In-Reply-To: <48A2CAAA.7010405@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3102479.OOaZrN5LKU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808131536.57705.maxi@daemonizer.de>
X-Spam-Score: -4.1 (----)
X-Spam-Report: No, hits=-4.1 required=5.0 tests=ALL_TRUSTED,AWL,BAYES_00 autolearn=ham version=3.2.3 
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	*  0.3 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3102479.OOaZrN5LKU
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 13 August 2008, Alan Jenkins wrote:
> [Dupe apology: CC'd to stable@kernel.org, with the right address this tim=
e]
>
> Andrew Morton wrote:
> > On Wed, 13 Aug 2008 11:21:10 +0100 Alan Jenkins=20
<alan-jenkins@tuffmail.co.uk> wrote:
> >> Andrew Morton wrote:
> >>> Did this get fixed yet?
> >>>
> >>> I have an patch in -mm which I just restored (I had to tempdrop it
> >>> because the acpi tree was busted for some time).  But it seems to be
> >>> old.
> >>>
> >>> http://bugzilla.kernel.org/show_bug.cgi?id=3D10919 is marked "resolve=
d"
> >>> but the reporter (Maximilian) seems to think otherwise.  2.6.26.x is,
> >>> afaik, still unfixed, as is 2.6.27-rc.
> >>
> >> That's correct.  I think this specific patch should go in 2.6.27 and
> >> 2.6.26-stable.  No objections have been raised so far.
> >>
> >> I still need this patch to make my brightness and volume control keys
> >> usable in 2.6.27-rc3.  (They auto-repeat fast enough to trigger the
> >> bug).  This is true even after applying the latest patches from bug
> >> 10919 (#25 + #27).
> >
> > Confusing.  Please send the patch which you think we should apply.
> >
> >> I think the 10919 fix makes it harder to reproduce, but it definitely
> >> still happens.  I guess this is because the polling-driven EC
> >> transactions add 1ms delays between each byte.  The slower timings lea=
ve
> >> a window where the buggy behaviour of my EC can make a difference.  (It
> >> has been seen to clear the "pending event" bit after a single event is
> >> read, despite having more events pending).
> >>
> >> There are more serious consequences of this bug.  After a while it can
> >> confuse the EC enough to cause lockups or reboots during boot, or after
> >> pressing a single hotkey.  This bad state is preserved over reboots,
> >> even into known good kernels.  Fortunately the badness clears when pow=
er
> >> is removed for a long enough period.  For a while I was worried that
> >> something had physically burnt out.
> >
> > Oh gad.  And there's no workaround?
>
> Sorry, that was confusing.
>
> The patch in currently in -mm _is_ the workaround for this damage.  It
> was not initially obvious just how important it was :-).  I've
> re-attached it as requested.
>
> 10919, "laggy hotkeys" is just what it says; ACPI EC events are slower
> because of polling.  It appears to be a more cosmetic issue which is
> orthogonal to the _dropping_ of events.
>
> Thanks
> Alan

This patch doesn't fix my problem (bug 10919), it only changes it a bit.
When I press the dimming key and hold it pressed the display should dim=20
up/down step by step as long as I hold the key pressed (that's how it has=20
always been).
I'm now running a 2.6.27-rc3 kernel with your patch applied and the display=
=20
does dim as described below.
When I press the dimming key first the display brightness doesn't change at=
=20
all, then it jumps multiple steps, stays there for a short while and again=
=20
jumps some steps till it reaches the end of the dimming interval.
It looks like the key presses (assuming holding down the key does generate=
=20
multiple key presses) get queued up, then all processed all at once, then=20
again queued up...

Maxi

--nextPart3102479.OOaZrN5LKU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEABECAAYFAkii43QACgkQOimwv528XGGVAwCeNhwodq3FtEuVLpfP9/aAKN5i
1BIAmKebi/NicSv2kKzaKW8Wi9HbItQ=
=wwwU
-----END PGP SIGNATURE-----

--nextPart3102479.OOaZrN5LKU--
