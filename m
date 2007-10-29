Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbXJ2HH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbXJ2HH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXJ2HHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:07:49 -0400
Received: from tuxrocks.com ([208.78.103.217]:34339 "EHLO tuxrocks.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbXJ2HHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:07:48 -0400
X-Greylist: delayed 3297 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2007 03:07:48 EDT
Message-ID: <472579D8.7010404@tuxrocks.com>
Date: Mon, 29 Oct 2007 01:12:40 -0500
From: Frank Sorenson <frank@tuxrocks.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Bradley Smith <bradjsmith@btinternet.com>, linux-kernel@vger.kernel.org,
       dz@debian.org
Subject: Re: [PATCH 1/2] I8K: Allow i8k driver to be built on x86_64 systems
References: <20071028172519.371dbbe8@debian.hob> <4724CDFA.1080106@garzik.org>
In-Reply-To: <4724CDFA.1080106@garzik.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jeff Garzik wrote:
> Bradley Smith wrote:
>> From: Bradley Smith <bradjsmith@btinternet.com>
>>
>> Adds #if clause and additional inline assembly so that the driver
>> builds on x86_64 systems.
>>
>> Signed-off-by: Bradley Smith <bradjsmith@btinternet.com>
> 
> Is this actually known to be working on a Dell laptop?
> 
>     Jeff

Yes, the patch works well on my Dell, and I've got several
follow-up patches to Brad's.  During the last i8k refresh
(http://lkml.org/lkml/2005/2/24/11), not everything made it
into mainline, so i8k is due for another facelift.

Needs the following in order to work correctly on my Inspiron E1705:


Add DMI Product name to i8k for Dell MP061 hardware (Inspiron 9400/E1705)

Signed-off-by: Frank Sorenson <frank@tuxrocks.com>
- ---
 drivers/char/i8k.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.24-rc1/drivers/char/i8k.c
===================================================================
- --- linux-2.6.24-rc1.orig/drivers/char/i8k.c	2007-10-29 00:27:21.000000000 -0500
+++ linux-2.6.24-rc1/drivers/char/i8k.c	2007-10-29 00:30:05.000000000 -0500
@@ -468,6 +468,13 @@
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude"),
 		},
 	},
+	{
+		.ident = "Dell Inspiron 3",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MP061"),
+		},
+	},
 	{ }
 };


Frank
- -- 
Frank Sorenson - KD7TZK
Linux Systems Engineer, DSS Engineering, UBS AG
frank@tuxrocks.com

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFHJXnUaI0dwg4A47wRApQrAKDKb0Zq+QrG+CUsXrpfoxVxLyM+PQCg5uZc
kvUjuY3a1F7MIx0Z9DSrYbg=
=IcmN
-----END PGP SIGNATURE-----
