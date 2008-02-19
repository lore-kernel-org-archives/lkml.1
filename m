Return-Path: <linux-kernel-owner+w=401wt.eu-S1761900AbYBSCPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761900AbYBSCPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 21:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbYBSCOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 21:14:44 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:41474 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755589AbYBSCOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 21:14:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2PD7qqxT0dtiQkAdRseYPp4i+NDmS3YUTt7pOsAqN/XmvX97fc+5q4eo0XQ+BkRB9/enfd8lOa8GE+KF2Iuu0BJI+CTqY9wDeGxeW79JC5fH2Hdly80WqRg3YmitC4YtxLX2/UoVk+Po046rxI2y1TPcyZF0+8HpZq4wB7UzRBY=  ;
X-YMail-OSG: hT71GgQVM1kzcO9eE9PiQznhM26tAFemFObHLMY3VoxGouNrruDYjGXkCZ6b8pNBdQznEMVkig--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Jan Altenberg <jan.altenberg@linutronix.de>
Subject: Re: [PATCH] queue usb USB_CDC_GET_ENCAPSULATED_RESPONSE message
Date: Mon, 18 Feb 2008 18:14:39 -0800
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <1203381890.3923.60.camel@bender.lan>
In-Reply-To: <1203381890.3923.60.camel@bender.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181814.39402.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008, Jan Altenberg wrote:
> Hi all,
> 
> commit 0cf4f2de0a0f4100795f38ef894d4910678c74f8 introduced a bug, which
> prevents sending an USB_CDC_GET_ENCAPSULATED_RESPONSE message. This
> breaks the RNDIS initialization (especially / only Windoze machines
> dislike this behavior...).
> 
> Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
> Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
>  drivers/usb/gadget/ether.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.24/drivers/usb/gadget/ether.c
> ===================================================================
> --- linux-2.6.24.orig/drivers/usb/gadget/ether.c
> +++ linux-2.6.24/drivers/usb/gadget/ether.c
> @@ -1568,6 +1568,7 @@ done_set_intf:
>  				memcpy(req->buf, buf, n);
>  				req->complete = rndis_response_complete;
>  				rndis_free_response(dev->rndis_config, buf);
> +				value = n;
>  			}
>  			/* else stalls ... spec says to avoid that */
>  		}
> 
> 


