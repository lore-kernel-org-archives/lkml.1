Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZHMK7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZHMK7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZHMK7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:59:42 -0400
Received: from mail-yw0-f193.google.com ([209.85.211.193]:36828 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZHMK7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:59:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Mw9rLUnckkiP61pz9sJ5sRzGro4yJmX46UqANL+WNzuxNTrJPF1xbvi+E4fpz0064/
         RXnaeTLVQx/Jc9JV+FCarMxGt+e3QREOkZf0J2Tc9nfwbknfiuDVfuwFBT6bgxSvEgGk
         ydTDdXo5Q6Ja2wWGWpqSE6pL9L0EJ44iYy1AI=
Date: Thu, 13 Aug 2009 14:02:55 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Len Brown <len.brown@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Bob Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: acpi_ex_system_memory_space_handler oops
Message-ID: <20090813110255.GA3238@localdomain.by>
References: <20090812201034.GA2983@localdomain.by>
 <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0908122009170.22946@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/12/09 20:18), Len Brown wrote:
> Please find which kernel this failure starts in.
> Start by testing 2.6.30.stable so we can tell
> if this is a regression in the current RC.
>=20

Looks like regression in the current RC.

git bisect start 'good' '2.6.31-rc4' 'bad' '2.6.31-rc5'
# bad: [a3620f7545344f932873bf98fbdf416b49409c8e] Merge branch 'for-linus' =
of git://git.kernel.dk/linux-2.6-block
git bisect bad a3620f7545344f932873bf98fbdf416b49409c8e
# good: [4be3bd7849165e7efa6b0b35a23d6a3598d97465] Linux 2.6.31-rc4
git bisect good 4be3bd7849165e7efa6b0b35a23d6a3598d97465

rc4-git0
10+ successfull boots
+ + + + + + + + + +


git bisect start=20
git bisect bad
bisect good v2.6.31-rc5
# bad: [a3620f7545344f932873bf98fbdf416b49409c8e] Merge branch 'for-linus' =
of git://git.kernel.dk/linux-2.6-block
git bisect bad a3620f7545344f932873bf98fbdf416b49409c8e
# good: [ed680c4ad478d0fee9740f7d029087f181346564] Linux 2.6.31-rc5
git bisect good ed680c4ad478d0fee9740f7d029087f181346564

rc5-git0
10+ successfull boots
+ + + + + + + + +


	Sergey

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqD8t8ACgkQfKHnntdSXjT5FAP/ZAEC/pIEdl2EazJtObW3+XRj
wZVqwh5ZEXSq4xpzqpHHugwWVP/vTes/xfDd7nznTA3KD3PGz8yL2wJSR/GwcETy
2phvn4tLvHvJOW+Yiv77+fe1Q0gwdpBG5wva86VS3Ekpz2dtYYGhuc6FWQCMz0z1
JzUJDwADNXz8g2MAHsQ=
=S6GH
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
