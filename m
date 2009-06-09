Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbZFINeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbZFINeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZFINeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:34:03 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40171 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbZFINeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:34:02 -0400
Date: Tue, 9 Jun 2009 23:33:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: net/wireless tree build failure
Message-Id: <20090609233357.5d3801a0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_23_33_57_+1000_Cp8+li_LyWa4aXcp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_23_33_57_+1000_Cp8+li_LyWa4aXcp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John, Dave,

Today's linux-next build (pmac32 defconfig) failed like this:

In file included from drivers/net/wireless/b43/phy_common.h:5,
                 from drivers/net/wireless/b43/phy_common.c:30:
include/linux/rfkill.h: In function 'rfkill_alloc':
include/linux/rfkill.h:279: error: implicit declaration of function 'ERR_PT=
R'
include/linux/rfkill.h:279: warning: return makes pointer from integer with=
out a cast
include/linux/rfkill.h: In function 'rfkill_register':
include/linux/rfkill.h:284: warning: comparison between pointer and integer
In file included from include/linux/dma-mapping.h:6,
                 from arch/powerpc/include/asm/pci.h:16,
                 from include/linux/pci.h:1101,
                 from include/linux/ssb/ssb.h:9,
                 from drivers/net/wireless/b43/b43.h:9,
                 from drivers/net/wireless/b43/phy_common.c:35:
include/linux/err.h: At top level:
include/linux/err.h:22: error: conflicting types for 'ERR_PTR'
include/linux/rfkill.h:279: note: previous implicit declaration of 'ERR_PTR=
' was here

Probably caused by commit 19d337dff95cbf76edd3ad95c0cee2732c3e1ec5
("rfkill: rewrite") which added uses of ERR_PTR to inlines in rfkill.h
but did not include linux/err.h.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Jun_2009_23_33_57_+1000_Cp8+li_LyWa4aXcp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkouZMUACgkQjjKRsyhoI8wP7gCgomUIyx252X51QTy/yTD2osC0
FXcAnjadNQ7R+ty/A+03PBhOk5HCnY46
=q72Q
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_23_33_57_+1000_Cp8+li_LyWa4aXcp--
