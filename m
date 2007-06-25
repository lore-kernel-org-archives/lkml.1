Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbXFYUqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbXFYUqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbXFYUqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:46:34 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47615 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbXFYUqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:46:33 -0400
X-Sasl-enc: JZv4nZJF/eRxToBgzSL/qsZ9UUwP0NJ/Ch+w1mPCarK5 1182804391
Message-ID: <46802A98.4030407@imap.cc>
Date: Mon, 25 Jun 2007 22:50:32 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
References: <10876.1182698167@lwn.net>  <467FF23B.30509@imap.cc> <1182791203.5493.161.camel@localhost.localdomain>
In-Reply-To: <1182791203.5493.161.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAEC128417FD881998CB234FF"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAEC128417FD881998CB234FF
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 25.06.2007 19:06 schrieb Steven Rostedt:
> On Mon, 2007-06-25 at 18:50 +0200, Tilman Schmidt wrote:
>=20
>> The Siemens Gigaset ISDN base driver uses tasklets in its isochronous
>> data paths. [...]
>> Does that qualify as performance sensitive for the purpose of this
>> discussion?
>=20
> Actually, no.  16ms, even 8ms is an incredible amount of time. Unless
> you have a thread that is running at a higher priority than the thread
> that handles the work queue performing the task, you would have no
> problems making that deadline.

Ok, I'm reassured. I'll look into converting these to a work queue
then, although I can't promise when I'll get around to it.

In fact, if these timing requirements are so easy to meet, perhaps
it doesn't even need its own work queue, and just making each
tasklet into a work item and queueing them to the global queue
with schedule_work() would do? Or am I getting too reckless now?

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigAEC128417FD881998CB234FF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGgCqfMdB4Whm86/kRAgPuAJ0bsDe8Mf+d9mc3e33262HvJ9MYqgCeLcNg
a43MDFI4n0ZeUoOQVAxGav4=
=TsdQ
-----END PGP SIGNATURE-----

--------------enigAEC128417FD881998CB234FF--
