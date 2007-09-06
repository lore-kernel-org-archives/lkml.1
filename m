Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbXIFMJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbXIFMJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXIFMIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:08:52 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:55025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbXIFMIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:08:51 -0400
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Satyam Sharma <satyam@infradead.org>, Florian Lohoff <flo@rfc822.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com,
       Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070906082301.GB21929@gondor.apana.org.au>
References: <20070902184439.GA14306@paradigm.rfc822.org>
	 <6bffcb0e0709021659o3856cd06gabc054c949a84397@mail.gmail.com>
	 <alpine.LFD.0.999.0709060923340.26804@enigma.security.iitk.ac.in>
	 <20070906082301.GB21929@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aDhX2JYVj+qvS9HXtxEq"
Date: Thu, 06 Sep 2007 14:09:35 +0200
Message-Id: <1189080575.28781.65.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aDhX2JYVj+qvS9HXtxEq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-06 at 16:23 +0800, Herbert Xu wrote:
> On Thu, Sep 06, 2007 at 10:32:33AM +0530, Satyam Sharma wrote:
> >=20
> > > > [  382.529041]  [<c02c8abc>] dev_close+0x24/0x67
> > > > [  382.529052]  [<e01f402b>] ieee80211_master_stop+0x4a/0x6d [mac80=
211]
>=20
> This is where the bug is.  You cannot call dev_close from an
> atomic context as i33380211_master_stop does it within spin
> locks.

Hah, I suspected as much but didn't have a chance to look yet. I had
plans to replace that sub_if_list with an RCU list and not require the
lock there, but that's far off. Any ideas how to fix this? We can't
reject the master stop so we have to walk the list, I guess we'll have
to audit the other list manipulation places, I think they're all under
RTNL.

johannes

--=-aDhX2JYVj+qvS9HXtxEq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3+3//ETPhpq3jKURAmSDAJ4htpfzSylRKgy7lccg8n7RghW2+gCgoJDZ
IpSVWTebwTCqf7Iq44pU2gc=
=u3vr
-----END PGP SIGNATURE-----

--=-aDhX2JYVj+qvS9HXtxEq--

