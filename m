Return-Path: <linux-kernel-owner+w=401wt.eu-S1759370AbXKASoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759370AbXKASoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbXKASoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:44:21 -0400
Received: from mx38.mail.ru ([194.67.23.16]:60273 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbXKASoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:44:20 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2.6.24-rc1 regression] AC adapter state does not change after resume
Date: Thu, 1 Nov 2007 21:44:02 +0300
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200710302324.52822.arvidjaar@mail.ru> <200710310709.06621.arvidjaar@mail.ru> <47282055.2000409@gmail.com>
In-Reply-To: <47282055.2000409@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1928544.vAtv2EvoK9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711012144.12477.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1928544.vAtv2EvoK9
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 31 October 2007, Alexey Starikovskiy wrote:
> Andrey Borzenkov wrote:
> > On Wednesday 31 October 2007, Alexey Starikovskiy wrote:
> >> Andrey Borzenkov wrote:
> >>> I suspect new ACPI AC adapter code but have to add some printk's to be
> >>> sure.
> >>>
> >>> To reproduce - plug in AC cord, suspend, unplug, resume - kpowersave
> >>> and sysfs still show AC adapter online. Or other way round.
> >>>
> >>> -andrey
> >>
> >> Please check if this patch helps.
> >
> > It does not even compile :)
> >
> > On serious note (after adding forward declaration) - patch half works. =
It
> > does make "online" return true value (which confirms that underlying AC=
PI
> > works correctly) but HAL still does not notice it.
> >
> > The problem is, with power_supply interface HAL does not use polling, it
> > relies on CHANGE event. This event is apparently never generated if AC
> > adapter state changes on resume. So the obvious fix is to compare AC
> > state before and after suspend in ->resume function and generate
> > synthetic CHANGE event if something has changed.
> >
> > This will also make superfluous polling redundant.
>
> Ok, here. This one compiles :)
>

=46or HAL regression:

Tested-by: Andrey Borzenkov <arvidjaar@mail.ru>

But the patch is incomplete. This synthetic event should be the same as if =
OS=20
were running; i.e. you should send both other events as well. As is you jus=
t=20
create latent bug to be hit by some netlink consumer sooner or later.

--nextPart1928544.vAtv2EvoK9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHKh5zR6LMutpd94wRAoPDAKCMm4j7jLfZyjHHOucHkh9QyqUQDQCeIs04
++sqLemtZM2bwIWm6cucFCE=
=Z36m
-----END PGP SIGNATURE-----

--nextPart1928544.vAtv2EvoK9--
