Return-Path: <linux-kernel-owner+w=401wt.eu-S1757090AbYIDUXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090AbYIDUXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbYIDUXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:23:18 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:34936 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbYIDUXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:23:14 -0400
Date: Thu, 4 Sep 2008 21:23:01 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory
 corruption
In-Reply-To: <b170af450809041242n43a6ef70s47a2e3e068619af0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0809042056270.3012@blonde.site>
References: <48B701FB.2020905@goop.org>  <86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
  <48B76CE0.5010309@goop.org>  <20080829102547.655440bf@lxorguk.ukuu.org.uk>
  <b170af450808290313x574b4561i3048ffca3e4da197@mail.gmail.com> 
 <Pine.LNX.4.64.0808291120540.8561@blonde.site> 
 <b170af450808290454m2f349ce3w4f400b0df0e105a2@mail.gmail.com> 
 <48B7E6EE.9090901@tuffmail.co.uk>  <Pine.LNX.4.64.0808291413260.12571@blonde.site>
  <b170af450808291039u7d036313x49acdaec079e6213@mail.gmail.com>
 <b170af450809041242n43a6ef70s47a2e3e068619af0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1293509426-1220559781=:3012"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1293509426-1220559781=:3012
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 4 Sep 2008, Rafa=C5=82 Mi=C5=82ecki wrote:
> > 2008/8/29 Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>:
> > 2008/8/29 Hugh Dickins <hugh@veritas.com>:
> >> Here's my version of Jeremy's patch, that I've now tested on my machin=
es,
> >> as x86_32 and as x86_64.  It addresses none of the points Alan Cox mad=
e,
> >> and it stays silent for me, even after suspend+resume, unless I actual=
ly
> >> introduce corruption myself.  Omits Jeremy's check in fault.c, but doe=
s
> >> a check every minute, so should soon detect Rafa=C5=82's HDMI corrupti=
on
> >> without any need to suspend+resume.
> >
> > Your periodic test works fine:
> >
> > Corrupted low memory at ffff88000000be9c (be9c phys) =3D b02a0004
> >  <IRQ>  [<ffffffff8020fc9b>] check_for_bios_corruption+0x93/0x9f
> >  [<ffffffff8020fca7>] ? periodic_check_for_corruption+0x0/0x25
> >  [<ffffffff8020fcb0>] periodic_check_for_corruption+0x9/0x25
> >
> > By the way I confirmed this bug on Sony Vaio FW11M (my one is FW11S).
> > Probably more machines from FW11* are affected.
>=20
> If this patch is known to work fine for Sony Vaio FW* and Alan's
> machine, could it go mainline somehow?

Well.

Thanks for the prod, and I'm certainly remiss for not following
up sooner.  But I'm really not at all keen on such a patch going
into mainline myself.

It's an interesting experiment, and I'd be happy to see such a patch
(adjusted to make sure output goes to kerneloops.org) spending a little
while in Fedora Rawhide (who'd be the right contact for that?).

But so far as mainline goes, I share Alan Cox's opinion that we should
not be chopping pages out of every x86 user's memory, just because a
couple of machines with faulty BIOSes have been observed.

Particularly now it's evident that the 64kB "limit" is no more than a
reflection of where the directmap pagetable changes have caught such
corruption.

If lots more such corruptions are reported, of course I would change
my position; but those bad directmap PMD crashes are themselves quite
recognizable now we know to look out for them.

I would prefer you both to use the minimal memmap=3D solutions for now;
but others may disagree.

Hugh
--8323584-1293509426-1220559781=:3012--
