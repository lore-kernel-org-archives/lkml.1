Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbYIPOnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbYIPOnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYIPOnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:43:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:25676 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbYIPOnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:43:09 -0400
Date: Tue, 16 Sep 2008 17:43:45 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] linux/inotify.h: do not include <linux/fcntl.h> in
	userspace
Message-ID: <20080916144344.GE17082@localhost.localdomain>
References: <1221567763-17060-1-git-send-email-kirill@shutemov.name> <20080916125802.GA15951@cs181140183.pp.htv.fi> <20080916130234.GA17082@localhost.localdomain> <48CFBE51.1060200@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EXKGNeO8l0xGFBjy"
Content-Disposition: inline
In-Reply-To: <48CFBE51.1060200@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2008 at 07:10:25AM -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>=20
> Kirill A. Shutemov wrote:
> >> What is the error message?
> >=20
> > /usr/include/asm-generic/fcntl.h:117: error: redefinition of 'struct
> > flock'
>=20
> And?  None of these programs should use <linux/inotify.h>.  There has
> for the longest time been a <sys/inotify.h> header which doesn't need
> any kernel headers.  In fact, <linux/inotify.h> should not be exported.

Ok. Let's unexport <linux/inotify.h>.

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index b68ec09..dbb8107 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -240,7 +240,6 @@ unifdef-y +=3D igmp.h
 unifdef-y +=3D inet_diag.h
 unifdef-y +=3D in.h
 unifdef-y +=3D in6.h
-unifdef-y +=3D inotify.h
 unifdef-y +=3D input.h
 unifdef-y +=3D ip.h
 unifdef-y +=3D ipc.h
diff --git a/include/linux/inotify.h b/include/linux/inotify.h
index bd57857..0188b6a 100644
--- a/include/linux/inotify.h
+++ b/include/linux/inotify.h
@@ -10,6 +10,8 @@
 /* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 #include <linux/types.h>
+#include <linux/dcache.h>
+#include <linux/fs.h>
=20
 /*
  * struct inotify_event - structure read from the inotify device for each =
event
@@ -69,11 +71,6 @@ struct inotify_event {
 #define IN_CLOEXEC O_CLOEXEC
 #define IN_NONBLOCK O_NONBLOCK
=20
-#ifdef __KERNEL__
-
-#include <linux/dcache.h>
-#include <linux/fs.h>
-
 /*
  * struct inotify_watch - represents a watch request on a specific inode
  *
@@ -230,6 +227,4 @@ static inline void put_inotify_watch(struct inotify_wat=
ch *watch)
=20
 #endif	/* CONFIG_INOTIFY */
=20
-#endif	/* __KERNEL __ */
-
 #endif	/* _LINUX_INOTIFY_H */

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--EXKGNeO8l0xGFBjy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjPxiAACgkQbWYnhzC5v6r9ugCePHgekSA09P6xXQafeKfiNFSz
CBsAn33khQS6veaAKKTZGiR7IxxTqC7I
=a/es
-----END PGP SIGNATURE-----

--EXKGNeO8l0xGFBjy--
