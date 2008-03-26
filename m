Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbYCZKeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbYCZKeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYCZKeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:34:03 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:20356 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbYCZKeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=rvSG98AeQCDkfLsAgizQLI+3l6q9V8MsvX94j0s/W5gYGpadx+7nt4FQQSAcQYvodD/eKq8HKBaNxRX6lFsoiCT0YPSHjOKPuCJvez1SxnLehTWWQnaBkkJGq9fVUAuu60a6RU/39bGIXpi2yfL5HQUmilgHatTPgS+QxQYFgLE=
Message-ID: <47EA268F.8070006@gmail.com>
Date: Wed, 26 Mar 2008 11:33:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Wim Van Sebroeck <wim@iguana.be>, "'Sam Ravnborg'" <sam@ravnborg.org>
Subject: Re: [PATCH 1/1] [Blackfin try #2] char driver for Blackfin on-chip
 OTP memory
References: <> <1206580131-22527-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1206580131-22527-1-git-send-email-cooloney@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2008 02:08 AM, Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> initial char driver for otp memory
> (only read supported atm ... needs real examples/docs for write support)
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Nice,
Acked-by: Jiri Slaby <jirislaby@gmail.com>

> diff --git a/drivers/char/bfin-otp.c b/drivers/char/bfin-otp.c
> new file mode 100644
> index 0000000..2edc284
> --- /dev/null
> +++ b/drivers/char/bfin-otp.c
[...]
> +static int __init bfin_otp_init(void)
> +{
> +	int ret;
> +
> +	stampit();
> +
> +	ret = misc_register(&bfin_otp_misc_device);
> +	if (ret) {
> +		pr_init(KERN_ERR PFX "unable to register a misc device\n");
> +		return ret;
> +	}
> +
> +	pr_init(KERN_INFO PFX "initialized\n");

except the fact, that pr_init definition seems to be broken. Its defined __fmt 
is const, so it should reside in .init.rodata (__initconst), not .init.data 
(__initdata).
