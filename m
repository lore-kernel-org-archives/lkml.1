Return-Path: <linux-kernel-owner+w=401wt.eu-S1761042AbYEOPho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761042AbYEOPho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYEOPhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:37:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:64705 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYEOPhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZGYkkY80Df4HWRwIykvPzxFFdCSWQVOh1JlPmP3dvgrb4TESmwHkYgcIvjGHnlJk7YB4O6NeZfGAHsuMFKxFLIwDUiTOftZAr49EKO0I3JFlm4jTIiBlvgjlWQpOGJcL7XyC+UjmnkWDkv3ur6D/QiFI6UIM6e//TBRBlDk3SMk=
Subject: Re: [PATCH 1/1] [usb/host]: use get/put_unaligned_* helpers to fix
	more potential unaligned issues.
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: david-b@pacbell.net, greg@kroah.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jie Zhang <jie.zhang@analog.com>
In-Reply-To: <1210832364-20012-1-git-send-email-cooloney@kernel.org>
References: <1210832364-20012-1-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 15 May 2008 08:37:28 -0700
Message-Id: <1210865849.6191.65.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-15 at 14:19 +0800, Bryan Wu wrote:
> Cc: Harvey Harrison <harvey.harrison@gmail.com>

Looks fine.

Reviewed-by: ﻿Harvey Harrison <harvey.harrison@gmail.com>

> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/usb/host/isp116x-hcd.c |    4 ++--
>  drivers/usb/host/uhci-hub.c    |    6 +++---
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
> index 20b9a0d..97ac6ff 100644
> --- a/drivers/usb/host/isp116x-hcd.c
> +++ b/drivers/usb/host/isp116x-hcd.c
> @@ -1024,7 +1024,7 @@ static int isp116x_hub_control(struct usb_hcd *hcd,
>  		break;
>  	case GetHubStatus:
>  		DBG("GetHubStatus\n");
> -		*(__le32 *) buf = 0;
> +		put_unaligned_le32(0, buf);
>  		break;
>  	case GetPortStatus:
>  		DBG("GetPortStatus\n");
> @@ -1033,7 +1033,7 @@ static int isp116x_hub_control(struct usb_hcd *hcd,
>  		spin_lock_irqsave(&isp116x->lock, flags);
>  		tmp = isp116x_read_reg32(isp116x, (--wIndex) ? HCRHPORT2 : HCRHPORT1);
>  		spin_unlock_irqrestore(&isp116x->lock, flags);
> -		*(__le32 *) buf = cpu_to_le32(tmp);
> +		put_unaligned_le32(tmp, buf);
>  		DBG("GetPortStatus: port[%d]  %08x\n", wIndex + 1, tmp);
>  		break;
>  	case ClearPortFeature:
> diff --git a/drivers/usb/host/uhci-hub.c b/drivers/usb/host/uhci-hub.c
> index 8e4427a..801fa99 100644
> --- a/drivers/usb/host/uhci-hub.c
> +++ b/drivers/usb/host/uhci-hub.c
> @@ -253,7 +253,7 @@ static int uhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
>  	switch (typeReq) {
>  
>  	case GetHubStatus:
> -		*(__le32 *)buf = cpu_to_le32(0);
> +		put_unaligned_le32(0, buf);
>  		OK(4);		/* hub power */
>  	case GetPortStatus:
>  		if (port >= uhci->rh_numports)
> @@ -306,8 +306,8 @@ static int uhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
>  			dev_dbg(uhci_dev(uhci), "port %d portsc %04x,%02x\n",
>  					wIndex, status, lstatus);
>  
> -		*(__le16 *)buf = cpu_to_le16(wPortStatus);
> -		*(__le16 *)(buf + 2) = cpu_to_le16(wPortChange);
> +		put_unaligned_le16(wPortStatus, buf);
> +		put_unaligned_le16(wPortChange, buf + 2);
>  		OK(4);
>  	case SetHubFeature:		/* We don't implement these */
>  	case ClearHubFeature:

