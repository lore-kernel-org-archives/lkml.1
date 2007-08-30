Return-Path: <linux-kernel-owner+w=401wt.eu-S1762781AbXH3Vud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762781AbXH3Vud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760847AbXH3VuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:50:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36735 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbXH3VuX (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:50:23 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Clemens Kolbitsch <clemens.kol@gmx.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Forbid deletion of memory mappings
In-Reply-To: Your message of "Thu, 30 Aug 2007 23:41:09 +0200."
             <200708302341.09459.clemens.kol@gmx.at>
From: Valdis.Kletnieks@vt.edu
References: <200708301844.10532.clemens.kol@gmx.at> <200708302332.42744.clemens.kol@gmx.at> <Pine.LNX.4.64.0708302333320.2460@twin.jikos.cz>
            <200708302341.09459.clemens.kol@gmx.at>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188510621_2967P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Aug 2007 17:50:21 -0400
Message-ID: <30071.1188510621@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188510621_2967P
Content-Type: text/plain; charset=us-ascii

On Thu, 30 Aug 2007 23:41:09 +0200, Clemens Kolbitsch said:
> On Thursday 30 August 2007 23:34:52 you wrote:
> > On Thu, 30 Aug 2007, Clemens Kolbitsch wrote:
> > > is there no way to tell the kernel, that a certain mapping must not be
> > > removed, no matter what (except of course an explicit call to sys_unmap,
> > > of course)?
> >
> > I don't seem to get what is the issue here. Your mapping is not removed,
> > only the VMAs are merged together into one larger VMA if they have
> > neighbouring address ranges and compatible protection bits. See
> > vma_merge().
> 
> the thing is that they are not. the kernel chooses to REPLACE my mapping.
> 
> consider the user-space code:
> 
> mmap(0xaaaa0000, 0x3000, MAP_FIXED, ...);
> mmap(0xaaaa1000, 0x4000, MAP_FIXED, ...);
> 
> here, the second call to mmap will shorten the first mapping to 0x1000 bytes 
> and create one big vma with size 0x5000 bytes.
> 
> is there a way to tell it that the second mmap MUST fail?

There's an LSM exit point for mmap, you could perhaps do something there.

What are you trying to achieve by forcing the second one to fail?

--==_Exmh_1188510621_2967P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG1zudcC3lWbTT17ARAnNiAJwNL0HmtZ2NC8uBypokuSszlJ7d+wCg9d03
IRdUZuVzSeI7C2b7NtbEHuo=
=dnXx
-----END PGP SIGNATURE-----

--==_Exmh_1188510621_2967P--
