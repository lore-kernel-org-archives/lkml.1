Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbZD0Qbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbZD0Qbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 12:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755801AbZD0Qbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 12:31:32 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60550 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbZD0Qbc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 12:31:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: [PATCH 1/3] bitops: Add __ffs64 bitop
In-Reply-To: Your message of "Mon, 27 Apr 2009 16:41:06 BST."
             <1240846866.29604.122.camel@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1240478216-2594-1-git-send-email-swhiteho@redhat.com> <1240478216-2594-2-git-send-email-swhiteho@redhat.com> <52615.1240839635@turing-police.cc.vt.edu>
            <1240846866.29604.122.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1240849877_4302P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Apr 2009 12:31:17 -0400
Message-ID: <49834.1240849877@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1240849877_4302P
Content-Type: text/plain; charset=us-ascii

On Mon, 27 Apr 2009 16:41:06 BST, Steven Whitehouse said:
> The intent was that it would operate on native endian u64 words so that
> it shouldn't be affected by the endianess.

Hmm.. it's passing a 64-bit by value, not by a pointer ref - a subtle
distinction - if that code had done   *(u32)word instead it would break
on some archs.  That will teach me to read code when not caffeinated enough.

(I also admit that often I post comments on the basis of "If I can misread
this, so can some other poor decaffienated Joe Programmer on a Monday morning" ;)

>                                            In the GFS2 code where it is
> used, the byte ordering is converted to native order before this
> function is applied,

Is that a reasonable expectation when other parts of the kernel start
using it?  We've seen bugs before when 32-bit code tries to deal with
a 64-bit or bigger bitfield as a pair or series of 32-bit fields...

- * @word: The 64 bit word
+ * @word: The 64 bit word - must be in native byte order

probably is enough for those who bother finding the function def/doc. And
the ones who don't bother, we can't help anyhow. ;)


--==_Exmh_1240849877_4302P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ9d3VcC3lWbTT17ARAh1eAKCTs/hKpXg+1EL3+rloGj5fOWEb1ACdHZwf
4dERfqM/kBSqwAL7SNsMqx8=
=V3MT
-----END PGP SIGNATURE-----

--==_Exmh_1240849877_4302P--
