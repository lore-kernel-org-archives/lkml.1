Return-Path: <linux-kernel-owner+w=401wt.eu-S938488AbXG3Fuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938488AbXG3Fuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 01:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760264AbXG3Fuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 01:50:35 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:62462 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbXG3Fue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 01:50:34 -0400
X-Greylist: delayed 685 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 01:50:34 EDT
Date: Mon, 30 Jul 2007 01:39:07 -0400
To: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-sound@vger.kernel.org>
Subject: [PATCH]:  ioremap function balancing in init/cleanup sound/oss/dmasound/dmacound_awacs.c
From: <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070730053908.62A05DA82E@mailserver8.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Two cases where ioremap can be called in init function but will
never be cleaned up. patch is against 2.6.23-rc1.

Signed-off-by: Post Fail <postfail <at> hushmail.com>
- ---

- --- ./linux-2.6.22.clean/sound/oss/dmasound/dmasound_awacs.c	2007-
07-08 19:32:17.000000000 -0400
+++ ./linux-2.6.22/sound/oss/dmasound/dmasound_awacs.c	2007-07-29
23:05:30.000000000 -0400
@@ -3204,6 +3204,12 @@ static void __exit dmasound_awacs_cleanu
 	}
 	dmasound_deinit();

+        if (latch_base)
+                iounmap(latch_base);
+
+        if (macio_base)
+                iounmap(macio_base);
+
 	of_node_put(awacs_node);
 	of_node_put(i2s_node);
 }

-----BEGIN PGP SIGNATURE-----
Note: This signature can be verified at https://www.hushtools.com/verify
Version: Hush 2.5

wpwEAQECAAYFAkateM4ACgkQ5iui/yAtoVllnAP/b/B6G+rmMgu0DXi6UOmpkPhw2aWZ
o8E7PiKXmqIjuxVcGERch+dQ5Fv2HytDWE0Wx7/T2P/4Q8rIbPLSemgIQmk0ZHUfPydG
mQ+kKMmtFI5MwJ63QeHwuz4O+E+3CzIS3j+ZDb+nYrOXOZexWHMWRSm8zG+3WjBj8wCH
G1z+Wvg=
=WXVV
-----END PGP SIGNATURE-----

--
Click here for a free directory of employee development and training solutions
http://tagline.hushmail.com/fc/Ioyw6h4dDApAP0vm8MwFLWUmr7tHObB8rYAXa7zXQmEHPyHNeojRUQ/


