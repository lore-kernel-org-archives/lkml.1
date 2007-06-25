Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbXFYQqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbXFYQqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 12:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXFYQqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 12:46:09 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51158 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752259AbXFYQqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 12:46:08 -0400
X-Sasl-enc: c9HCShJztjHNVVE5rapmXicFwECjVfZ5aemepd0BhrbM 1182789965
Message-ID: <467FF23B.30509@imap.cc>
Date: Mon, 25 Jun 2007 18:50:03 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
References: <10876.1182698167@lwn.net>
In-Reply-To: <10876.1182698167@lwn.net>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4DA18C48116D20E570EC0C26"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4DA18C48116D20E570EC0C26
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Ingo Molnar <mingo@elte.hu> wrote:
> so how about the following, different approach: anyone who has a taskle=
t=20
> in any performance-sensitive codepath, please yell now.

The Siemens Gigaset ISDN base driver uses tasklets in its isochronous
data paths. These will be scheduled for each completion of an isochronous=

URB, or every 8 msec for each of the four isochronous pipes if both B
channels are connected. The driver uses three URBs for each pipe, always
maintaining two in flight while processing the third one. So the tasklet
has to run within 16 ms from being scheduled in order to avoid packet
loss (in the receive path) or data underrun (in the transmit path).

Does that qualify as performance sensitive for the purpose of this
discussion?

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig4DA18C48116D20E570EC0C26
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGf/JFMdB4Whm86/kRAkJRAJ9o9FaCDzkaJyfF+TMgAGEiMG0BEgCfaSQP
K/wyzK8jxxKyPqWBbmwuvN8=
=GHK5
-----END PGP SIGNATURE-----

--------------enig4DA18C48116D20E570EC0C26--
