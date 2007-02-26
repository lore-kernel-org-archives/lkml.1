Return-Path: <linux-kernel-owner+w=401wt.eu-S1161308AbXBZWwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161308AbXBZWwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 17:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161309AbXBZWwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 17:52:38 -0500
Received: from betty.cbit.net.au ([202.55.154.10]:59594 "EHLO mail.cbit.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161308AbXBZWwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 17:52:37 -0500
X-Greylist: delayed 1507 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Feb 2007 17:52:36 EST
Date: Tue, 27 Feb 2007 09:27:24 +1100
From: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
To: john stultz <johnstul@us.ibm.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org
Subject: Re: Make sure we populate the initroot filesystem late enough
Message-ID: <20070226222724.GA13182@keitarou>
References: <200612112059.kBBKx1j7022473@hera.kernel.org> <1172448057.3971.9.camel@shinybook.infradead.org> <1172518068.15970.6.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <1172518068.15970.6.camel@localhost>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2007 at 11:27:47AM -0800, john stultz wrote:
> On Sun, 2007-02-25 at 19:00 -0500, David Woodhouse wrote:
>> On Mon, 2006-12-11 at 20:59 +0000, Linux Kernel Mailing List wrote:
> >>=20
> >>     Make sure we populate the initroot filesystem late enough

>> This seems to be what's triggering the apparent memory corruption we've
>> been seeing recently -- in the case of the Fedora kernel it manifests
>> itself as a BUG() in cache_alloc_refill() when the pmac ide driver
>> initialises.
>>=20
>> Another report was at http://lkml.org/lkml/2006/12/17/4
>>=20
>> We've been seeing it on a Mac Mini too, and I managed to reproduce it on
>> my shinybook this evening by booting with 'mem=3D512M'.

> Just for reference (as its not in the thread linked above), this issue
> disappeared for me after some config changes (I somehow changed my
> selection when I backtracked and then moved forward w/ git bisect).

> I've not been able to reproduce it since, but I know others (BCC'ed on
> this note) have seen it and might prod them to come forth with details
> (and broken .config files)

In my case, disabling CPU_FREQ_PMAC made the failure go away.
After reverting this patch, CPU_FREQ_PMAC is once again operating
successfully, so far.

--=20
-----------------------------------------------------------
Paul "TBBle" Hampson, B.Sc, LPI, MCSE
On-hiatus Asian Studies student, ANU
The Boss, Bubblesworth Pty Ltd (ABN: 51 095 284 361)
Paul.Hampson@Pobox.Com

Of course Pacman didn't influence us as kids. If it did,
we'd be running around in darkened rooms, popping pills and
listening to repetitive music.
 -- Kristian Wilson, Nintendo, Inc, 1989

License: http://creativecommons.org/licenses/by/2.1/au/
-----------------------------------------------------------

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF417MexDuohKLFuARArwmAJ935Wo7mlLd4DOaWcwZAsfefxIqBACfaqq+
QsDgU/TGLK72b30RCT05Ozk=
=2x33
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
