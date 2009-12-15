Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbZLOKfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbZLOKfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbZLOKfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:35:31 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:53375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZLOKfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:35:30 -0500
Subject: Re: [PATCH] wireless: wext: allocate space for NULL-termination
 for 32byte SSIDs
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>,
       daniel@caiaq.de, linux-kernel@vger.kernel.org, dcbw@redhat.com,
       m.hirsch@raumfeld.com, netdev@vger.kernel.org,
       libertas-dev@lists.infradead.org, stable@kernel.org
In-Reply-To: <200912151130.59103.holgerschurig@gmail.com>
References: <1260650850-16163-1-git-send-email-daniel@caiaq.de>
	 <1260871411.3692.4.camel@johannes.local>
	 <1260871634.3692.6.camel@johannes.local>
	 <200912151130.59103.holgerschurig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-enmlCh9FePsTAm0KgNKC"
Date: Tue, 15 Dec 2009 11:35:07 +0100
Message-ID: <1260873307.3692.10.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-enmlCh9FePsTAm0KgNKC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-15 at 11:30 +0100, Holger Schurig wrote:
> > drivers/net/wireless/libertas$ grep lbs_deb_ * | grep ssid
> > |grep '%s'=20
> > assoc.c:	lbs_deb_join("current SSID '%s', ssid length %u\n",
> > assoc.c:	lbs_deb_join("requested ssid '%s', ssid length %u\n",
> > assoc.c:	lbs_deb_join("ADHOC_START: SSID '%s', ssid
> >               length %u\n",=20
> > scan.c:		lbs_deb_wext("set_scan, essid '%s'\n",
>=20
> All those lines are gone once my cfg80211 lands.
>=20
> Do you know any way to make sparse moan about them?

Sorry, no, I don't think that's even possible unless you play dirty with
tricks like __iomem uses for instance but that'd require a lot of
casting in otherwise valid uses.

> BTW: the libertas firmware sometimes treat an SSID as a=20
> zero-terminated string. There are some firmware commands that=20
> accept just an u8[32] bytes for the SSID, but not an ssid_len,=20
> e.g. in the CMD_802_11_AD_HOC_START command.
>=20
> You therefore can't connect to the otherwise legitimate SSID of=20
> TEST\0\0\0.

Ick! I guess your cfg80211 IBSS join handler needs to check for that
then and refuse such an SSID.

johannes


--=-enmlCh9FePsTAm0KgNKC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLJ2ZXAAoJEODzc/N7+QmaahEP/1NGgdmZvOQkHwhv+HpRjB3W
kmZn6tcnlmzeUyKXEHAwIKHC8a3qCvlIXEA4uBX14hN+QJZ5UxQkgV32tvtCvnQ2
6hefyDx/54a/3nfYoQP4AWowjUGHxLa2LVHkzqtL+IT824keG2zvDVeccU5VqBed
O89bkHESKRKrEbyrAM7AXE853DPou45rIXfcVm4vg+GNR8+su9egRYHp2ZYaJrIa
zl/N+Vp+jc74XTZ2LgpSXoANoo2kOjoQ79TehrL1ZpBXsfuFGuiP4dQDi9viva9/
NT9kRo4aA54qBj5OyTwI7M3BZzkpKZOfDDsXcTobgj8K76Y2poG/Aadm9cMIBI4J
oKuP5QTuY7dFBd5tjUDeqEgrgYJytyUEp+vc0IT7bOuFrNdHswnouZJPH84nyHnP
SIKw9WE5t5CL0+5Uw9j3md5VaOmQ459AXKcQ6l4W/iBljYxjIMpBYlxHWI72feAd
fjYpbdcQ8OlXwBJYN1QTTmw4bzHXRpXZdckxsjvlGL+Eih87MCT5FmRT3ye2CPbx
OnC9iedbQVD3fslgmjLsImCtIsgvJTT6PmhGnTd2hKqG9peSDwWKGantcwbmMuhk
7hrX2H7d9GInvk8SMbXoSK/RRrx0cvGKB8nBkmxz1hqvKRRsQNqAxzRPqPx4HONi
ZHodVwpcEJK7X3skWwiy
=Niwt
-----END PGP SIGNATURE-----

--=-enmlCh9FePsTAm0KgNKC--

