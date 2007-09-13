Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbXIMKLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbXIMKLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 06:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbXIMKLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 06:11:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:40316 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751314AbXIMKLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 06:11:14 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/ndNJ5nyvnKP8MG/4lTjjvm20JgQzMFU6EgE9EGo
	+rvbCtWKDQpX4H
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: davem@davemloft.net
Subject: Re: hci_sock.c build failure
Date: Thu, 13 Sep 2007 12:11:09 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2176430.HocaZGP0YN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709131211.10950.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2176430.HocaZGP0YN
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I'm wondering why the build failure wasn't fixed by a patch like this:


diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 5ccea5f..85416bb 100644
=2D-- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -348,8 +348,6 @@ static inline void hci_sock_cmsg(struct sock *sk, struc=
t msghdr *msg, struct sk_

                skb_get_timestamp(skb, &tv);

=2D               data =3D &tv;
=2D               len =3D sizeof(tv);
 #ifdef CONFIG_COMPAT
                if (msg->msg_flags & MSG_CMSG_COMPAT) {
                        struct compat_timeval ctv;
@@ -358,6 +356,9 @@ static inline void hci_sock_cmsg(struct sock *sk, struc=
t msghdr *msg, struct sk_
                        data =3D &ctv;
                        len =3D sizeof(ctv);
                }
+#else
+               data =3D &tv;
+               len =3D sizeof(tv);
 #endif

                put_cmsg(msg, SOL_HCI, HCI_CMSG_TSTAMP, len, data);


=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart2176430.HocaZGP0YN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBG6Qy9hyrlCH22naMRAm/WAJkB4yKN95w61Ja/g5a/a6MjGn7jcACePt8u
Wi7jWIyE16OSVUJl/ypPT4A=
=RXG7
-----END PGP SIGNATURE-----

--nextPart2176430.HocaZGP0YN--
