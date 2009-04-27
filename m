Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbZD0A6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbZD0A6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 20:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZD0A6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 20:58:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:53130 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbZD0A6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 20:58:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,250,1239001200"; 
   d="asc'?scan'208";a="407076817"
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090424100943.GJ27264@erda.amd.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>
	 <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com>
	 <1240553210.6842.871.camel@yhuang-dev.sh.intel.com>
	 <20090424100943.GJ27264@erda.amd.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CwbQV1UOdGAcTdwduwRf"
Date: Mon, 27 Apr 2009 08:58:12 +0800
Message-Id: <1240793892.6842.923.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CwbQV1UOdGAcTdwduwRf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-24 at 18:09 +0800, Robert Richter wrote:
> On 24.04.09 14:06:50, Huang Ying wrote:
> > On Wed, 2009-04-22 at 18:16 +0800, Robert Richter wrote:
> > > On 22.04.09 11:22:59, Ingo Molnar wrote:
> > > >=20
> > > > * Huang Ying <ying.huang@intel.com> wrote:
> > > >=20
> > > > > Re-implement MCE log ring buffer as per-CPU ring buffer for bette=
r=20
> > > > > scalability. Basic design is as follow:
> > > >=20
> > > > Before changing anything substantial in the MCE code it would be=20
> > > > necessary to clean up and then unify the 32-bit and 64-bit side of=20
> > > > the MCE code first. (Which essentially means extending the=20
> > > > 64-bit-only code to 32-bit)
> > >=20
> > > You may also want to consider to use the in-kernel ring_buffer api
> > > (include/linux/ring_buffer.h).
> >=20
> > It seems that ring_buffer is not NMI-safe, while mcelog buffer will be
> > used in NMI context and interrupt context. When will ring_buffer to be
> > NMI-safe?
>=20
> You can use it in nmi context with separate read and write
> buffers. See this patch description:
> 6dad828b76c7224a22ddc9ce7aa495d994f03b31

You use it as oprofile CPU buffer. There is only one reader and one
writer for oprofile CPU buffer, so separating read and write buffers is
sufficient for it to be used there. But there is multiple writer for
MCELOG buffer (from NMI, IRQ and timer), so I think your method doesn't
work here.

Best Regards,
Huang Ying


--=-CwbQV1UOdGAcTdwduwRf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn1Ax4ACgkQKhFGF+eHlpixwwCgnxCnJbiMNwhyd7aK5vv3hQ2X
o44AoI2MuSzSaxDK9b6QGtFcuuTY8qTq
=Zg/C
-----END PGP SIGNATURE-----

--=-CwbQV1UOdGAcTdwduwRf--

