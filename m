Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbZAXPNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbZAXPNU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 10:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZAXPNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 10:13:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33898 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZAXPNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 10:13:10 -0500
Date: Sat, 24 Jan 2009 09:12:39 -0600
From: Clark Williams <williams@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Walrond <andrew@walrond.org>, linux-kernel@vger.kernel.org
Subject: Re: serial8250 madness
Message-ID: <20090124091239.7bdf45a2@torg>
In-Reply-To: <20090123180033.3e67f542@lxorguk.ukuu.org.uk>
References: <497A0164.90409@walrond.org>
	<20090123180033.3e67f542@lxorguk.ukuu.org.uk>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0OFDQwM018277

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Fri, 23 Jan 2009 18:00:33 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> The big outstanding bug I know about is the incompatibility between the
> PnP 8250 drivers and serial console - that may be your machine C case.
> That one is rather hard to fix so on the long rather than short term hit
> list.
> 
> Alan


I spend a few days trying to figure out a panic in the uart driver that
turned out to be this issue. Would it make sense to add the following?

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 579d63a..35acc6b 100644
- --- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -91,7 +91,7 @@ config SERIAL_8250_PCI
 
 config SERIAL_8250_PNP
        tristate "8250/16550 PNP device support" if EMBEDDED
- -       depends on SERIAL_8250 && PNP
+       depends on SERIAL_8250 && PNP && ! SERIAL_8250_CONSOLE
        default SERIAL_8250
        help
          This builds standard PNP serial support. You may be able to

Clark
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkl7L/MACgkQHyuj/+TTEp21NACgpQI89LMX5ZtJbVlMcpa9A/I0
6JkAoIa5Nwt4mvm6UJGzGkoUGKOCzn5V
=YUtB
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
