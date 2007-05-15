Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbXEODZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbXEODZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 23:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXEODZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 23:25:47 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:56030 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbXEODZq (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 23:25:46 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Martin Peschke <mp3@de.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2 - CONFIG_STATISTIC and Intel PowerTOP...
In-Reply-To: Your message of "Wed, 09 May 2007 01:23:22 PDT."
             <20070509012322.199f292b.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070509012322.199f292b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1179199530_4787P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 14 May 2007 23:25:30 -0400
Message-ID: <8277.1179199530@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1179199530_4787P
Content-Type: text/plain; charset=us-ascii

On Wed, 09 May 2007 01:23:22 PDT, Andrew Morton said:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm2/

So I'm trying to get the Intel PowerTop stuff working, and discovered that /
proc/timer_stats and/or /proc/tstats has moved to /debug in -mm2 - but only if
you're building for S390.  For other architechtures it just evaporates
entirely.  I had to bash this patch in to get it to get included in an x86_64
build:

--- linux-2.6.21-mm2/arch/x86_64/Kconfig.statistics     2007-05-14 23:01:00.000000000 -0400
+++ linux-2.6.21-mm2/arch/x86_64/Kconfig        2007-05-14 23:00:45.000000000 -0400
@@ -793,6 +793,8 @@
 
 source "kernel/Kconfig.marker"
 
+source "lib/Kconfig.statistic"
+
 endmenu
 
 source "arch/x86_64/Kconfig.debug"

Am just replicating the choice to put it in arch/s390/Kconfig - not sure why
it was in there rather than lib/Kconfig.debug - is there a reason here?

Having bashed *that* into place, I hit this at kernel link time:

WARNING: lib/built-in.o - Section mismatch: reference to .init.text:statistic_hotcpu from .data between 'statistic_hotcpu_notifier' (at offset 0x640) and 'io_tlb_lock'


--==_Exmh_1179199530_4787P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGSSgqcC3lWbTT17ARAj7WAJ0S72rG7bra6KB5fkJcNS8cYcAGeQCgo742
ICJE9TrfevKKn9KrpT6Rtng=
=jkHq
-----END PGP SIGNATURE-----

--==_Exmh_1179199530_4787P--
