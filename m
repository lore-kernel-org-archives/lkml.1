Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbXK0GOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbXK0GOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 01:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbXK0GNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 01:13:55 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57251 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbXK0GNy (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 01:13:54 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Dave Jones <davej@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
In-Reply-To: Your message of "Mon, 26 Nov 2007 23:34:11 EST."
             <20071127043411.GF15764@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <20071125161631.GA21947@stusta.de> <20071126122706.GA5167@ucw.cz> <20547.1196135084@turing-police.cc.vt.edu>
            <20071127043411.GF15764@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196144008_2838P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Nov 2007 01:13:28 -0500
Message-ID: <11497.1196144008@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196144008_2838P
Content-Type: text/plain; charset=us-ascii

On Mon, 26 Nov 2007 23:34:11 EST, Dave Jones said:
> On Mon, Nov 26, 2007 at 10:44:44PM -0500, Valdis.Kletnieks@vt.edu wrote:
>  
>  > I suspect that given the "once it escapes, it's cast in stone" view we take
>  > towards user-visible API/etc, there isn't much *real* room for an
>  > 'EXPERIMENTAL' flag anymore.  Most of the usage should probably be confined to
>  > individual drivers, where all we should need is a 'default n' and suitable
>  > warning verbiage in the Kconfig file warning about the driver eating your
>  > filesystems and small animals for breakfast.
> 
> Potential corruptors are usually flagged with (DANGEROUS) in the text,

Right, and given that, an additional EXPERIMENTAL flag seems superfluous.

> (One may argue that they shouldn't have escaped -mm)
> 
>  >  We certainly shouldn't have
>  > one big flag for *all* in-progress drivers - I don't need to accidentally
>  > enable a busticated ethernet driver because I want a USB widget.
> 
> So no ethernet driver at all is better than a broken but mostly working one?
> Again if it isn't mostly working, it shouldn't have escaped -mm

No.

The point is that using the *same* flag to control whether I can select
a mostly-working USB widget and a mostly-working Ethernet driver is Just Wrong.

Those of us who live in the US may have seen the insurance commercial where
Joe Sixpack is asking "Honey, what does this switch do?" "I don't know" flip,
flip, flip with no obvious impact.  Meanwhile, 3 houses down, somebody's car
is being beat up by a garage door opener going open/close/open/close...

I enable EXPERIMENTAL to enable my USB widget. When the next release comes out,
I then go and do something like a 'make [foo]config'.  What indication do I
get that now-selectable device drivers are 'depends on EXPERIMENTAL' and *not*
safe for selection? (Yes, in menuconfig, you can ask it to show the 'depends
on' list, *if* you suspect that it might be an issue.  But why would I suspect
that?)

In no case should we be creating a situation where users are thinking "Damn,
every driver may or may not be bodgy, I have to *check* if it's experimental
before I enable it, just because there was one that I *asked* for".
Particularly fun if you're migrating to new hardware and you don't *know* yet
which drivers you need, and you're getting prompted for possibly-dodgy ALSA
modules because you asked for a USB module....

(And yes, trying to wade through all the ALSA/Intel HDA/AC97/Sigmatel *was*
painful enough when I moved from a Dell Latitude C840 to a D820 - fortunately
enough, I didn't have to deal with EXPERIMENTAL ALSA drivers adding to the
mix.. )

EXPERIMENTAL in a mainline kernel as a *single* switch for a *lot* of totally
unreleated code is even more broken than EMBEDDED (which at least had a common
rationale). And over in the -mm kernel where it *should* be, it's superfluous
at best, because a -mm kernel might as well just add -DCONFIG_EXPERIMENTAL=y to
CFLAGS and save you the effort. ;)





--==_Exmh_1196144008_2838P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHS7WIcC3lWbTT17ARAuoiAKDWkhtgcHsjDiuFm9/TAJmIemgurACfeWsT
DVGkkLTfoodYtK4cQVyB1Tk=
=WEXV
-----END PGP SIGNATURE-----

--==_Exmh_1196144008_2838P--
