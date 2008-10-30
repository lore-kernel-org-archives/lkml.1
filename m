Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYJ3Tdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYJ3Tdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYJ3Tdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:33:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:53040 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbYJ3Tdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:33:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nCTlbOWGs9SwqtuUFEWVNwGQD1oEdl+1L8rFG3xQh6J3iOw3Y6un61TvCyeA+Us8vp
         K3GNLiU9AeGj0rkJdqYF71RHu3h2f5muSbU+/nyij08C/ZPZM8D73y9klRftvEy1zQ43
         PIr4iUbHUDPOukoEZ3f0SnvVHXOLReAISoK+E=
Message-ID: <490A0A35.9060606@gmail.com>
Date: Thu, 30 Oct 2008 20:25:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Jiri Kosina <jkosina@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: hid: struct device - replace bus_id with dev_name(), dev_set_name()
References: <1225385705.21973.20.camel@nga.site>
In-Reply-To: <1225385705.21973.20.camel@nga.site>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers napsal(a):
> switch over to the new api, which will remove the 20 bytes array
> and does no longer have a size limitation.

Cool!

> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: hid: struct device - replace bus_id with dev_name(), dev_set_name()
> 
> CC: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
> ---
> 
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 721a36d..73ccc37 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1573,9 +1573,8 @@ int hid_add_device(struct hid_device *hdev)
>  	if (hid_ignore(hdev))
>  		return -ENODEV;
>  
> -	/* XXX hack, any other cleaner solution < 20 bus_id bytes? */
> -	sprintf(hdev->dev.bus_id, "%04X:%04X:%04X.%04X", hdev->bus,
> -			hdev->vendor, hdev->product, atomic_inc_return(&id));
> +	dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
> +		     hdev->vendor, hdev->product, atomic_inc_return(&id));

Could you left the comment above to remind us about removing this ugly hack
later when the new non-limited api will be used?
