Return-Path: <linux-kernel-owner+w=401wt.eu-S1751001AbZHSIeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbZHSIeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 04:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZHSIeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 04:34:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55357 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZHSIeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 04:34:07 -0400
Date: Wed, 19 Aug 2009 18:34:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Subject: linux-next: usb tree build failure
Message-Id: <20090819183402.77be5c3b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__19_Aug_2009_18_34_02_+1000_6dtHwFTBw.qz94vc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Aug_2009_18_34_02_+1000_6dtHwFTBw.qz94vc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (x86_64 allmodconfig) failed like this:

arch/x86/built-in.o: In function `setup_early_printk':
early_printk.c:(.init.text+0x159de): undefined reference to `early_dbgp_ini=
t'
early_printk.c:(.init.text+0x159f9): undefined reference to `early_dbgp_con=
sole'

Caused by commit 77f162cc16ff4bff1adefe47dbe48ab6b2d9247b ("USB: ehci
early_printk: split ehci debug driver from early_printk.c").

I have reverted that commit for today (along with commits
37e541af790703d66ba88cf3a71b5ae97654b753 ("USB: early_printk: insert cr
prior to nl as needed"), 71c0553ae63d2738a126d4f5b37730dfaa7a2fd7 ("USB:
ehci-dbgp: Execute early BIOS hand off"),
3f038d06f259fd02142aaaaa47addfb4934d4faa ("USB: early_printk: EHCI debug
controller initialization delays") and
f6ee359e79de27b46213f8b5293251a26bc22b1e ("USB: ehci-dbgp: stability
improvements and external re-init") that depended on it).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__19_Aug_2009_18_34_02_+1000_6dtHwFTBw.qz94vc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqLuPoACgkQjjKRsyhoI8wLLQCeKLt+IOjH32MYuuRY4oF86J9P
+UoAn3tLzWu+WeC34gUOll9URv1TNgfh
=GPJJ
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Aug_2009_18_34_02_+1000_6dtHwFTBw.qz94vc--
