Return-Path: <linux-kernel-owner+w=401wt.eu-S1759426AbXIXNRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426AbXIXNRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXIXNRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:17:39 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54616 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbXIXNRj (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:17:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Uninline kcalloc()
In-Reply-To: Your message of "Mon, 24 Sep 2007 08:59:56 EDT."
             <902BC866-59A0-4E50-8299-64D38D9E93B1@mac.com>
From: Valdis.Kletnieks@vt.edu
References: <20070922200349.GA2119@martell.zuzino.mipt.ru> <25045.1190612108@turing-police.cc.vt.edu>
            <902BC866-59A0-4E50-8299-64D38D9E93B1@mac.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190639853_3721P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Sep 2007 09:17:33 -0400
Message-ID: <5202.1190639853@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190639853_3721P
Content-Type: text/plain; charset=us-ascii

On Mon, 24 Sep 2007 08:59:56 EDT, Kyle Moffett said:

> Proper fix is to give __kmalloc a "void *caller" parameter and have  
> all of the various wrapper functions pass in the value of  
> __builtin_return_address() appropriately.  I believe that even works  
> properly for inline functions which may or may not be inlined.

I think I looked at that, and it wasn't as easy as it looked, because there
were ugly corner cases for what __builtin_return_address() returned depending
on exactly what did or didn't get inlined. Basically, it's ugly stuff - if you
try to use __builtin_retur_address inside kcalloc to pass to __kmalloc, and
then kcalloc gets inlined, you end up passing not the routine you wanted (the
caller of kcalloc), but the *parent* of that...

--==_Exmh_1190639853_3721P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG97jtcC3lWbTT17ARAuy4AJ96r42B1NdMGfWMBQmG/kVAMNSdQwCgvPQO
7VttJDCHf8+91WDTjuCEmRs=
=lg4p
-----END PGP SIGNATURE-----

--==_Exmh_1190639853_3721P--
