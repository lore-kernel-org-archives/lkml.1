Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZF2HXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZF2HXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZF2HXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:23:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:62914 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZF2HXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:23:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QvAkH48yHwkFszu+24BA+fofV0kSmuiU1B+lzsDOFowlWxq0b8ItpsP9LBOcBO4ZGt
         LIIn3ktgYzPlHS6kMZkpTmHb00N4XB/BfI8I2z41vR07F62q7KGIf01TNTbOwV+e4Dxj
         4b+mZxs48ySd54Ecvnpuv345h+4JCS0A56x7E=
Message-ID: <4A486AB1.5080306@gmail.com>
Date: Mon, 29 Jun 2009 15:18:09 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Aviv Laufer <aviv.laufer@gmail.com>
CC: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /drivers/video/backlight/tdo24m - crash on kmalloc
References: <87972c700906230628l69a8a08ds4d182128bbd5dbe@mail.gmail.com>
In-Reply-To: <87972c700906230628l69a8a08ds4d182128bbd5dbe@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aviv Laufer wrote:
> There is  a crash in tdo24m module caused by a call to kmalloc with
> the second parameter sizeof(flag) instead of flag.
> 
> Signed-off-by: Aviv Laufer <aviv.laufer@gmail.com>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
> 
> 
> --- linux-2.6.30/drivers/video/backlight/tdo24m.c.orig	2009-06-23
> 15:08:02.000000000 +0300
> +++ linux-2.6.30/drivers/video/backlight/tdo24m.c	2009-06-23
> 15:09:05.000000000 +0300
> @@ -356,7 +356,7 @@ static int __devinit tdo24m_probe(struct
>  	lcd->power = FB_BLANK_POWERDOWN;
>  	lcd->mode = MODE_VGA;	/* default to VGA */
> 
> -	lcd->buf = kmalloc(TDO24M_SPI_BUFF_SIZE, sizeof(GFP_KERNEL));
> +	lcd->buf = kmalloc(TDO24M_SPI_BUFF_SIZE, GFP_KERNEL);
>  	if (lcd->buf == NULL) {
>  		kfree(lcd);
>  		return -ENOMEM;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

