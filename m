Return-Path: <linux-kernel-owner+w=401wt.eu-S1751521AbZHAXiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbZHAXiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 19:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZHAXiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 19:38:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43667 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbZHAXiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 19:38:10 -0400
X-Sasl-enc: B4Nn0kP6h4zKnuU7nOBbZkQi3XHNuOgk0ZAEtqe8JBte 1249169875
Message-ID: <4A74D1A8.4000701@imap.cc>
Date: Sun, 02 Aug 2009 01:37:12 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCH 2.6.31-rc4] gigaset: really fix chars_in_buffer
References: <20090801-patch-01.tilman@imap.cc> <20090801171141.7a463347@lxorguk.ukuu.org.uk>
In-Reply-To: <20090801171141.7a463347@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0972C9705275DF9E42A0D0EC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0972C9705275DF9E42A0D0EC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Alan,

thanks a lot for getting in contact with me, and for your
explanation of the rationale behind your patch.

On Sat, 1 Aug 2009 17:11:41 +0100, Alan Cox wrote:
> Is that correct. If you take a signal so the mutex_lock_interruptible
> takes the error path we'll exit any waits for characters to be flushed
> from buffers and lose the bytes in some cases ?

You are right. I'll have to change it to use non-interruptible
mutex_lock. I'll prepare a new patch.

> Thats why I didn't
> convert it - I didn't understand why it was using _interruptible at all=
 ?

No specific reason. just the general rule to prefer sleeping
interuptibly whenever possible, because unkillable processes are
so annoying. Seeing that chars_in_buffer was declared as returning
int, I assumed (wrongly as it now turns out) that it would be
allowed to return the customary negative values for errors, so
that it could use the _interruptible variant. When I saw your
patch I read into it that zero would be the appropriate return
value for all error cases, including a signal while waiting for
the mutex. I guess there was a bit of wishful thinking in that.

Well, thanks again for your help. I'll follow up with a revised
patch.

Regards,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig0972C9705275DF9E42A0D0EC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKdNHdQ3+did9BuFsRAnmKAJ9FTAsQp9Gtvj+AFvkPzmwzzSUwLwCeJcO8
orp7s4kMpu4UBA5o0AzANVM=
=O3qV
-----END PGP SIGNATURE-----

--------------enig0972C9705275DF9E42A0D0EC--
