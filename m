Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681Ab0AGTGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab0AGTGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662Ab0AGTGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:06:44 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41278 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab0AGTGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:06:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=g4toxfrwYgvvOLkNFnN1mGf3REa4apuPXBKFkAHTPNgbdteQoqXg1K5TznX+NvmpLQ
         ALxZ8xBHUScfiZm72LDG7msdqbf5bgFd4ee1Asw3kfnxAymLCXhuo5Htc09tAfvL07eD
         HY4miFesN/Xfn713D09tGbHmVud6BW+DBZDIE=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bastian Blank <waldi@debian.org>
Subject: Re: [PATCH 2/7] Input: wacom - Get features from driver info
Date: Thu, 7 Jan 2010 11:06:30 -0800
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc3; KDE/4.3.4; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ping Cheng <pingc@wacom.com>
References: <20100107182553.GA11236@wavehammer.waldi.eu.org> <20100107182936.GA12913@wavehammer.waldi.eu.org>
In-Reply-To: <20100107182936.GA12913@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001071106.31688.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 January 2010 10:29:36 am Bastian Blank wrote:
> Get the features information from the driver info of the usb device id
> structure provided by the caller.  The device ids and feature structs
> are strong coupled using indices.
> 
> Signed-off-by: Bastian Blank <waldi@debian.org>
> ---
>  drivers/input/tablet/wacom_sys.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/tablet/wacom_sys.c
>  b/drivers/input/tablet/wacom_sys.c index ab42c25..b0f3fc3 100644
> --- a/drivers/input/tablet/wacom_sys.c
> +++ b/drivers/input/tablet/wacom_sys.c
> @@ -532,7 +532,7 @@ static int wacom_probe(struct usb_interface *intf,
>  const struct usb_device_id *i struct usb_endpoint_descriptor *endpoint;
>  	struct wacom *wacom;
>  	struct wacom_wac *wacom_wac;
> -	struct wacom_features *features;
> +	struct wacom_features *features = (void *)id->driver_info;

What is this cast for?

>  	struct input_dev *input_dev;
>  	int error = -ENOMEM;
> 
> @@ -557,7 +557,9 @@ static int wacom_probe(struct usb_interface *intf,
>  const struct usb_device_id *i usb_make_path(dev, wacom->phys,
>  sizeof(wacom->phys));
>  	strlcat(wacom->phys, "/input0", sizeof(wacom->phys));
> 
> -	wacom_wac->features = features = get_wacom_feature(id);
> +	if (!features)
> +		features = get_wacom_feature(id);

In which cases driver would not have driver_info set up?

> +	wacom_wac->features = features;
>  	BUG_ON(features->pktlen > WACOM_PKGLEN_MAX);
> 
>  	input_dev->name = wacom_wac->features->name;
> 

-- 
Dmitry
