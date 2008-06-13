Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbYFMETu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbYFMETu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 00:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYFMETi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 00:19:38 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40495 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585AbYFMETf (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 00:19:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUG] 2.6.26-rc5-mm3 kernel BUG at mm/filemap.c:575!
In-Reply-To: Your message of "Thu, 12 Jun 2008 14:14:21 +0530."
             <4850E1E5.90806@linux.vnet.ibm.com>
From: Valdis.Kletnieks@vt.edu
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
            <4850E1E5.90806@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1213330723_2983P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jun 2008 00:18:43 -0400
Message-ID: <4041.1213330723@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1213330723_2983P
Content-Type: text/plain; charset=us-ascii

On Thu, 12 Jun 2008 14:14:21 +0530, Kamalesh Babulal said:
> Hi Andrew,
> 
> 2.6.26-rc5-mm3 kernel panics while booting up on the x86_64
> machine. Sorry the console is bit overwritten for the first few lines.

> no fstab.kernel BUG at mm/filemap.c:575!

For whatever it's worth, I'm seeing the same thing on my x86_64 laptop.
-rc5-mm2 works OK, I'm going to try to bisect it tonight.

% diff -u /usr/src/linux-2.6.26-rc5-mm[23]/.config
--- /usr/src/linux-2.6.26-rc5-mm2/.config       2008-06-10 22:21:13.000000000 -0400
+++ /usr/src/linux-2.6.26-rc5-mm3/.config       2008-06-12 22:20:25.000000000 -0400
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc5-mm2
-# Tue Jun 10 22:21:13 2008
+# Linux kernel version: 2.6.26-rc5-mm3
+# Thu Jun 12 22:20:25 2008
 #
 CONFIG_64BIT=y
 # CONFIG_X86_32 is not set
@@ -275,7 +275,7 @@
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_BOUNCE=y
 CONFIG_VIRT_TO_BUS=y
-# CONFIG_NORECLAIM_LRU is not set
+CONFIG_UNEVICTABLE_LRU=y
 CONFIG_MTRR=y
 CONFIG_MTRR_SANITIZER=y
 CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0

Not much changed there...


--==_Exmh_1213330723_2983P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIUfUjcC3lWbTT17ARAkfUAJ0WQuV/bFRJGjGypxnucvdZEPw12QCeK3tg
zb9aq6aIr8XgW+lmCicdQ/Y=
=aeWO
-----END PGP SIGNATURE-----

--==_Exmh_1213330723_2983P--
