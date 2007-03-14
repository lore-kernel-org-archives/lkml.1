Return-Path: <linux-kernel-owner+w=401wt.eu-S1161131AbXCNLMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161131AbXCNLMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161132AbXCNLMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:12:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:24122 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161131AbXCNLMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iDQlzmsA14PPSh0bVo7JPdRmXFqKUSZdrdmfGfpHc5iT1zdQJ+0EDJShOtplYn72QkCHbWCkKtLD9ntP+g4Oo3M1NBxygq6OTfrbcItEG80elyuSvJXUewpQyyN8BrDPWC4KCogtNfO6D+DI+8rnzDKmTkJlfui9r8LUsqHcKuc=
Message-ID: <2375c9f90703140411k1d40d31fx248a438d7b2859c1@mail.gmail.com>
Date: Wed, 14 Mar 2007 19:11:49 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Apple SMC driver (hardware monitoring and control)
In-Reply-To: <45F7C083.7090504@boichat.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45F7C083.7090504@boichat.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am sorry. I forgot to CC to the list.

2007/3/14, Nicolas Boichat wrote:
> Hello,
>

<snip>

> +static ssize_t applesmc_show_fan_manual(struct device *dev, char *buf,
> +                                                               int offset)
> +{
> +       int ret;
> +       u16 manual = 0;
> +       u8 buffer[2];
> +
> +       down(&applesmc_sem);
> +
> +       ret = applesmc_read_key(FANS_MANUAL, buffer, 2);
> +       manual = ((buffer[0] << 8 | buffer[1]) >> offset) & 0x01;
> +
> +       up(&applesmc_sem);
> +       if (ret)
> +               return ret;
> +       else
> +               return sprintf(buf, "%d\n", manual);
> +}
> +

I doubt about your last 'sprintf'. Your 'buf' just has only two 'u8's,
which maybe only has two bytes, and '\n' already consumes one. So only
one byte is left for the decimal vaule of 'manual'. Even it is just
less than 10, just as what you want, the final '\0' is omitted!

What's more, you can't get such information from the return value of
'sprintf'. So I suggest you to choose 'snprintf' instead.
