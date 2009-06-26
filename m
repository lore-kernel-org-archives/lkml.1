Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbZFZFWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbZFZFWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 01:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZFZFWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 01:22:31 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:40571 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751288AbZFZFWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 01:22:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nFbqOVd1bjtG41u0iK2xb8wABWFMwBHccv3T1d7vXbKYjHBkM0FjzLOZZQcEKHueKyrb1SlXvhNTi+jcCyLN2gO+HihffIXIX16aXEl4ewDcyCstv6RYoEnBzlJpJxIrWg7rG+4yRBRRawRcW6/hUyyZcJ5COaR63hudRZPGT0E=  ;
X-YMail-OSG: GKN3c2EVM1mqvRYQGT_H8hEW14agm6OnqRCFtXPt6NvQ_8UkBSOdNQU32UDBeNNW4tj.8hIb37XbghCbtPSNylEv_i62wHHz1VeBal8gatMyyXVgHpx9Cf.Z2l.rBRL2m4zbMSghMMJDUFdtPc8uHzAr1gBHGCcwLMNnt6ruXa.mJIj6DZ1aYLbY4qE2ROyVuAV2xfpkq3aqnTO5qB4zpl9.GRZF5Czd6wLDeG8diIfhmp6Tf3x9_ws5VAf3DreSO6gwTNgM5coJ8aLmVKAit__Oge84zQNWAMVaObzSYcVQ1pgG53ozpmLrog--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 2/3 v3] at91/USB: modify OHCI driver to allow shared interrupts
Date: Thu, 25 Jun 2009 22:22:33 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, avictor.za@gmail.com,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       patrice.vilchez@atmel.com
References: <200906190045.16496.david-b@pacbell.net> <1245776317-7134-2-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1245776317-7134-2-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906252222.33471.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Nicolas Ferre wrote:
> At91sam9g45 series has a set of high speed USB interfaces.
> The host driver is an EHCI with its companion OHCI. OHCI is
> always handled by ohci-at91.c.
> This wrapper is just modified to allow IRQ sharing
> between two controllers.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
> v2 -> v3: split patch to:
> - gadget
> - ohci
> - ehci
> 
>  drivers/usb/host/ohci-at91.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index bb5e6f6..7ccffcb 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -148,7 +148,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
>  	at91_start_hc(pdev);
>  	ohci_hcd_init(hcd_to_ohci(hcd));
>  
> -	retval = usb_add_hcd(hcd, pdev->resource[1].start, IRQF_DISABLED);
> +	retval = usb_add_hcd(hcd, pdev->resource[1].start, IRQF_SHARED);
>  	if (retval == 0)
>  		return retval;
>  
> -- 
> 1.5.3.7
> 
> 


