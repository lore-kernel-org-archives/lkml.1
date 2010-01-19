Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007Ab0ASVx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0ASVx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753646Ab0ASVx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:53:28 -0500
Received: from exprod6og105.obsmtp.com ([64.18.1.189]:37640 "HELO
	exprod6og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753548Ab0ASVx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:53:27 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: Re: [RFC] [PATCH] watchdog_info separation and constify
Date: Tue, 19 Jan 2010 16:53:26 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909020E8C70@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: [RFC] [PATCH] watchdog_info separation and constify
Thread-Index: AcqZUdRPLj9pwD0cRI61Fr5zRZCpCw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <wim@iguana.be>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Jan 2010 21:53:25.0945 (UTC) FILETIME=[D3DE6A90:01CA9951]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o0JLrd54004254

On Tue Jan 19, 2010, Wim Van Sebroeck wrote:
> Hi All,
> 
> please comment on following patch.
> 
> Kind regards,
> Wim.
> 
> commit 88d0b1a9c071d26e7b4831320067c84b04ea04a8
> Author: Wim Van Sebroeck <wim@xxxxxxxxx>
> Date: Sat Dec 26 18:55:22 2009 +0000
> 
> [WATCHDOG] watchdog_info separation and constify
> 
> make sure that the watchdog_info struct is seperated from the ioctl code.
> Also make the struct const where possible.
> 
> Signed-off-by: Wim Van Sebroeck <wim@xxxxxxxxx>

[snip]

> diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
> index cdd55e0..88ed54e 100644
> --- a/drivers/watchdog/ep93xx_wdt.c
> +++ b/drivers/watchdog/ep93xx_wdt.c
> @@ -131,7 +131,7 @@ ep93xx_wdt_write(struct file *file, const char __user *data, size_t len,
> return len;
> }
> 
> -static struct watchdog_info ident = {
> +static const struct watchdog_info ident = {
> .options = WDIOF_CARDRESET | WDIOF_MAGICCLOSE,
> .identity = "EP93xx Watchdog",
> };

Before:
$ size ep93xx_wdt.o
   text	   data	    bss	    dec	    hex	filename
   1613	     88	     40	   1741	    6cd	ep93xx_wdt.o

After:
$ size ep93xx_wdt.o
   text	   data	    bss	    dec	    hex	filename
   1653	     48	     40	   1741	    6cd	ep93xx_wdt.o

Tested-by: H Hartley Sweeten <hsweeten@visionengravers.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
