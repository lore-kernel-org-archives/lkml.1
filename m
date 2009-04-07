Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZDGIxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZDGIxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZDGIxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:53:23 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63928 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZDGIxX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:53:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=eQg1HT67CuciRrGdZTvGjC4GUzNBzOPozKemF+mpkmT4X6Sihi2MNMcTMBRkBhb7EO
         j9EoG6tifZIcy6ODNlFgJDCMUqshxBdY+oYMGXLG0mK2gdhnYEcgZMOTXneLvWn8KKvx
         oo6NpUg0ni6XI/WCDndM8j4T942xYJf2e5Vz0=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: 2.6.29, today's git changes, oops at boot, BUG: unable to handle kernel paging request at ffffffffa00f0016
Date: Tue, 7 Apr 2009 10:53:17 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
References: <20090407082811.GA17700@damson.cased.tu-darmstadt.de>
In-Reply-To: <20090407082811.GA17700@damson.cased.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904071053.17986.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 of April 2009, Vegard Nossum wrote:
> 2009/4/7 Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>:
> > On Tuesday 07 of April 2009, Vegard Nossum wrote:
> >> 2009/4/6 Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>:
> >> > Pulled Linus git few minutes ago and new oops at boot (happens on
> >> > every boot). Yesterday git version was fine. Oopsed just while/after
> >> > udev started.
> >>
> >> Hi, thanks for the report. Some musings below.
>
> Can you try this patch?
>
> The theory is that the init section of the module is unloaded before the
> async function gets a chance to run.

Issue seems to be gone with this patch, tried twice (unless I had big luck). 
Previously only like 1of 15 runs was successful.

Thanks!

> Thanks,
>
> Vegard
>
>
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index b0de631..3c7d894 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -903,7 +903,7 @@ static struct acpi_driver acpi_battery_driver = {
>  		},
>  };
>
> -static void __init acpi_battery_init_async(void *unused, async_cookie_t
> cookie) +static void acpi_battery_init_async(void *unused, async_cookie_t
> cookie) {
>  	if (acpi_disabled)
>  		return;


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

