Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYIOU1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYIOU1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 16:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYIOU0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 16:26:53 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59222 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbYIOU0x (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 16:26:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: roel kluin <roel.kluin@gmail.com>
Cc: ak@linux.intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH ?] ACPI: pr->id is unsigned
In-Reply-To: Your message of "Mon, 15 Sep 2008 21:32:20 EDT."
             <48CF0CA4.3090701@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <48CF0CA4.3090701@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221510405_46396P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Sep 2008 16:26:45 -0400
Message-ID: <128370.1221510405@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221510405_46396P
Content-Type: text/plain; charset=us-ascii

On Mon, 15 Sep 2008 21:32:20 EDT, roel kluin said:
> since pr->id is unsigned, shouldn't something like
> the patch below be applied?

> +	BUG_ON((pr->id >= nr_cpu_ids) || ((unsigned long)pr->id < 0));

Under what conditions will the clause "(unsigned long)pr->id < 0)" be true,
and when will it be false?  What will any sane optimizing compiler do?

And *sometimes*, the *real* bug is that pr->id should be a signed quantity,
not an unsigned one, and the cast is just papering over the issue.

In other words, the original line is almost certainly buggy.  However, this
isn't the right fix.  Somebody who actually understands the code will have to
decide what *should* be happening here (that's beyond my understanding of that
code)...


--==_Exmh_1221510405_46396P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIzsUFcC3lWbTT17ARArJPAKCEnFhDVOCMxtQ86V2Q8qigQM3prwCfRGC8
hoXD8gfILFmJ7egOBV7RcCg=
=pL/0
-----END PGP SIGNATURE-----

--==_Exmh_1221510405_46396P--
