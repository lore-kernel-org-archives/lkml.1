Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbXJNSxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbXJNSxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbXJNSxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:53:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50418 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbXJNSxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:53:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47126583.3060803@s5r6.in-berlin.de>
Date: Sun, 14 Oct 2007 20:52:51 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fw-cdev __user annotations
References: <E1Ih8IS-00041I-60@ZenIV.linux.org.uk>
In-Reply-To: <E1Ih8IS-00041I-60@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> --- a/drivers/firewire/fw-cdev.c
> +++ b/drivers/firewire/fw-cdev.c
> @@ -722,10 +722,11 @@ static int ioctl_queue_iso(struct client *client, void *buffer)
>  		buffer_end = 0;
>  	}
>  
> -	if (!access_ok(VERIFY_READ, request->packets, request->size))
> +	p = (struct fw_cdev_iso_packet __user *)u64_to_uptr(request->packets);
> +
> +	if (!access_ok(VERIFY_READ, p, request->size))
>  		return -EFAULT;
>  
> -	p = (struct fw_cdev_iso_packet __user *)u64_to_uptr(request->packets);
>  	end = (void __user *)p + request->size;
>  	count = 0;
>  	while (p < end) {

Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

I will enqueue it in case Linus doesn't pick it up before my next pull
request.
-- 
Stefan Richter
-=====-=-=== =-=- -===-
http://arcgraph.de/sr/
