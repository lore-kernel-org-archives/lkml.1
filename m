Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbXIXFfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbXIXFfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 01:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbXIXFfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 01:35:44 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41269 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXIXFfo (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 01:35:44 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Uninline kcalloc()
In-Reply-To: Your message of "Sun, 23 Sep 2007 00:03:49 +0400."
             <20070922200349.GA2119@martell.zuzino.mipt.ru>
From: Valdis.Kletnieks@vt.edu
References: <20070922200349.GA2119@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190612108_7192P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Sep 2007 01:35:08 -0400
Message-ID: <25045.1190612108@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190612108_7192P
Content-Type: text/plain; charset=us-ascii

On Sun, 23 Sep 2007 00:03:49 +0400, Alexey Dobriyan said:

> -static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> -{
> -	if (n != 0 && size > ULONG_MAX / n)
> -		return NULL;
> -	return __kmalloc(n * size, flags | __GFP_ZERO);
> -}
> +void *kcalloc(size_t n, size_t size, gfp_t flags);

NAK.

This busticates some pretty subtle code in mm/slab.c that uses
uses __builtin_return_address() for debugging - if you do this, then
the "calling function" gets listed as "kcalloc()" rather than the much more
useful "function that called kcalloc()" (which is what you care about).

(I remember going around and around multiple times getting those stupid
inlines set up right, so that feature actually did something useful, otherwise
kcalloc and kzalloc didn't report where they were called from).

--==_Exmh_1190612108_7192P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG90yMcC3lWbTT17ARAhUmAKD1NezXzjJTOHtKZJ7YHvuXMi1KiACgled/
WGuYYIWqS11pqVlj/FPn4SU=
=lKUa
-----END PGP SIGNATURE-----

--==_Exmh_1190612108_7192P--
