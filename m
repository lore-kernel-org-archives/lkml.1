Return-Path: <linux-kernel-owner+w=401wt.eu-S937515AbXHMDJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937515AbXHMDJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 23:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934597AbXHMDJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 23:09:40 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40255 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765553AbXHMDJj (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 23:09:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: roland <devzero@web.de>, linux-kernel@vger.kernel.org
Subject: Re: Software based ECC ?
In-Reply-To: Your message of "Sun, 12 Aug 2007 18:51:31 +0200."
             <20070812165131.GG7973@vanheusden.com>
From: Valdis.Kletnieks@vt.edu
References: <000a01c7db93$c75b66c0$eeeea8c0@aldipc> <12507.1186812675@turing-police.cc.vt.edu>
            <20070812165131.GG7973@vanheusden.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1186974562_3083P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 12 Aug 2007 23:09:22 -0400
Message-ID: <1599.1186974562@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1186974562_3083P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Aug 2007 18:51:31 +0200, Folkert van Heusden said:

> a question and an idea: Q: is ecc guaranteed to detect all bitflips?

It depends on the exact ECC function the hardware implements.  Usually it=

provides performance such as:

=22Correct all 1-bit errors. Detect all 2-bit errors, and most 3 and high=
er,
but not correct=22.

(Of course, =22correct all 1 or 2 bit and detect all 3 bit=22 can be done=
, it
just takes more bits of ECC.)

> Idea: what about a multicore system (3 or more) that runs the same
> processes on 2 cores and a third core verifying that they both do the
> same? As I think it is not only ram that can become faulty.

This is actually done for high-reliability systems (Google for =22tell me=
 twice=22
and =22tell me three times=22).  The problem is that it takes a lot of ex=
tra
hardware.  The G5 and later IBM Z-series mainframe chipsets (not to be co=
nfused with
the PowerPC G5) implemented dual computation units and a comparator that
signals a 'Machine Check' condition if the two CPUs don't end up in the
same exact state (as an added bonus, at the end of each instruction that
both *do* compare good, it latches the *entire* state of the CPU out,
and then does the following:

1) Retry the instruction on the same CPU - if it compares correctly, keep=

going and flag a =22soft=22 error.

2) If it still fails, read out the last =22known good=22 status latch, an=
d load
it into a spare CPU, and fire it up, and flag the failing one as bad.

http://www.research.ibm.com/journal/rd/435/spainhower.pdf
http://www.research.ibm.com/journal/rd/435/mueller.pdf

These guys have forgotten more about designing highly reliable systems th=
an
most of us will ever know. ;)

Needless to say, not everybody is willing to pay the costs of the hardwar=
e
overhead of this approach. =20


--==_Exmh_1186974562_3083P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGv8ticC3lWbTT17ARAmI1AJ9PPC/CTlMpnG065/VtTLy8VrYSLQCfTQnd
3+L0T2eHKaJXIePv83UxsQM=
=5t4x
-----END PGP SIGNATURE-----

--==_Exmh_1186974562_3083P--
