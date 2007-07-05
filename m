Return-Path: <linux-kernel-owner+w=401wt.eu-S1760527AbXGEJbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527AbXGEJbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbXGEJbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:31:09 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:37851 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542AbXGEJbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:31:08 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: x86_64 memory hotplug simulation support?
Date: Thu, 5 Jul 2007 19:31:02 +1000
User-Agent: KMail/1.9.6
Cc: nigel@suspend2.net, LKML <linux-kernel@vger.kernel.org>
References: <20070705145527.2798.Y-GOTO@jp.fujitsu.com> <200707051644.55191.nigel@nigel.suspend2.net> <20070705161700.279A.Y-GOTO@jp.fujitsu.com>
In-Reply-To: <20070705161700.279A.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1469108.GuIO04eQ4v";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707051931.02594.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1469108.GuIO04eQ4v
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 05 July 2007 18:52:13 Yasunori Goto wrote:
> > Thanks for your reply. Please, just call me Nigel :).
>=20
> Haha. Okay. Nigel.
> (Though, San is useful for even friendly/frank situation in Japanese :) )

Ah, ok. Sort of like the Aussies among whom I'm living say "Mate", I guess =
=2D=20
in that regard at least.

> > I saw a patch that Dave=20
> > Hansen had posted, back around the time of 2.6.11 iirc. It was for x86,=
=20
and=20
> > (so far as I understand) allowed a person who doesn't really have=20
> > hotpluggable memory to make their computer pretend that it does.
> >
> > Just in case I'm not being clear enough, let me get more concrete. I ha=
ve=20
had=20
> > some code for a while that uses bitmaps to simulate page flags, without=
=20
> > needing to take up those precious bits in page->flags. I've begun to ad=
d=20
> > support for memory hotplugging, in the hope that I can make it general=
=20
enough=20
> > that it will be useful for more than just suspend2. To do that, I'd lik=
e=20
to=20
> > be able to test the memory hotplugging paths, without needing to actual=
ly=20
> > have hotpluggable memory. I do have an x86 desktop I could work on, but=
=20
would=20
> > prefer to do it on my x86_64 laptop if I can.
>=20
> Current memory hot-add code expects special hardware which allows
> memory hot-unplug physically. Yes, these is no way to use it on=20
> normal PC without emulation. And I don't have emulation code for
> x86-64. Usually, I'm using ia64 box for test it.
>=20
> These are 2 ideas to use memory hotplug with normal x86-64 box.
>=20
> - Make emulation code for x86-64.
>   To add memory, some of memory have to be ignored at boot time.
>   And add memory after boot up.
>   This way may need fake BIOS information. And if memory is added once,
>   reboot is necessary for next hot-add test.

Mmm. I can do it in a vm; that will make it less painful.
=20
> - Bootup normaly. Unplug some memory at first, then hot-add them
>   later.  You can try hot-plug code many times after bootup.
>=20
>   Unplug code must is not merged yet. Followings are the newest one.
>       http://marc.info/?l=3Dlinux-mm&m=3D118180415304117&w=3D2
>   But the 6th patch of them is only for ia64.
>       http://marc.info/?l=3Dlinux-mm&m=3D118180483715610&w=3D2
>   So, same role patch for x86-64 is still necessary.

Ah. I'd forgotten about the existence of the -mm list. I'll take a look whe=
n I=20
get some time to do more of this.

>   In addition, some of route of hot-add code can't be tested.
>   Because, current hot-add has 2 phase.
>     1. Physically hot-add.
>          - Accept notification from firmware.
>          - Make sysfs file for new memory.
>          - register SPARSEMEM and allocate memmap/pgdat/zone.
>     2. logically online
>          - free each pages of new memory to use them.
>          - rebuild zonelist.
>=20
>   But, unplug code just do logical offline. physicall hot-unplug
>   must be necessary for test phase 1.
>=20
>=20
> Hmm. I don't know what is necessary for suspend2.
> But, some works looks still necessary for each way.=20

I think I could get away with just doing the logical online part. It's main=
ly=20
the adding pages to zones that I'm interested in - I'd have to trigger the=
=20
expansion (and shrinking) of already allocated bitmaps.

Thanks very much for your help so far!

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart1469108.GuIO04eQ4v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjLpWN0y+n1M3mo0RAtZ2AKC7MmPeWJUbTwT0+LjdiG9rT83GWQCgpfsT
b4kl0+Je3++u4NxwJ96CiZY=
=//aD
-----END PGP SIGNATURE-----

--nextPart1469108.GuIO04eQ4v--
