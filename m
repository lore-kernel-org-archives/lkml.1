Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbYHWG2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbYHWG2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 02:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbYHWG2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 02:28:11 -0400
Received: from mx40.mail.ru ([194.67.23.36]:64087 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYHWG2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 02:28:10 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.27-rc4: 90% system time because of khubd, unable to reboot
Date: Sat, 23 Aug 2008 10:27:59 +0400
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0808221422130.2230-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808221422130.2230-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart32095236.uYi8qE19ZP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808231028.03802.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart32095236.uYi8qE19ZP
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 22 August 2008, Alan Stern wrote:
> On Fri, 22 Aug 2008, Andrey Borzenkov wrote:
>=20
> > It looks even funnier. Right now I am running with commits
> > 38b375d9610e2467cb793a84d17c6f65e44cdb39 *and*
> > e872154921a6b5256a3c412dd69158ac0b135176 reverted. I.e. this should be
> > the state which hopelessly failed in 2.6.26-rc. It seems to be doing
> > quite well now in 2.6.27-rc.
> >=20
> > "git revert e872154921a6b5256a3c412dd69158ac0b135176" gives me this
> > one liner patch:
> >=20
> > commit f3cf9ad86ee76077d1c6be9af7d197aa13ccdff9
> > Author: Andrey Borzenkov <arvidjaar@mail.ru>
> > Date:   Fri Aug 22 21:15:26 2008 +0400
> >=20
> >     Revert "USB: don't explicitly reenable root-hub status interrupts"
> >=20
> >     This reverts commit e872154921a6b5256a3c412dd69158ac0b135176.
> >=20
> > diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> > index 107e1d2..d30f822 100644
> > --- a/drivers/usb/core/hub.c
> > +++ b/drivers/usb/core/hub.c
> > @@ -3086,6 +3086,11 @@ static void hub_events(void)
> >                 if (!hdev->parent && !hub->busy_bits[0])
> >                         usb_enable_root_hub_irq(hdev->bus);
> >=20
> > +               /* If this is a root hub, tell the HCD it's okay to
> > +                * re-enable port-change interrupts now. */
> > +               if (!hdev->parent && !hub->busy_bits[0])
> > +                       usb_enable_root_hub_irq(hdev->bus);
> > +
> >  loop_autopm:
> >                 /* Allow autosuspend if we're not going to run again */
> >                 if (list_empty(&hub->event_list))
> >=20
> > Either my git tree is completely botched or most parts were already rev=
erted
> > before.
>=20
> _Something_ is completely botched.  e872154 is much bigger than what=20
> you quoted above.
>=20

Oh, no need to be *that* polite telling me I'm idiot.

> The commit you really want to revert is
> 09ca8adbe9f724a7e96f512c0039c4c4a1c5dcc0.
>=20

Sure. Mouse slipped doing copy'n'paste :)

If you are still interested in this strange effect of lone 38b375d9,
I could run some tests; just tell me what is needed.

--nextPart32095236.uYi8qE19ZP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkivrfAACgkQR6LMutpd94yUdACfXB+NFhhS+nvcFD0HBXEUE3eq
xHYAnArRaouC5nDp9mRM2BcHPQn38yLa
=Zlpn
-----END PGP SIGNATURE-----

--nextPart32095236.uYi8qE19ZP--
