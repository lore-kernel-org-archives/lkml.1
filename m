Return-Path: <linux-kernel-owner+w=401wt.eu-S1752951AbYLUXtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbYLUXtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 18:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYLUXtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 18:49:23 -0500
Received: from mail.vialibre.org.ar ([190.210.9.245]:58743 "EHLO
	mail.vialibre.org.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYLUXtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 18:49:22 -0500
X-Greylist: delayed 1411 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Dec 2008 18:49:22 EST
Date: Sun, 21 Dec 2008 21:25:39 -0200
From: Federico Heinz <fheinz@vialibre.org.ar>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Andrew Paprocki" <andrew@ishiboo.com>,
       LKML <linux-kernel@vger.kernel.org>, dz@debian.org,
       "Andy Spencer" <spenceal@rose-hulman.edu>
Subject: Re: i8k: fails to detect Dell XPS M1530, fails to get SMM BIOS
 version with force=1
Message-ID: <20081221212539.1fa72bd8@lauren>
In-Reply-To: <20081221144109.2ed26cf2@lxorguk.ukuu.org.uk>
References: <76366b180812171634k6c5a25d6uad0de0d6c514ebb5@mail.gmail.com>
	<76366b180812171707j7ad58957xf153d40efb7c7d59@mail.gmail.com>
	<20081221144109.2ed26cf2@lxorguk.ukuu.org.uk>
Organization: =?UTF-8?B?RnVuZGFjacOzbiBWw61h?= Libre
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/12/2008, Alan Cox wrote:
> I can find no copies of them with Signed-off-by: lines so they appear to
> have escaped. If the authors of those changes would care to provided
> Signed-off-by: lines I'll chase this up further.

This trivial patch adds support for i8k on the new Dell Vostro models.
I tested it on my Vostro 1400, and it works. It does print a warning
when loading the module:

	i8k: unable to get SMM BIOS version

But I couldn't figure out how to fix that. The module seems to work fine,
anyway...

Signed-off-by: Federico Heinz <fheinz@vialibre.org.ar>

--- drivers/char/i8k.c.orig     2007-07-08 20:32:17.000000000 -0300
+++ drivers/char/i8k.c  2007-09-27 03:06:08.000000000 -0300
@@ -439,6 +439,13 @@
                        DMI_MATCH(DMI_PRODUCT_NAME, "Latitude"),
                },
        },
+       {
+               .ident = "Dell Vostro",
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "Vostro"),
+               },
+       },
        { }
 };
