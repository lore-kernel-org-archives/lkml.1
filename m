Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbYCWFGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbYCWFGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 01:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbYCWFGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 01:06:05 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42205 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbYCWFGE (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 01:06:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Roy Lee <roylee17@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] give elf_check_arch() a chance for checking endian mismatch
In-Reply-To: Your message of "Thu, 20 Mar 2008 03:03:30 +0800."
             <000101c889f3$ef5989e0$ce0c9da0$@com>
From: Valdis.Kletnieks@vt.edu
References: <000101c889f3$ef5989e0$ce0c9da0$@com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1206248760_3492P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 23 Mar 2008 01:06:00 -0400
Message-ID: <25483.1206248760@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1206248760_3492P
Content-Type: text/plain; charset=us-ascii

On Thu, 20 Mar 2008 03:03:30 +0800, Roy Lee said:

(Sorry for late reply, catching up finally)

> I'd like to warn for endianess mismatch, or unsupported feature( hardware
> float point support) when loading an ELF file.

> -       if (loc->elf_ex.e_type != ET_EXEC && loc->elf_ex.e_type != ET_DYN)
> -               goto out;
>         if (!elf_check_arch(&loc->elf_ex))
>                 goto out;
> +       if (loc->elf_ex.e_type != ET_EXEC && loc->elf_ex.e_type != ET_DYN)
> +               goto out;

It would seem to me that if it isn't an ET_EXEC or ET_DYN, the question of
whether it passes elf_check_arch() would be rather moot?  In any case, you
don't get to actually *warn* for it, because you end up with a 'goto out'
in either case, and elf_check_arch is a pretty small macro on most archs.

Also, if you change the order there, do you want to also change the order
in load_elf_interp(), where the equivalent test is done? 

--==_Exmh_1206248760_3492P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFH5eU4cC3lWbTT17ARArOoAKDRqy5kCgyglzTyP32vGRcs54QgtACg8EVB
GAh5j+TFrzRQ9e5BFFVBOGM=
=bIC9
-----END PGP SIGNATURE-----

--==_Exmh_1206248760_3492P--
