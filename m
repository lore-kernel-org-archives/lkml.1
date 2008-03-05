Return-Path: <linux-kernel-owner+w=401wt.eu-S1761376AbYCEG0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbYCEG0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYCEG00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:26:26 -0500
Received: from mga01.intel.com ([192.55.52.88]:60368 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbYCEG0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:26:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,448,1199692800"; 
   d="asc'?scan'208";a="528924926"
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: multipart/signed;
	micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-pcy90QeOO67DHgEh5MGa"
Content-class: urn:content-classes:message
Subject: Re: CLONE_NEWNS and bind mounts to make "chroot" jail
Date: Tue, 4 Mar 2008 22:23:28 -0800
Message-ID: <1204698208.30451.5.camel@mleibowi.jf.intel.com>
In-Reply-To: <20080304214500.GA7035@vino.hallyn.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: CLONE_NEWNS and bind mounts to make "chroot" jail
thread-index: Ach+idW33Xr79DcqRQa0BhUiGDZlTA==
References: <645B0EE4078B7C49A6C12F5E7B3B6C2603D3D607@orsmsx418.amr.corp.intel.com> <20080302022655.GA28450@vino.hallyn.com> <645B0EE4078B7C49A6C12F5E7B3B6C2603D3D7BF@orsmsx418.amr.corp.intel.com> <20080304214500.GA7035@vino.hallyn.com>
From: "Leibowitz, Michael" <michael.leibowitz@intel.com>
To: <serge@hallyn.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Mar 2008 06:26:24.0638 (UTC) FILETIME=[D605C1E0:01C87E89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pcy90QeOO67DHgEh5MGa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I'm not 100% sure if this is what you meant, but I did get the following
to work:=20

chdir("/jail");=20
unshare(CLONE_NEWNS);
mount("/jail", "/jail", NULL, MS_BIND, NULL);
pivot_root("/jail", "/jail/old_root");
chdir("/");
mount("/old_root/bin", "bin", NULL, MS_BIND, NULL);
mount("/old_root/usr", "usr", NULL, MS_BIND, NULL);
mount("/old_root/lib", "lib", NULL, MS_BIND, NULL);
umount2("/old_root", MNT_DETACH);
exec("/busybox");

Thanks for the help. =20

On Tue, 2008-03-04 at 15:45 -0600, serge@hallyn.com wrote:
> Quoting Leibowitz, Michael (michael.leibowitz@intel.com):
> Yes, you
> 	cd /jail
> 	mount --bind /jail /jail
> 	pivot_root . old_root
>=20
> but . is now mounted over.
> >   char *newargv[]=3D { "sh", NULL };
> >=20
> >   chdir("/jail");
> >   unshare(CLONE_NEWNS));
> >   mount("/jail", "/jail", NULL, MS_BIND, NULL));
> >   mount("/bin", "bin", NULL, MS_BIND, NULL));
> >   mount("/usr", "usr", NULL, MS_BIND, NULL));
> >   mount("/lib", "lib", NULL, MS_BIND, NULL));
> >   if (pivot_root(".", "old_root")) perror("pivot_root . old_root");
> >   exec("./bash-static"); /* copied to /jail prior to running */

--=20
Michael Leibowitz <michael.leibowitz@intel.com>

--=-pcy90QeOO67DHgEh5MGa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHzjxghsRWNpQAGLwRAs4JAJ4idSY7jp6CKW2GQGNQTmY9sZsiggCeNgoR
zPSLgj8xLzPG3L8H1Mzr5B0=
=pdLl
-----END PGP SIGNATURE-----

--=-pcy90QeOO67DHgEh5MGa--
