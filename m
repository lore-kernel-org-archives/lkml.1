Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZAJJr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZAJJr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 04:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZAJJrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 04:47:18 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:35659 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZAJJrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 04:47:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=imb6z4d0g827ed5EDbIaRH4ZkCeUWYqx3iuGirtq3aOxHtNgs3qp9pm6IcPscLv4vo
         0gojdYanA1wqUQfzPaBGRI8aKLzxasdVYIBvvSBSZa6M5nsI2VI3PF0XfJddHeDFfGq0
         Z2AulRIf5zt1LkLXWYY5HH2U+mkJV0LCz15AU=
Message-ID: <7b9198260901100147i2d94f42fhc0e9a4b42338bc2a@mail.gmail.com>
Date: Sat, 10 Jan 2009 09:47:15 +0000
From: "Tom Spink" <tspink@gmail.com>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: [PATCH 5/5] Fix dubious bitwise 'and' usage spotted by sparse.
Cc: LKML <linux-kernel@vger.kernel.org>, "Jiri Kosina" <jkosina@suse.cz>,
       "Trivial Kernel Patches" <trivial@kernel.org>
In-Reply-To: <20090109234828.11800.10915.stgit@zaytsev.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090109234113.11800.55672.stgit@zaytsev.su>
	 <20090109234828.11800.10915.stgit@zaytsev.su>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/9 Alexey Zaytsev <alexey.zaytsev@gmail.com>:
> It doesn't change the semantics, but clearly
> the logical 'and' was meant to be used here.
>
> Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> ---
>  drivers/usb/wusbcore/security.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/wusbcore/security.c b/drivers/usb/wusbcore/security.c
> index a101cad..8f953ab 100644
> --- a/drivers/usb/wusbcore/security.c
> +++ b/drivers/usb/wusbcore/security.c
> @@ -626,7 +626,7 @@ void wusbhc_gtk_rekey(struct wusbhc *wusbhc)
>                struct wusb_dev *wusb_dev;
>
>                wusb_dev = wusbhc->port[p].wusb_dev;
> -               if (!wusb_dev || !wusb_dev->usb_dev | !wusb_dev->usb_dev->authenticated)
> +               if (!wusb_dev || !wusb_dev->usb_dev || !wusb_dev->usb_dev->authenticated)
>                        continue;
>
>                usb_fill_control_urb(wusb_dev->set_gtk_urb, wusb_dev->usb_dev,
>

Hi Alexey,

This one is a logical 'or'... your changelog says 'and'!

-- 
Tom Spink
Douglas William Jerrold  - "The only athletic sport I ever mastered
was backgammon."
