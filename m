Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZGNRSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZGNRSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbZGNRSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:18:45 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:53051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbZGNRSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:18:44 -0400
Subject: event tracing, ringbuffer and RB_MAX_SMALL_DATA
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BAVhum20oFEw9e1G+qMl"
Date: Tue, 14 Jul 2009 19:18:11 +0200
Message-Id: <1247591891.7178.20.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BAVhum20oFEw9e1G+qMl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

By code inspection, I think there's a bug if your event contains only

	__dynamic_array(u8, buf, buflen)

and your buflen is only, say, 3. Then the event size will be the common
event size (12 bytes) plus this, so 15, which is well below
RB_MAX_SMALL_DATA (4*28 =3D 112), so it'll be divided by four to be stored
into type_len. At this point, however, you've lost the information that
your dynamic array was only three bytes, and it'll be considered _four_
bytes long by parsers as far as I can tell?

johannes

--=-BAVhum20oFEw9e1G+qMl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXL3PAAoJEODzc/N7+QmaHFMP/RL6Xb4+aVAMoIR2jw0REU5w
mo+lfvKhPJP9Hk7IaMnHiK4KVdhpiJc19zEvx9i5RpaV2+INZ+PwEGsNOo2SyUg8
Lw8MMleZEkt0ddSFcrs9Te6ewfvXVRUKzXd4ycfV+eVyWimT9ixXQ1gKFhWtkJxQ
H93X9iksogRsRP+zZuyqhNv2q81oUvIdutvE2TtLGuK6rmJDh+5F8MHAz4FxV8r0
3Ix2/b24giz2tJtWrts2QJDqqj/0LGZh9DjWgzWNlg6OSkA1kB4W8+A+Mk4VXFei
LiAnaxRNR67h3mOiE/vLwz8sajoXoamcsWKbY7fWYGmQ0uHrWNjLFQi3/9DMDJG3
YhIXdIMcxlbXEKwU/vhgs+URKyddEFRF6uUt/+v19++O2AWKA7VTdC+e9kmvHvJQ
jUdvb5AiWAL24N61cuVMyIbjZRPMr+s0MdZxT0fB5jQlo8jknFdm1GeG/5E900lT
m2SWj1BkhGAx8cSQMLAt8wED8B2xFkTqSz7FxppeUo2SrnaY2PBt0tTMsnXGu2Ph
mNlY11sMiib77O+50nYlzsl+MAEt9LeIN5pTlBaFEe0466++2T0zV2kB4f66HRxr
ikrBowKbNsM+68wSdqCsH5lRqMW2HBDRKVKedcs1O5Alzx5Kq8X8dFE+HS2FHcGT
AY4t5NP1aDtiOUM5lSRm
=CuBi
-----END PGP SIGNATURE-----

--=-BAVhum20oFEw9e1G+qMl--

