Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbXIYEqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbXIYEqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbXIYEp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:45:56 -0400
Received: from donetsk.donpac.ru ([80.254.111.38]:40790 "EHLO
	donetsk.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbXIYEpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:45:55 -0400
Date: Tue, 25 Sep 2007 08:45:50 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Dave Jones <davej@redhat.com>, Jonathan Campbell <jon@nerdgrounds.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Patches for tiny 386 kernels, again. Linux kernel
	2.6.22.7
Message-ID: <20070925044550.GA5419@pazke.donpac.ru>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jonathan Campbell <jon@nerdgrounds.com>,
	linux-kernel@vger.kernel.org
References: <46F77A85.6020202@nerdgrounds.com> <20070924190917.GG8127@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20070924190917.GG8127@redhat.com>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 267, 09 24, 2007 at 03:09:17PM -0400, Dave Jones wrote:
> On Mon, Sep 24, 2007 at 01:51:17AM -0700, Jonathan Campbell wrote:
>=20
>=20
>  > +#if defined(__i386__) && defined(CONFIG_DMI)
>  >  	dmi_check_system(acpi_dmi_table);
>  >  #endif
>  > =20
>  > +#ifdef CONFIG_DMI
>  >  	dmi_scan_machine();
>  > +#endif
>  > =20
>  > +#ifdef CONFIG_DMI
>  >  	/* Check and install the TSC clocksource */
>  >  	dmi_check_system(bad_tsc_dmi_table);
>  > +#endif
>  > =20
>  > +#ifdef CONFIG_DMI
>  >  	dmi_check_system(acpi_osl_dmi_table);
>  > +#endif
> =20
> Instead of adding all these ifdefs, we could just define
> add something along the lines of..
>=20
> #ifndef CONFIG_DMI
> #define dmi_check_system do {} while (0)
> #endif
>=20
> in some header, which hides the uglies away from the code
> whilst having the same net effect.

Let take a look at linux/dmi.h:

#ifdef CONFIG_DMI

extern int dmi_check_system(struct dmi_system_id *list);
extern char * dmi_get_system_info(int field);
extern struct dmi_device * dmi_find_device(int type, const char *name,
	struct dmi_device *from);
extern void dmi_scan_machine(void);
extern int dmi_get_year(int field);
extern int dmi_name_in_vendors(char *str);

#else

static inline int dmi_check_system(struct dmi_system_id *list) { return 0; }
static inline char * dmi_get_system_info(int field) { return NULL; }
static inline struct dmi_device * dmi_find_device(int type, const char *nam=
e,
	struct dmi_device *from) { return NULL; }
static inline int dmi_get_year(int year) { return 0; }
static inline int dmi_name_in_vendors(char *s) { return 0; }

#endif

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG+JJ+IWZCBzwS8mkRAqRKAJ9fHJSc90E4YvGS2FZWq2EHiN+p/QCdGM0j
M9jLMfWuaFhNBIj4IVYwspw=
=WcYO
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
