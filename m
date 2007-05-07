Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbXEGSn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbXEGSn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbXEGSn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:43:58 -0400
Received: from mx7.mail.ru ([194.67.23.27]:33819 "EHLO mx7.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbXEGSn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:43:58 -0400
X-Greylist: delayed 3151 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2007 14:43:57 EDT
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Andreas Schwab <schwab@suse.de>
Subject: Re: Long file names in VFAT broken with iocharset=utf8
Date: Mon, 7 May 2007 22:43:52 +0400
User-Agent: KMail/1.9.6
Cc: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>, hirofumi@mail.parknet.co.jp,
       linux-kernel@vger.kernel.org
References: <200705072151.20104.arvidjaar@mail.ru> <60F72760-C801-4F60-BF47-C661B4B5BE26@e18.physik.tu-muenchen.de> <jebqgwpkgk.fsf@sykes.suse.de>
In-Reply-To: <jebqgwpkgk.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3942483.AUKt8m5zBK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705072243.53150.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3942483.AUKt8m5zBK
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 07 May 2007, Andreas Schwab wrote:
> Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de> writes:
> > PATH_MAX specifically counts _bytes_ not characters, so UTF-8 does not
> > matter. ISTR that PATH_MAX was 256 at some point, but I just  quickly
> > grepped /usr/include and found various mention of 4096, so  where's the
> > central repository for this configuration item? A hard-
> > coded value of 256 somewhere inside the kernel smells like a bug.
>
> There is PATH_MAX and there is NAME_MAX, and only the latter (which is
> 260 for vfat) matters here.
>

Do you imply that Linux is unable to represent full VFAT names (255 UCS2=20
charaters) by design? Hmm ... testing ... looks like it,

touch $(perl -e 'print "=D1=84" x 200;') -> Name too long.

So what do we do with long VFAT names? As initial post shows, they do exist.

--nextPart3942483.AUKt8m5zBK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGP3NpR6LMutpd94wRAiURAJ47e2cJhCN6Y8quXL9mM8XCApoR9QCfeH8R
Y7yY2M9BIntJao/H2aCLZis=
=+Xjw
-----END PGP SIGNATURE-----

--nextPart3942483.AUKt8m5zBK--
