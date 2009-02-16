Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbZBPV32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbZBPV32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZBPV3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:29:20 -0500
Received: from brigitte.telenet-ops.be ([195.130.137.66]:35478 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZBPV3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:29:20 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Feb 2009 16:29:19 EST
Date: Mon, 16 Feb 2009 22:24:14 +0100
From: Kristof Provost <Kristof@sigsegv.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: buytenh@wantstofly.org, sylver.bruneau@googlemail.com
Subject: Compile error in drivers/watchdog/orion5x_wdt.c
Message-ID: <20090216212413.GB27134@nereid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Content-Disposition: inline
X-PGP-Fingerprint: 6B6E 5EED 8ECF FAE7 1F61  7458 5046 7D0E 11B0 0EE8
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

drivers/watchdog/orion5x_wdt.c fails to compile with the following error:

  CC [M]  drivers/watchdog/orion5x_wdt.o
drivers/watchdog/orion5x_wdt.c:37: error: 'ORION5X_TCLK' undeclared here
(not in a function)
make[2]: *** [drivers/watchdog/orion5x_wdt.o] Error 1


I guess the problem is related to ebe35aff883496c07248df82c8576c3b6e84bbbe 
as it removed ORION5X_TLCK from arch/arm/mach-orion5x/include/mach/timex.h.
There are no other defines or uses of ORION5X_TLCK than in the watchdog.

I don't think simply restoring the define is the appropriate solution 
though. According to the commit log the value can be different for 
different hardware variants.

Regards,
Kristof Provost
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmZ2X0ACgkQUEZ9DhGwDuhBOgCfUubO6evdRalap8WSfF7k99I2
Bg8An1SPfFuueiU7Ndum9RNnIXLcdY7V
=qubX
-----END PGP SIGNATURE-----
