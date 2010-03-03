Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab0CCMJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 07:09:26 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:59195 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab0CCMJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 07:09:25 -0500
Date: Wed, 3 Mar 2010 12:09:20 +0000
From: Eric B Munson <ebmunson@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus@samba.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Add ID and STREAM_ID to recorded event data
Message-ID: <20100303120920.GA3502@us.ibm.com>
References: <cover.1267537676.git.ebmunson@us.ibm.com>
 <71583fc64cb167adcdb0039b53b8bc76fed21f80.1267537676.git.ebmunson@us.ibm.com>
 <1267541905.25158.64.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <1267541905.25158.64.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Mar 2010, Peter Zijlstra wrote:

> On Tue, 2010-03-02 at 14:42 +0000, Eric B Munson wrote:
> > Currently perf record does not write the ID or the STREAM_ID to disk
> > for events.  This doesn't allow report to tell if an event stream conta=
ins
> > one or more types of events.  This patch adds these two entries to the =
list
> > of data that record will write to disk.
> >=20
> > Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> > ---
> >  tools/perf/builtin-record.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > index 771533c..35e4605 100644
> > --- a/tools/perf/builtin-record.c
> > +++ b/tools/perf/builtin-record.c
> > @@ -242,7 +242,8 @@ static void create_counter(int counter, int cpu, pi=
d_t pid)
> >  				  PERF_FORMAT_TOTAL_TIME_RUNNING |
> >  				  PERF_FORMAT_ID;
> > =20
> > -	attr->sample_type	|=3D PERF_SAMPLE_IP | PERF_SAMPLE_TID;
> > +	attr->sample_type	|=3D PERF_SAMPLE_IP | PERF_SAMPLE_TID |
> > +				   PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID;
> > =20
> >  	if (freq) {
> >  		attr->sample_type	|=3D PERF_SAMPLE_PERIOD;
>=20
> can we make this conditional on there being more than one event, that
> saves a little space/time when recording
>=20

The downside to this is report cannot print the name of the event being mon=
itored
if we do not record the sample and stream id.  This is as report behaves cu=
rrently
and if that is okay then I will put out V2 with that included today.

--=20
Eric B Munson
IBM Linux Technology Center
ebmunson@us.ibm.com


--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuOUXAACgkQsnv9E83jkzpmHwCfYYJyL0W0ixgA2MwUZIczy4fP
q3oAn2EPqif6gXzPcbEPUISAZwvbO5RH
=YNQ3
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
