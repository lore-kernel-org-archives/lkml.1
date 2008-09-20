Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYITQe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYITQe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 12:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbYITQev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 12:34:51 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2357 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750903AbYITQeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 12:34:50 -0400
Date: Sat, 20 Sep 2008 12:34:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: sangsu <sangsu@gmail.com>
cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: g_printer: fix handling zero-length packet
In-Reply-To: <48D44B35.10105@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809201230410.13839-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008, sangsu wrote:

> g_printer doesn't have to check whether the data size is a multiple of
> MaxPacketSize, because device controller driver already make that check.
> 
> Signed-off-by: SangSu Park<sangsu@gmail.com>
> ---
> drivers/usb/gadget/printer.c | 3++-
> 1 files changed, 2 insertion(+), 1 deletions(-)
> 
> 
> --- a/drivers/usb/gadget/printer.c	2008-08-12 21:55:39.000000000 -0400
> +++ b/drivers/usb/gadget/printer.c	2008-09-19 20:39:44.000000000 -0400
> @@ -1264,8 +1264,7 @@
> 	/* respond with data transfer before status phase? */
> 	if (value >= 0) {
> 		req->length = value;
> -		req->zero = value < wLength
> -				&& (value % gadget->ep0->maxpacket) == 0;
> +		req->zero = value < wLength;
> 		value = usb_ep_queue(gadget->ep0, req, GFP_ATOMIC);
> 		if (value < 0) {
> 			DBG(dev, "ep_queue --> %d\n", value);

When posting changes like this you should add Greg KH to the CC: list;  
otherwise he won't realize this patch needs to be merged.

You should also CC: the author of the original code -- but in this case
you can't because Craig Nadler didn't include his email address in the
source file.

For what it's worth, this patch looks okay to me.

Alan Stern

