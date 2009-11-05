Return-Path: <linux-kernel-owner+w=401wt.eu-S1758545AbZKESmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbZKESmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 13:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758508AbZKESmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 13:42:17 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53580 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958AbZKESmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 13:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gajuhp4gi/AWWau1xhr3gkc9oKLzpvvoOA+g3+wQz0BiWFOPHjFDRy+NGKvoDCdyvO
         vPzc0+xsUFdMmkYjMYA4BqWJD7VB0/LX+ys87F56TgDgmOQSmBRw3TuDKEaGcHjsgiLE
         W2BVW4vUrCeUa0MNN5TRYMviBBifZWIAvUvdk=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 08/41] rt2800usb: use rt2x00usb_register_multiwrite() to set key entries
Date: Thu, 5 Nov 2009 19:42:17 +0100
User-Agent: KMail/1.9.10
Cc: linux-wireless@vger.kernel.org, Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173258.28463.94619.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173258.28463.94619.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051942.17500.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800usb: use rt2x00usb_register_multiwrite() to set key entries
> 
> Since struct hw_key_entry is 32-bytes large and is smaller than
> CSR cache size (which is 64-bytes large) we can use the standard
> rt2x00usb_register_multiwrite() helper to set key entries.
> 
> This cleanup is a part of preparations for later code unification.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
> 
> Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
> ===================================================================
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -392,7 +392,6 @@ static int rt2800usb_config_shared_key(s
>  {
>  	struct hw_key_entry key_entry;
>  	struct rt2x00_field32 field;
> -	int timeout;
>  	u32 offset;
>  	u32 reg;
>  
> @@ -407,12 +406,8 @@ static int rt2800usb_config_shared_key(s
>  		       sizeof(key_entry.rx_mic));
>  
>  		offset = SHARED_KEY_ENTRY(key->hw_key_idx);
> -		timeout = REGISTER_TIMEOUT32(sizeof(key_entry));
> -		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
> -						    USB_VENDOR_REQUEST_OUT,
> -						    offset, &key_entry,
> -						    sizeof(key_entry),
> -						    timeout);
> +		rt2x00usb_register_multiwrite(rt2x00dev, offset,
> +					      &key_entry, sizeof(key_entry));
>  	}
>  
>  	/*
> @@ -445,7 +440,6 @@ static int rt2800usb_config_pairwise_key
>  					 struct ieee80211_key_conf *key)
>  {
>  	struct hw_key_entry key_entry;
> -	int timeout;
>  	u32 offset;
>  
>  	if (crypto->cmd == SET_KEY) {
> @@ -467,12 +461,8 @@ static int rt2800usb_config_pairwise_key
>  		       sizeof(key_entry.rx_mic));
>  
>  		offset = PAIRWISE_KEY_ENTRY(key->hw_key_idx);
> -		timeout = REGISTER_TIMEOUT32(sizeof(key_entry));
> -		rt2x00usb_vendor_request_large_buff(rt2x00dev, USB_MULTI_WRITE,
> -						    USB_VENDOR_REQUEST_OUT,
> -						    offset, &key_entry,
> -						    sizeof(key_entry),
> -						    timeout);
> +		rt2x00usb_register_multiwrite(rt2x00dev, offset,
> +					      &key_entry, sizeof(key_entry));
>  	}
>  
>  	/*
> 


