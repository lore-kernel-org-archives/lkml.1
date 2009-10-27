Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbZJ0HBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbZJ0HBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755459AbZJ0HBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:01:46 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:53566 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbZJ0HBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:01:45 -0400
Subject: Re: [PATCH] net: Adjust softirq raising in __napi_schedule
From: Johannes Berg <johannes@sipsolutions.net>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless@vger.kernel.org,
       linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org,
       Michael Buesch <mb@bu3sch.de>, Oliver Hartkopp <oliver@hartkopp.net>
In-Reply-To: <4AE64441.7060008@imap.cc>
References: <4AD76184.6030900@gmail.com> <4ADF5710.4030505@imap.cc>
	 <20091021211906.GA11401@ami.dom.local>
	 <1256160330.12174.2.camel@johannes.local>
	 <20091021213947.GA12202@ami.dom.local>
	 <1256200021.12174.11.camel@johannes.local> <4AE1C00B.5010008@imap.cc>
	 <1256309191.12174.51.camel@johannes.local>
	 <20091026074126.GA6187@ff.dom.local>
	 <1256543054.28230.6.camel@johannes.local>
	 <20091026075438.GB6187@ff.dom.local>
	 <1256543932.28230.9.camel@johannes.local>  <4AE56217.3040708@imap.cc>
	 <1256547380.28230.17.camel@johannes.local>  <4AE64441.7060008@imap.cc>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6ch9KbQaLIJxH1wlGqDK"
Date: Tue, 27 Oct 2009 08:01:40 +0100
Message-ID: <1256626900.4237.2.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6ch9KbQaLIJxH1wlGqDK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-27 at 01:52 +0100, Tilman Schmidt wrote:

> > Any code (say ISDN code) that calls netif_rx() is clearly assuming to
> > always be running in (soft)irq context, otherwise it couldn't call
> > netif_rx() unconditionally. Agree so far?
>=20
> Well, in fact I'm not sure. :-) All I know is that in the ISDN case, no
> such assumption is explicitly stated anywhere. (The code in question is
> called from the rcvcallb_skb() callback method which the hardware driver
> calls when data has been received, and the description of that method in
> Documentation/isdn/INTERFACE does not say anything about the context in
> which it may be called.) The relevant code in drivers/isdn/i4l/isdn_ppp.c
> is rather old, perhaps even older than softirqs and the netif_rx() /
> netif_rx_ni() split. (Bear in mind that we are talking about the old
> ISDN4Linux subsystem which initially didn't even make it into the 2.6
> series because it was considered obsolete.) It seems quite possible to me
> that just no one ever thought about that question.

Heh :)

> > So now if you change the ISDN code to call netif_rx_ni(), you've change=
d
> > the assumption that the ISDN code makes -- that it is running in
> > (soft)irq context. Therefore, you need to verify that this is actually =
a
> > correct change, which is what I tried to say.
>=20
> Understood. However, the fact that the local_softirq_pending message is
> appearing would seem to indicate that this assumption was wrong to
> begin with, wouldn't it?

I thought it only recently started appearing with a new driver or
something, but I may have misunderstood you. Anyway, I think that sums
up the issue from my POV.

johannes

--=-6ch9KbQaLIJxH1wlGqDK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5prQAAoJEODzc/N7+QmauwkQANCskBVoH8XtWB1eCnIoVb6v
tqkrME+6YSTmUicvRLv6Ci3jNWGmsnDF253/GUavqD8uZqWdKQnx3srkl6EbS8/t
X/je+cnc/zTVaTcjGZUYkL3lofLBzlwaE3jRCf8oMVKFn/HhaNvs2eMKKr/ckeOW
9emANyTor5anZUsNJaLXIi1qgVibyE9VGLCElKN4cYvGftc6uRCrRU923g/wzgK6
k41wjmSFW0NN4s7KCcuai2szbNSf9vB9Sb4spc2zbOmSY9r+TIoPVGw/vpPKNomz
IytG7O7kLOiLYBPCTeALBqWamZtOTNwG71EIEqSaTJE/GCz7CRs7QcL/OLJIQw/4
xWhf8Ln5tbUk2Nb1ZCzvNi5XUiqI3iC4ZC8Aym/CXarlQdCoDgqQJ0/M4Bo7k5Es
CETP98YH0U6b2l7/N13Ys+j39DyeBrG/d4SUPE1J1ffPd60zZ18Yo36XNjf1Syfu
aaWRFUSOyaqTNrWR0SlF3sajkzAtnp6ccmFXmX8q1J0rniEvtD/7GcQ5FfrOhZBY
uGx58WiNHfMirxmnowkv/mvnVLLSfoo+6GWVMVgLOqnRZ8geukJwapK6k1xQtfGG
oxMO0kJ6eNVRIQtp0/CNeU6q33qwp2aVRbzy1F4atlXNLMB2z7Gp6A3ykw8bE+nA
SL62Vg5JKLA8w9d/7hz1
=NgnP
-----END PGP SIGNATURE-----

--=-6ch9KbQaLIJxH1wlGqDK--

