Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbZFZFbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbZFZFbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 01:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZFZFbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 01:31:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35594 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbZFZFbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 01:31:06 -0400
Date: Fri, 26 Jun 2009 15:31:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: hid tree build failure
Message-Id: <20090626153100.de647d08.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Jun_2009_15_31_00_+1000_rOc.ENEUxaYezNms"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jun_2009_15_31_00_+1000_rOc.ENEUxaYezNms
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next build (sparc32 defconfig) failed like this:

drivers/hid/hid-core.c:862:34: error: macro "hid_dump_input" passed 3 argum=
ents, but takes just 2
drivers/hid/hid-core.c: In function 'hid_process_event':
drivers/hid/hid-core.c:862: error: 'hid_dump_input' undeclared (first use i=
n this function)
drivers/hid/hid-core.c:862: error: (Each undeclared identifier is reported =
only once
drivers/hid/hid-core.c:862: error: for each function it appears in.)
drivers/hid/hid-core.c:984:68: error: macro "hid_dump_input" passed 3 argum=
ents, but takes just 2
drivers/hid/hid-core.c: In function 'hid_set_field':
drivers/hid/hid-core.c:984: error: 'hid_dump_input' undeclared (first use i=
n this function)
drivers/hid/hid-core.c: In function 'hid_input_report':
drivers/hid/hid-core.c:1090: error: 'HID_DEBUG_BUFSIZE' undeclared (first u=
se in this function)

Caused by commit cd667ce24796700e1a0e6e7528efc61c96ff832e ("HID: use
debugfs for events/reports dumping") which modified the prototype for
hid_dump_input, but not the !CONFIG_DEBUG_FS version.  It also added
HID_DEBUG_BUFSIZE when CONFIG_DEBUG_FS, but used it otherwise.

I have reverted that commit for today (along with commit
a635f9dd83f3382577f4544a96df12356e951a40 ("HID: use debugfs for report
dumping descriptor") which doesn't build without the other one).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Jun_2009_15_31_00_+1000_rOc.ENEUxaYezNms
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpEXRQACgkQjjKRsyhoI8zJKQCgtLAYQTqNkOoTARRi1RiXqWdi
GN4AoKUlsqQG/5AEF2P+aijwqKgkZRg6
=YnSZ
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jun_2009_15_31_00_+1000_rOc.ENEUxaYezNms--
