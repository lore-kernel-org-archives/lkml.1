Return-Path: <linux-kernel-owner+w=401wt.eu-S1764569AbXLOHyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764569AbXLOHyP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 02:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbXLOHyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 02:54:05 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:46136 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072AbXLOHyE (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 02:54:04 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: /dev/urandom uses uninit bytes, leaks user data
In-Reply-To: Your message of "Fri, 14 Dec 2007 23:20:30 PST."
             <977119.41267.qm@web52005.mail.re2.yahoo.com>
From: Valdis.Kletnieks@vt.edu
References: <977119.41267.qm@web52005.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1197705241_8442P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 15 Dec 2007 02:54:01 -0500
Message-ID: <28540.1197705241@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1197705241_8442P
Content-Type: text/plain; charset=us-ascii

On Fri, 14 Dec 2007 23:20:30 PST, Matti Linnanvuori said:
> From: Matti Linnanvuori <mattilinnnvuori@yahoo.com>
> 
> /dev/urandom use no uninit bytes, leak no user data
> 
> Signed-off-by: Matti Linnanvuori <mattilinnnvuori@yahoo.com>
> 
> ---
> 
> --- a/drivers/char/random.c	2007-12-15 09:09:37.895414000 +0200
> +++ b/drivers/char/random.c	2007-12-15 09:12:02.607831500 +0200
> @@ -689,7 +689,7 @@ static ssize_t extract_entropy(struct en
>   */
>  static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
>  {
> -	__u32 tmp[OUTPUT_POOL_WORDS];
> +	static __u32 tmp[OUTPUT_POOL_WORDS];

This looks like a race waiting to happen - what lock is held so we don't have
'tmp' smashed by 2 instances on different CPUs (not a problem when each
instance lives on a hopefully separate stack)?

--==_Exmh_1197705241_8442P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHY4gZcC3lWbTT17ARAixZAJ0SB4Ql7S1NVUTmQEPxB+XSCpviVgCcCw6i
OLqmJSMDuhqxos+gY4TohyA=
=USA9
-----END PGP SIGNATURE-----

--==_Exmh_1197705241_8442P--
