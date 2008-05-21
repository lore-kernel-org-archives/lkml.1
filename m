Return-Path: <linux-kernel-owner+w=401wt.eu-S932597AbYEUAm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597AbYEUAm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756656AbYEUAmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:42:49 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:22917 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbYEUAms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=p95IcYCcSEx/I1GO0olBlvHIlomiKeVCchszQbqCxRC2qRYtuOrzhPxwj1u4fwNTf+H3r1iCGnBPxC2XLSu+kIKnueS1SfokoXrQzY3ALkhl3hO8x1lLP5J0Ng28OYEZAp4N3RirnqQnF6WT7v29n35IrPP5AYG2o4RO2JTjT/0=
Subject: Re: [PATCH] dvb-usb: unaligned
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <E1JycGL-0004x6-SF@ZenIV.linux.org.uk>
References: <E1JycGL-0004x6-SF@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 May 2008 17:42:46 -0700
Message-Id: <1211330566.5915.230.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 01:33 +0100, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/media/dvb/dvb-usb/dvb-usb-firmware.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c b/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
> index e1112e3..733a7ff 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-firmware.c
> @@ -127,7 +127,7 @@ int dvb_usb_get_hexline(const struct firmware *fw, struct hexline *hx,
>  	if ((*pos + hx->len + 4) >= fw->size)
>  		return -EINVAL;
>  
> -	hx->addr = le16_to_cpu( *((u16 *) &b[1]) );
> +	hx->addr = b[1] | (b[2] << 8);

﻿hx->addr = get_unaligned_le16(&b[1]);

Cheers,

Harvey

