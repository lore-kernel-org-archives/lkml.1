Return-Path: <linux-kernel-owner+w=401wt.eu-S932349AbZD0Sq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349AbZD0Sq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759085AbZD0SqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:46:01 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57140 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbZD0Sp7 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:45:59 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-04-24-18-14 uploaded - NVidia indigestion
In-Reply-To: Your message of "Sat, 25 Apr 2009 07:24:34 +0200."
             <20090425052434.GE10088@wotan.suse.de>
From: Valdis.Kletnieks@vt.edu
References: <200904250133.n3P1XBJn006790@imap1.linux-foundation.org> <5622.1240628800@turing-police.cc.vt.edu>
            <20090425052434.GE10088@wotan.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1240857915_4302P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Apr 2009 14:45:15 -0400
Message-ID: <57773.1240857915@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1240857915_4302P
Content-Type: text/plain; charset=us-ascii

On Sat, 25 Apr 2009 07:24:34 +0200, Nick Piggin said:

> >             #include <linux/version.h>
> >             #include <linux/utsname.h>
> >             int main() {
> >               if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)) {
> >                 return 0;
> >               } else {
> >                 return 1;
> >               }

> Yeah BUILD_BUG_ON does work like that. I can't for the life of me
> understand why it triggered though. Is anything in your external
> code calling kmalloc_slab directly?

See above - I didn't think LINUX_VERSION_CODE cared about kmalloc, but
I could be wrong on this. ;)

> What's the preprocessor output look like?

The problem appears to be that if you only include version.h and utsname.h,
and *don't* actually reference kmalloc_slab, it doesn't know that the size_t
is actually a constant, so it whinges.  Most modules end up doing at least
one kmalloc(), so kmalloc() and kmalloc_slab() get inlined, the constant 'size'
gets propogated, and life is good.  If you *don't* call kmalloc(), bad things
happen. ;)

--==_Exmh_1240857915_4302P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ9f07cC3lWbTT17ARAn4MAJ9X1ad3Gb7eCY28IVfS+z9LZ2ufAwCcCroy
zDG/uBlIqbCt0rIZF4h+MoE=
=KgBL
-----END PGP SIGNATURE-----

--==_Exmh_1240857915_4302P--
