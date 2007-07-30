Return-Path: <linux-kernel-owner+w=401wt.eu-S939374AbXG3Tpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939374AbXG3Tpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939462AbXG3TpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:45:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52014 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939024AbXG3TpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:45:10 -0400
Message-ID: <46AE3FC0.4020600@garzik.org>
Date: Mon, 30 Jul 2007 15:45:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Micah Gruber <micah.gruber@gmail.com>
CC: petkan@users.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] [2.6.22] Fix a potential NULL pointer dereference in
 write_bulk_callback() in drivers/net/usb/pegasus.c
References: <46A46160.9080508@gmail.com>
In-Reply-To: <46A46160.9080508@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Micah Gruber wrote:
> This patch fixes a potential null dereference bug where we dereference 
> pegasus before a null check. This patch simply moves the dereferencing 
> after the null check.
> 
> Signed-off-by: Micah Gruber <micah.gruber@gmail.com>
> 
> ---
> 
> --- a/drivers/net/usb/pegasus.c
> +++ b/drivers/net/usb/pegasus.c
> @@ -768,11 +768,13 @@
> static void write_bulk_callback(struct urb *urb)
> {
>        pegasus_t *pegasus = urb->context;
> -       struct net_device *net = pegasus->net;
> +       struct net_device *net;
> 
>        if (!pegasus)
>                return;
> 
> +       net = pegasus->net;
> +

applied (manually)


