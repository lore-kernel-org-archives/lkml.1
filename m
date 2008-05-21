Return-Path: <linux-kernel-owner+w=401wt.eu-S933815AbYEUAlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815AbYEUAlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbYEUAlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:41:15 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:20952 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYEUAlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Dq0XcChzDOGUFhT2ZQku0AJWFBdSRiGa3g14j+PUFaMQUgHxpCZioZAAtTgsfaWBKsC6gyxkgepysEhB4WdWrQPuR89dIRIJIbX/joAkj8HP6JoSBVqIPildJLr7dete7kvPOy/42ypBr+VfqgAeXem9E52UtHFMtIIQRjmrO1I=
Subject: Re: [PATCH] or51132.c: unaligned
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: mchehab@infradead.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <E1JycGV-0004yJ-SP@ZenIV.linux.org.uk>
References: <E1JycGV-0004yJ-SP@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 May 2008 17:41:12 -0700
Message-Id: <1211330472.5915.228.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 01:33 +0100, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/media/dvb/frontends/or51132.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/or51132.c b/drivers/media/dvb/frontends/or51132.c
> index c7b5785..5ed3254 100644
> --- a/drivers/media/dvb/frontends/or51132.c
> +++ b/drivers/media/dvb/frontends/or51132.c
> @@ -126,7 +126,7 @@ static int or51132_readreg(struct or51132_state *state, u8 reg)
>  		       reg, err);
>  		return -EREMOTEIO;
>  	}
> -	return le16_to_cpup((u16*)buf);
> +	return buf[0] | (buf[1] << 8);

return get_unaligned_le16(buf);

>  }
>  
>  static int or51132_load_firmware (struct dvb_frontend* fe, const struct firmware *fw)
> @@ -140,9 +140,9 @@ static int or51132_load_firmware (struct dvb_frontend* fe, const struct firmware
>  	dprintk("Firmware is %Zd bytes\n",fw->size);
>  
>  	/* Get size of firmware A and B */
> -	firmwareAsize = le32_to_cpu(*((u32*)fw->data));
> +	firmwareAsize = le32_to_cpu(*((__le32*)fw->data));

﻿firmwareAsize = le32_to_cpup((__le32 *)fw->data);

>  	dprintk("FirmwareA is %i bytes\n",firmwareAsize);
> -	firmwareBsize = le32_to_cpu(*((u32*)(fw->data+4)));
> +	firmwareBsize = le32_to_cpu(*((__le32*)(fw->data+4)));

﻿firmwareBsize = le32_to_cpup((__le32 *)(fw->data + 4));

Cheers,

Harvey

