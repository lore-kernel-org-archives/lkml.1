Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZAXF7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZAXF7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 00:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbZAXF7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 00:59:21 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:39525 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750789AbZAXF7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 00:59:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O5YdORPryxc3DkXryiip2xoetqPR5TKk5Gmn5Q6+tsqJmMVG3EmpSOorATvjo0L3CSKgZ+fNvtwGmfLxVivIzASAYADH/UOU6Lu9vZSm5YGb9kWnhl1hdSMtru3xZZsX7O1VwzjVbczlRKGBvhgDgOu4sKfWyYr50U61cesQI60=  ;
X-YMail-OSG: 8u_jDvEVM1mZWv9rjwOVODELf8Kvwm_8.x0fweb9MN5PQ044qp4.jujSLITakGc9Wxrgeuow4kkKN79VvJ6A95JwCsolzQTBzRssxShcjH971_dRIY6UTCPWHgSjwTkVXDdDOpKO3to96CzfC8JK0QMG0lkz_zstY4HutizWSpZ1G.KjvpgQ.V0rrB5ixDmt.GxowgaHg4rOms20jWWEojB4tp6xiCRGyytW9w--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 1/2] usb: composite: Fix bug: should test set_alt function pointer before use it
Date: Fri, 23 Jan 2009 21:59:18 -0800
User-Agent: KMail/1.9.10
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1231345279-26618-1-git-send-email-cooloney@kernel.org> <1231345279-26618-2-git-send-email-cooloney@kernel.org>
In-Reply-To: <1231345279-26618-2-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901232159.18863.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2009, Bryan Wu wrote:
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Include a real patch comment -- "test the *correct* function
pointer" would suffice, and:

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
>  drivers/usb/gadget/composite.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index f2da026..363951e 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -772,7 +772,7 @@ composite_setup(struct usb_gadget *gadget, const struct usb_ctrlrequest *ctrl)
>  		f = cdev->config->interface[w_index];
>  		if (!f)
>  			break;
> -		if (w_value && !f->get_alt)
> +		if (w_value && !f->set_alt)
>  			break;
>  		value = f->set_alt(f, w_index, w_value);
>  		break;
> -- 
> 1.5.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


