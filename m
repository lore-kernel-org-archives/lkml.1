Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbZD0PPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbZD0PPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932357AbZD0PNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:13:36 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53007 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293AbZD0PNe (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:13:34 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: [PATCH 1/3] bitops: Add __ffs64 bitop
In-Reply-To: Your message of "Thu, 23 Apr 2009 10:16:54 BST."
             <1240478216-2594-2-git-send-email-swhiteho@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1240478216-2594-1-git-send-email-swhiteho@redhat.com>
            <1240478216-2594-2-git-send-email-swhiteho@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1240839635_3889P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Apr 2009 09:40:35 -0400
Message-ID: <52615.1240839635@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1240839635_3889P
Content-Type: text/plain; charset=us-ascii

On Thu, 23 Apr 2009 10:16:54 BST, Steven Whitehouse said:
> Finds the first set bit in a 64 bit word. This is required in order
> to fix a bug in GFS2, but I think it should be a generic function
> in case of future users.

Seems like a sane idea..

> +static inline unsigned long __ffs64(u64 word)
> +{
> +#if BITS_PER_LONG == 32
> +	if (((u32)word) == 0UL)
> +		return __ffs((u32)(word >> 32)) + 32;
> +#elif BITS_PER_LONG != 64
> +#error BITS_PER_LONG not 32 or 64
> +#endif
> +	return __ffs((unsigned long)word);
> +}
> +

Does this have endian-ness issues (is that (u32)word the "high" or "low"
part)?  Or is this intended only for looking at bitmaps and the like, and we
don't really care?

--==_Exmh_1240839635_3889P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ9bXTcC3lWbTT17ARAihoAKC6ERc+qjF7uDoBiuSGm8TW0abcQwCg8tzd
y66eZxEph7uBtFNOqEb8rlU=
=HEvh
-----END PGP SIGNATURE-----

--==_Exmh_1240839635_3889P--
