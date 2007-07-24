Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbXGXNp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbXGXNp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 09:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbXGXNpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 09:45:12 -0400
Received: from n152-u15.estnet.bg ([89.253.152.15]:4713 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757816AbXGXNpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 09:45:11 -0400
X-Greylist: delayed 2695 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jul 2007 09:45:10 EDT
Date: Tue, 24 Jul 2007 15:57:28 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: Micah Gruber <micah.gruber@gmail.com>
cc: petkan@users.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [PATCH] [2.6.22] Fix a potential NULL pointer dereference in
 write_bulk_callback() in drivers/net/usb/pegasus.c
In-Reply-To: <46A46160.9080508@gmail.com>
Message-ID: <Pine.LNX.4.64.0707241557160.6699@bender.nucleusys.com>
References: <46A46160.9080508@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK :-)


cheers,
Petko


On Mon, 23 Jul 2007, Micah Gruber wrote:

> This patch fixes a potential null dereference bug where we dereference 
> pegasus before a null check. This patch simply moves the dereferencing after 
> the null check.
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
>       pegasus_t *pegasus = urb->context;
> -       struct net_device *net = pegasus->net;
> +       struct net_device *net;
>
>       if (!pegasus)
>               return;
>
> +       net = pegasus->net;
> +
>       if (!netif_device_present(net) || !netif_running(net))
>               return;
>
