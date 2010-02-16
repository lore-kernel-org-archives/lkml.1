Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab0BPMdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 07:33:23 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:38185 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab0BPMdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 07:33:21 -0500
X-Spam-ASN: 
Date: Tue, 16 Feb 2010 15:33:01 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH 1/8] pps: userland header file for PPS API.
Message-ID: <20100216153301.534f2722@desktopvm.lvknet>
In-Reply-To: <1266313885-1195-2-git-send-email-giometti@linux.it>
References: <1266313885-1195-1-git-send-email-giometti@linux.it>
	<1266313885-1195-2-git-send-email-giometti@linux.it>
Organization: LVK
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/oTzSCGWNDk6i/=X1+cmKaMr";
 protocol="application/pgp-signature"; micalg=PGP-SHA256
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/oTzSCGWNDk6i/=X1+cmKaMr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rodolfo,

On Tue, 16 Feb 2010 10:51:18 +0100
Rodolfo Giometti <giometti@linux.it> wrote:

> This patch adds into the PPS's documentation directory a possible
> implementation of the PPS API (RFC 2783) by using the LinuxPPS's char
> devices.
>=20
> This file is not just an example but it can be used into real
> systems. :)

Isn't libc a proper place for this file? This header file provides a
generic standardized interface (PPSAPI) to the custom Linux
implementation (linux/pps.h). I think this is just what libc is for.

I wanted to file a bug in Debian BTS last week to add this header to
libc6-dev package and also push it upstream but something distracted
me. If you agree that the header should be in libc then I can do it now.

> Signed-off-by: Rodolfo Giometti <giometti@linux.it>
> ---
>  Documentation/pps/timepps.h |  198
> +++++++++++++++++++++++++++++++++++++++++++ 1 files changed, 198
> insertions(+), 0 deletions(-) create mode 100644
> Documentation/pps/timepps.h
>=20
> diff --git a/Documentation/pps/timepps.h b/Documentation/pps/timepps.h
> new file mode 100644
> index 0000000..d2628d2
> --- /dev/null
> +++ b/Documentation/pps/timepps.h
> @@ -0,0 +1,198 @@
> +/*
> + * timepps.h -- PPS API main header
> + *
> + * Copyright (C) 2005-2007   Rodolfo Giometti <giometti@linux.it>
> + *
> + *   This program is free software; you can redistribute it and/or
> modify
> + *   it under the terms of the GNU General Public License as
> published by
> + *   the Free Software Foundation; either version 2 of the License,
> or
> + *   (at your option) any later version.
> + *
> + *   This program is distributed in the hope that it will be useful,
> + *   but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *   GNU General Public License for more details.
> + *
> + *   You should have received a copy of the GNU General Public
> License
> + *   along with this program; if not, write to the Free Software
> + *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef _SYS_TIMEPPS_H_
> +#define _SYS_TIMEPPS_H_
> +
> +#include <errno.h>
> +#include <sys/time.h>
> +#include <sys/ioctl.h>
> +#include <linux/types.h>
> +#include <linux/pps.h>
> +
> +#define LINUXPPS	1		/* signal we are using
> LinuxPPS */ +
> +/*
> + * New data structures
> + */
> +
> +struct ntp_fp {
> +	unsigned int integral;
> +	unsigned int fractional;
> +};
> +
> +union pps_timeu {
> +	struct timespec tspec;
> +	struct ntp_fp ntpfp;
> +	unsigned long longpad[3];
> +};
> +
> +struct pps_info {
> +	unsigned long assert_sequence;	/* seq. num. of assert
> event */
> +	unsigned long clear_sequence;	/* seq. num. of clear
> event */
> +	union pps_timeu assert_tu;	/* time of assert event */
> +	union pps_timeu clear_tu;	/* time of clear event */
> +	int current_mode;		/* current mode bits */
> +};
> +
> +struct pps_params {
> +	int api_version;		/* API version # */
> +	int mode;			/* mode bits */
> +	union pps_timeu assert_off_tu;	/* offset compensation
> for assert */
> +	union pps_timeu clear_off_tu;	/* offset compensation
> for clear */ +};
> +
> +typedef int pps_handle_t;		/* represents a PPS source
> */ +typedef unsigned long pps_seq_t;	/* sequence number */
> +typedef struct ntp_fp ntp_fp_t;		/* NTP-compatible
> time stamp */ +typedef union pps_timeu pps_timeu_t;	/* generic
> data type for time stamps */ +typedef struct pps_info pps_info_t;
> +typedef struct pps_params pps_params_t;
> +
> +#define assert_timestamp        assert_tu.tspec
> +#define clear_timestamp         clear_tu.tspec
> +
> +#define assert_timestamp_ntpfp  assert_tu.ntpfp
> +#define clear_timestamp_ntpfp   clear_tu.ntpfp
> +
> +#define assert_offset		assert_off_tu.tspec
> +#define clear_offset		clear_off_tu.tspec
> +
> +#define assert_offset_ntpfp     assert_off_tu.ntpfp
> +#define clear_offset_ntpfp      clear_off_tu.ntpfp
> +
> +/*
> + * The PPS API
> + */
> +
> +static __inline int time_pps_create(int source, pps_handle_t *handle)
> +{
> +	int ret;
> +	struct pps_kparams dummy;
> +
> +	if (!handle) {
> +		errno =3D EINVAL;
> +		return -1;
> +	}
> +
> +	/* First we check if current device is a valid PPS one by
> +	 * doing a dummy PPS_GETPARAMS...
> +	 */
> +	ret =3D ioctl(source, PPS_GETPARAMS, &dummy);
> +	if (ret) {
> +		errno =3D EOPNOTSUPP;
> +		return -1;
> +	}
> +
> +	/* ... then since in LinuxPPS there are no differences
> between a
> +	 * "PPS source" and a "PPS handle", we simply return the
> same value.
> +	 */
> +	*handle =3D source;
> +
> +	return 0;
> +}
> +
> +static __inline int time_pps_destroy(pps_handle_t handle)
> +{
> +	return close(handle);
> +}
> +
> +static __inline int time_pps_getparams(pps_handle_t handle,
> +					pps_params_t *ppsparams)
> +{
> +	int ret;
> +	struct pps_kparams __ppsparams;
> +
> +	ret =3D ioctl(handle, PPS_GETPARAMS, &__ppsparams);
> +
> +	ppsparams->api_version =3D __ppsparams.api_version;
> +	ppsparams->mode =3D __ppsparams.mode;
> +	ppsparams->assert_off_tu.tspec.tv_sec =3D
> __ppsparams.assert_off_tu.sec;
> +	ppsparams->assert_off_tu.tspec.tv_nsec =3D
> __ppsparams.assert_off_tu.nsec;
> +	ppsparams->clear_off_tu.tspec.tv_sec =3D
> __ppsparams.clear_off_tu.sec;
> +	ppsparams->clear_off_tu.tspec.tv_nsec =3D
> __ppsparams.clear_off_tu.nsec; +
> +	return ret;
> +}
> +
> +static __inline int time_pps_setparams(pps_handle_t handle,
> +					const pps_params_t
> *ppsparams) +{
> +	struct pps_kparams __ppsparams;
> +
> +	__ppsparams.api_version =3D ppsparams->api_version;
> +	__ppsparams.mode =3D ppsparams->mode;
> +	__ppsparams.assert_off_tu.sec =3D
> ppsparams->assert_off_tu.tspec.tv_sec;
> +	__ppsparams.assert_off_tu.nsec =3D
> ppsparams->assert_off_tu.tspec.tv_nsec;
> +	__ppsparams.clear_off_tu.sec =3D
> ppsparams->clear_off_tu.tspec.tv_sec;
> +	__ppsparams.clear_off_tu.nsec =3D
> ppsparams->clear_off_tu.tspec.tv_nsec; +
> +	return ioctl(handle, PPS_SETPARAMS, &__ppsparams);
> +}
> +
> +/* Get capabilities for handle */
> +static __inline int time_pps_getcap(pps_handle_t handle, int *mode)
> +{
> +	return ioctl(handle, PPS_GETCAP, mode);
> +}
> +
> +static __inline int time_pps_fetch(pps_handle_t handle, const int
> tsformat,
> +					pps_info_t *ppsinfobuf,
> +					const struct timespec
> *timeout) +{
> +	struct pps_fdata __fdata;
> +	int ret;
> +
> +	/* Sanity checks */
> +	if (tsformat !=3D PPS_TSFMT_TSPEC) {
> +		errno =3D EINVAL;
> +		return -1;
> +	}
> +
> +	if (timeout) {
> +		__fdata.timeout.sec =3D timeout->tv_sec;
> +		__fdata.timeout.nsec =3D timeout->tv_nsec;
> +		__fdata.timeout.flags =3D ~PPS_TIME_INVALID;
> +	} else
> +		__fdata.timeout.flags =3D PPS_TIME_INVALID;
> +
> +	ret =3D ioctl(handle, PPS_FETCH, &__fdata);
> +
> +	ppsinfobuf->assert_sequence =3D __fdata.info.assert_sequence;
> +	ppsinfobuf->clear_sequence =3D __fdata.info.clear_sequence;
> +	ppsinfobuf->assert_tu.tspec.tv_sec =3D
> __fdata.info.assert_tu.sec;
> +	ppsinfobuf->assert_tu.tspec.tv_nsec =3D
> __fdata.info.assert_tu.nsec;
> +	ppsinfobuf->clear_tu.tspec.tv_sec =3D
> __fdata.info.clear_tu.sec;
> +	ppsinfobuf->clear_tu.tspec.tv_nsec =3D
> __fdata.info.clear_tu.nsec;
> +	ppsinfobuf->current_mode =3D __fdata.info.current_mode;
> +
> +	return ret;
> +}
> +
> +static __inline int time_pps_kcbind(pps_handle_t handle,
> +					const int kernel_consumer,
> +					const int edge, const int
> tsformat) +{
> +	/* LinuxPPS doesn't implement kernel consumer feature */
> +	errno =3D EOPNOTSUPP;
> +	return -1;
> +}
> +
> +#endif				/* _SYS_TIMEPPS_H_ */


--=20
  Alexander

--Sig_/oTzSCGWNDk6i/=X1+cmKaMr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAEBCAAGBQJLepB9AAoJEElrwznyooJbB4sH/14H+a1RLtxu2A6Q7n1hY/8y
GdXhqnj/frcA0FpIDtEyz2sf2qJYc8973C18jmGXw38plbdMix03MUCqPNyc/+zt
AcJTPUAMYhTbyc9b2p8KwlqoQeyy5rp0cleZsAiOpxDLoXqckEtONDncOJzB1YgT
pWosvjEyVzl/SI5cb/11H7g8A3TSkgaN5tqBP+NvjZ5TTd88GKatAkDoegHkcEHY
L+LTPdSm7xTIOMYYxDFQarrW7BFoG7qBkrGPj3MsNPRZ5n0ZV1VsMuppzpbUzbLt
IxLr5Vv8nwpJVE+aXOEcbjTeiAGZghsY8pD364t7IK5j3/5LBvBTBtsLxeo7N+A=
=0/k6
-----END PGP SIGNATURE-----

--Sig_/oTzSCGWNDk6i/=X1+cmKaMr--
