Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbXKMScc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbXKMScc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 13:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754890AbXKMScP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 13:32:15 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:58290 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754221AbXKMScN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 13:32:13 -0500
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       aneesh.kumar@linux.vnet.ibm.com
In-Reply-To: <1194942872.20251.175.camel@ymzhang>
References: <1194601672.20251.60.camel@ymzhang>
	 <1194602064.6289.157.camel@twins>  <1194833640.20251.80.camel@ymzhang>
	 <1194860728.7179.6.camel@twins>  <1194861112.20251.124.camel@ymzhang>
	 <1194873980.7179.31.camel@twins>  <47386BC4.3050403@panasas.com>
	 <1194886100.9713.13.camel@twins>  <1194920362.20251.161.camel@ymzhang>
	 <1194942872.20251.175.camel@ymzhang>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jixY2X5tsF1O2qvaXIZ8"
Date: Tue, 13 Nov 2007 19:32:09 +0100
Message-Id: <1194978729.8255.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jixY2X5tsF1O2qvaXIZ8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-11-13 at 16:34 +0800, Zhang, Yanmin wrote:

> My new bisect captured 7c9e69faa28027913ee059c285a5ea8382e24b5d
> which caused the regression of iozone following run (3rd/4th... run after=
 mounting
> the ext3 partition).

Linus just reverted that commit with commit:

commit 0b832a4b93932103d73c0c3f35ef1153e288327b
Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
Date:   Tue Nov 13 08:07:31 2007 -0800

    Revert "ext2/ext3/ext4: add block bitmap validation"

    This reverts commit 7c9e69faa28027913ee059c285a5ea8382e24b5d, fixing up
    conflicts in fs/ext4/balloc.c manually.

    The cost of doing the bitmap validation on each lookup - even when the
    bitmap is cached - is absolutely prohibitive.  We could, and probably
    should, do it only when adding the bitmap to the buffer cache.  However=
,
    right now we are better off just reverting it.

    Peter Zijlstra measured the cost of this extra validation as a 85%
    decrease in cached iozone, and while I had a patch that took it down to
    just 17% by not being _quite_ so stupid in the validation, it was still
    a big slowdown that could have been avoided by just doing it right.



--=-jixY2X5tsF1O2qvaXIZ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHOe2oXA2jU0ANEf4RAlj3AJ48cpT32udaET5LAvwn5IM8U/ksfQCeNwDr
KkwtDAPVMw5ppgW2I50S9aA=
=Pjn6
-----END PGP SIGNATURE-----

--=-jixY2X5tsF1O2qvaXIZ8--

