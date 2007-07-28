Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbXG1Xi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbXG1Xi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 19:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbXG1Xh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 19:37:57 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:53138 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226AbXG1Xhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 19:37:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H+D6eXrdD24Y4FRhV8/BZfECx8D4h6qWHF7p4jFLbb+SCBYqiuDclvTCB40v3K8ZqX0ReFVfD/UlBQZfEnQOXwUd9/0ej7RxvuVwtyp9uHf1VCjHsFVUoSMBLuw9nsqwc/TYWrmQuX2P3Zb3DFV2GFmsu2Uddv2MApfI2On2woI=
Message-ID: <a781481a0707281637n5b123e4aib46c4e4b009b0018@mail.gmail.com>
Date: Sun, 29 Jul 2007 05:07:54 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH] USB Pegasus driver - avoid a potential NULL pointer dereference.
Cc: "Petko Manolov" <petkan@users.sourceforge.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Greg Kroah-Hartman" <greg@kroah.com>,
       linux-usb-devel@lists.sourceforge.net, netdev@vger.kernel.org
In-Reply-To: <200707290019.02591.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707290019.02591.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 7/29/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> Hello,
>
> This patch makes sure we don't dereference a NULL pointer in
> drivers/net/usb/pegasus.c::write_bulk_callback() in the initial
> struct net_device *net = pegasus->net; assignment.
> The existing code checks if 'pegasus' is NULL and bails out if
> it is, so we better not touch that pointer until after that check.
> [...]
> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
> index a05fd97..04cba6b 100644
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -768,11 +768,13 @@ done:
>  static void write_bulk_callback(struct urb *urb)
>  {
>         pegasus_t *pegasus = urb->context;
> -       struct net_device *net = pegasus->net;
> +       struct net_device *net;
>
>         if (!pegasus)
>                 return;
>
> +       net = pegasus->net;
> +
>         if (!netif_device_present(net) || !netif_running(net))
>                 return;

Is it really possible that we're called into this function with
urb->context == NULL? If not, I'd suggest let's just get rid of
the check itself, instead.

Satyam
