Return-Path: <linux-kernel-owner+w=401wt.eu-S1751738AbZGKIRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbZGKIRu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbZGKIRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:17:34 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47912 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033AbZGKIRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MmZhkbfrfZzQwl5uQDCtPj8PywfLKgdr15JRykvcRE8i53941tq2gzddNBWxapJr6M
         EsaxAAm+n52xdjNOJiKvtroX6p15vkA68RN61vzgiqS/Lp4V4Ux40DR/WAeQr6l3OYfG
         zZvM5f2C6dZo233amzKldgBeuXPkW7K3WybYI=
Message-ID: <4A584A94.5010105@gmail.com>
Date: Sat, 11 Jul 2009 10:17:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/5] staging/otus: Move a dereference below a NULL test
References: <Pine.LNX.4.64.0907110950510.29592@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0907110950510.29592@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2009 09:51 AM, Julia Lawall wrote:
> diff -u -p a/drivers/staging/otus/wwrap.c b/drivers/staging/otus/wwrap.c
> --- a/drivers/staging/otus/wwrap.c
> +++ b/drivers/staging/otus/wwrap.c
> @@ -1016,12 +1016,13 @@ void kevent(struct work_struct *work)
>  {
>      struct usbdrv_private *macp =
>                 container_of(work, struct usbdrv_private, kevent);
> -    zdev_t *dev = macp->device;
> +    zdev_t *dev;
>  
>      if (macp == NULL)
>      {
>          return;
>      }

The test is rather useless here.

> +    dev = macp->device;


